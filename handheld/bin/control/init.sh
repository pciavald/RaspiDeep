#!/bin/sh

echo 508	| sudo tee /sys/class/gpio/export
echo 'out'	| sudo tee /sys/class/gpio/gpio508/direction
echo '1'	| sudo tee /sys/class/gpio/gpio508/value
echo 0		| sudo tee /sys/class/leds/led1/brightness
sudo ifdown wlan0
tightvncserver &
