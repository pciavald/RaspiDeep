#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness
sudo ifup wlan0
