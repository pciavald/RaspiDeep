#!/bin/sh

sudo service camstream stop
sudo service hostapd stop
sudo service udhcpd stop
sudo ifdown --force wlan0
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if [ -f /home/pi/record.sh ]; then
	sleep 1
	echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	sleep 1
	echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	sleep 1
	echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
	n=0;
	while ! mkdir /home/pi/capture$n
	do
		n=$((n+1))
	done;
	/home/pi/record.sh $n &
fi
