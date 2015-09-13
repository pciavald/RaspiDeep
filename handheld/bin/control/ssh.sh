#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sshpass -praspberry ssh -o StrictHostKeyChecking=no pi@192.168.42.1 $1
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
