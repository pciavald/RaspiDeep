#!/bin/sh

sudo ifdown --force wlan0
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
