#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo ifup --force wlan0 2> /dev/null
while ! ping -c1 192.168.42.1; do
	sudo ifdown --force wlan0
	sudo ifup --force wlan0
	sleep 1
done
