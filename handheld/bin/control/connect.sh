#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo ifup wlan0
