#!/bin/bash
#--------------------------------------
#    ___                   ________
#   / _ )___ __________ __/ ___/ (_)__
#  / _  / -_) __/ __/ // / /__/ / / _ \
# /____/\__/_/ /_/  \_, /\___/_/_/ .__/
#                  /___/        /_/
#
#       BerryClip - 6 LED Board
#
# This script uses 6 LEDs to display the
# current CPU usage.
#
# Author : Matt Hawkins
# Date   : 12/05/2013
#
# http://www.raspberrypi-spy.co.uk/
#
# Original script created by chteuchteu
# http://www.chteuchteu.com/
#
# Modified by Matt Hawkins to use the 6 LEDs
# on the BerryClip addon board.
#
# BerryClip LED reference :
# LED 1  - Pin 7  - GPIO4
# LED 2  - Pin 11 - GPIO17
# LED 3  - Pin 15 - GPIO22
# LED 4  - Pin 19 - GPIO10
# LED 5  - Pin 21 - GPIO9
# LED 6  - Pin 23 - GPIO11
#
#--------------------------------------

# Create array of GPIO references
led[1]="11"
led[2]="9"
led[3]="10"
led[4]="22"
led[5]="17"
led[6]="4"

# Configure GPIOs to be outputs
echo ${led[1]} > /sys/class/gpio/export 2> /dev/null
echo ${led[2]} > /sys/class/gpio/export 2> /dev/null
echo ${led[3]} > /sys/class/gpio/export 2> /dev/null
echo ${led[4]} > /sys/class/gpio/export 2> /dev/null
echo ${led[5]} > /sys/class/gpio/export 2> /dev/null
echo ${led[6]} > /sys/class/gpio/export 2> /dev/null
echo "out" > /sys/class/gpio/gpio${led[1]}/direction
echo "out" > /sys/class/gpio/gpio${led[2]}/direction
echo "out" > /sys/class/gpio/gpio${led[3]}/direction
echo "out" > /sys/class/gpio/gpio${led[4]}/direction
echo "out" > /sys/class/gpio/gpio${led[5]}/direction
echo "out" > /sys/class/gpio/gpio${led[6]}/direction

#################################################
#                   FUNCTIONS                   #
#################################################

number=0
gpio=0

function LEDON {
  # Turn ON the LED "number"

  gpio=${led[number]}

  echo "1" > /sys/class/gpio/gpio$gpio/value
  number=0
  gpio=0
}
function LEDOFF {
  # Allow you to turn off the del (the number of the del is contained in "number")
  # number  pin is done at the begining of the function

  gpio=${led[number]}

  echo "0" > /sys/class/gpio/gpio$gpio/value
  number=0
  gpio=0
}

function allON
{
  # Turn ON all the LEDs
  for i in {1..6}
  do
     number=i ; LEDON
  done

}
function allOFF
{
  # Turn OFF all the LEDs
  for i in {1..6}
  do
     number=i ; LEDOFF
  done

}
function flash
{
  counter=0
  while [ $counter -le $1 ]
  do
    allON ; sleep 0.2
    allOFF ; sleep 0.2
    counter=$(( $counter + 1 ))
  done

}

#################################################
#                   MAIN CODE                   #
#################################################

# Turn ON all LEDs in sequence
number=1 ; LEDON ; sleep 0.2
number=2 ; LEDON ; sleep 0.2
number=3 ; LEDON ; sleep 0.2
number=4 ; LEDON ; sleep 0.2
number=5 ; LEDON ; sleep 0.2
number=6 ; LEDON ; sleep 1

# Turn all LEDs OFF
allOFF

# Flash the LEDs 5 times
flash 5

# Start main loop
while true ; do

  # Obtain the current CPU usage percentage
  idle=`vmstat 2 3 | tail -n1 | sed "s/\ \ */\ /g" | cut -d' ' -f 16`
  cpu=$(( 100 - idle ))

  # Switch the LEDs ON or OFF the "cpu" value
  allOFF
  if [ ${cpu} -lt 5 ] ; then
    allOFF
  elif [ ${cpu} -lt 23 ] ; then
    number=1   ; LEDON
  elif [ ${cpu} -lt 41 ] ; then
    number=1   ; LEDON
    number=2   ; LEDON
  elif [ ${cpu} -lt 59 ] ; then
    number=1   ; LEDON
    number=2   ; LEDON
    number=3   ; LEDON
  elif [ ${cpu} -lt 77 ] ; then
    number=1   ; LEDON
    number=2   ; LEDON
    number=3   ; LEDON
    number=4   ; LEDON
  elif [ ${cpu} -lt 95 ] ; then
    number=1   ; LEDON
    number=2   ; LEDON
    number=3   ; LEDON
    number=4   ; LEDON
    number=5   ; LEDON
  else
    number=1   ; LEDON
    number=2   ; LEDON
    number=3   ; LEDON
    number=4   ; LEDON
    number=5   ; LEDON
    number=6   ; LEDON
  fi

done

# Turn all LEDs OFF
allOFF

exit 0