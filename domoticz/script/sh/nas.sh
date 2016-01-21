 #!/bin/bash
 
 # Settings
 #https://www.domoticz.com/wiki/NAS_Monitoring#Enable_SNMP_on_your_Synology_NAS

 NASIP=""                   # NAS IP Address
 PASSWORD=""                # SNMP Password
 DOMO_IP=""                 # Domoticz IP Address
 DOMO_PORT=""               # Domoticz Port
 NAS_IDX=""                 # NAS Switch IDX
 NAS_HD1_TEMP_IDX=""        # NAS HD1 Temp IDX
 NAS_HD2_TEMP_IDX=""        # NAS HD2 Temp IDX
 NAS_HD_SPACE_IDX=""        # NAS HD Space IDX in Go
 NAS_HD_SPACE_PERC_IDX=""   # NAS HD Space IDX in %
 NAS_CPU_IDX=""             # NAS CPU IDX
 NAS_MEM_IDX=""             # NAS MEM IDX
 
 
 # Check if NAS in online 
   	curl -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=devices&rid=$NAS_IDX" | grep "Status" | grep "On" > /dev/null
 
       if [ $? -eq 0 ] ; then
        echo "NAS already ON"
 
        # Temperature HD1
        HDtemp1=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.6574.2.1.1.6.0`
        # Send data
        curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_HD1_TEMP_IDX&nvalue=0&svalue=$HDtemp1"
 
        # Temperature HD2
        HDtemp2=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.6574.2.1.1.6.1`
        # Send data
        curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_HD2_TEMP_IDX&nvalue=0&svalue=$HDtemp2"
 
        # Free space volume in Go
        HDUnit=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.2.1.25.2.3.1.4.38`  # Change OID to .38 on DSM 5.1
        HDTotal=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.2.1.25.2.3.1.5.38` # Change OID to .38 on DSM 5.1
        HDUsed=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.2.1.25.2.3.1.6.38`  # Change OID to .38 on DSM 5.1
        HDFree=$((($HDTotal - $HDUsed) * $HDUnit / 1024 / 1024 / 1024))
        # Send data
        curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_HD_SPACE_IDX&nvalue=0&svalue=$HDFree"
 
        # Free space volume in percent
     	HDFreePerc=$((($HDUsed * 100) / $HDTotal))
        # Send data
        curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_HD_SPACE_PERC_IDX&nvalue=0&svalue=$HDFreePerc"
 
	# CPU utilisation
        CpuUser=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.11.9.0`
	CpuSystem=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.11.10.0`
	CpuUse=$(($CpuUser + $CpuSystem))
        # Send data
        curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_CPU_IDX&nvalue=0&svalue=$CpuUse"
 
        # Free Memory Available in %
	MemAvailable=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.4.6.0`
        Memtotal=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.4.5.0`
        MemShared=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.4.13.0`
        MemBuffer=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.4.14.0`
        MemCached=`snmpget -v 2c -c $PASSWORD -O qv $NASIP 1.3.6.1.4.1.2021.4.15.0`
        MemFREE=$(($MemAvailable + $MemShared + $MemBuffer + $MemCached))
        MemUsepercent=$(((($Memtotal - $MemFREE) * 100) / $Memtotal))
        # Send data
       curl -s -i -H "Accept: application/json" "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$NAS_MEM_IDX&nvalue=0&svalue=$MemUsepercent"

     fi
