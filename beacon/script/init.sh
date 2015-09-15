#!/bin/sh

echo none | sudo tee /sys/class/leds/led0/trigger > /dev/null
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo none | sudo tee /sys/class/leds/led1/trigger > /dev/null
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
$RASPIDEEP/script/passive_mode.sh
sudo $RASPIDEEP/sensor $RASPIDEEP
