#!/bin/sh

# init screen backlight control
sudo sh -c "echo 508 > /sys/class/gpio/export"
sudo sh -c "echo 'out' > /sys/class/gpio/gpio508/direction"
sudo sh -c "echo '1' > /sys/class/gpio/gpio508/value"
sudo sh -c "echo 0 > /sys/class/leds/led1/brightness"
ifdown wlan0
tightvncserver &
