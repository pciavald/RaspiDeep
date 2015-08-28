#!/bin/sh

echo none >/sys/class/leds/led0/trigger
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo none >/sys/class/leds/led1/trigger
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
$RASPIDEEP/script/passive_mode.sh
$RASPIDEEP/sensor $RASPIDEEP
