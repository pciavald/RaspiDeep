#!/bin/sh

sudo service camstream stop
sudo service hostapd stop
sudo service udhcpd stop
sudo ifconfig wlan0 down
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if [ -f $RASPIDEEP/record.sh ]; then
	sleep 1
	echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	sleep 1
	echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	sleep 1
	echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	n=0;
	while ! mkdir /home/pi/RaspiDeep/capture$n
	do
		n=$((n+1))
	done;
	sudo $RASPIDEEP/record.sh $n &
fi
