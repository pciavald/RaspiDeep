#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness
sudo ifup wlan0
while ! ping -c1 192.168.42.1 ; do
	sudo ifdown wlan0
	sudo ifup wlan0
done;
