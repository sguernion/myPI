#!/bin/bash

sudo apt-get install  libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils

git clone https://github.com/njh/perl-net-sdp.git perl-net-sdp
cd perl-net-sdp/
perl Build.PL
./Build
./Build test
sudo ./Build install

cd ..

git clone https://github.com/albertz/shairport.git shairport
cd shairport/
make
sudo make install


#shairport.pl -a ShairPort