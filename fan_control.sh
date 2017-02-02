#!/bin/sh
STATE=0
STATE_OLD=0
MAX_TEMP=0

regula_fan()
{
	if [ $MAX_TEMP -le 40 ]
	then STATE=0
	elif [ $MAX_TEMP -ge 45 ] && [ $MAX_TEMP -le 50 ]
	then STATE=1
	elif [ $MAX_TEMP -ge 55 ] && [ $MAX_TEMP -le 60 ]
	then STATE=2
	elif [ $MAX_TEMP -ge 65 ]
	then STATE=3
	elif [ $MAX_TEMP -gt 40 ] && [ $MAX_TEMP -le 45 ] && [ $STATE_OLD -ge 1 ]
	then STATE=1
	elif [ $MAX_TEMP -gt 50 ] && [ $MAX_TEMP -le 55 ] && [ $STATE_OLD -ge 2 ]
	then STATE=2
	elif [ $MAX_TEMP -gt 60 ] && [ $MAX_TEMP -le 65 ] && [ $STATE_OLD -ge 3 ]
	then STATE=3
	fi
	
	case $STATE in
		0) echo level 0 >/proc/acpi/ibm/fan;;
		1) echo level 1 >/proc/acpi/ibm/fan;;
		2) echo level 2 >/proc/acpi/ibm/fan;;
		3) echo level 4 >/proc/acpi/ibm/fan;;
	esac
	STATE_OLD=$STATE
}

while [ 1 ]
do
	MAX_TEMP=$(sensors | grep Physical |awk '{print $4}'|cut -c 2-3)
	regula_fan
	sleep 10
done 
