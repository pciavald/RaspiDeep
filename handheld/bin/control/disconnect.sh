#!/bin/sh

sudo ifdown wlan0
echo 0 | sudo tee /sys/class/leds/led1/brightness
