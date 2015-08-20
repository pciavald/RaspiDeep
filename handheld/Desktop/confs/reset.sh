#!/bin/sh
sudo sh -c "echo 1 > /sys/class/leds/led1/brightness"
sudo ifup wlan0
ssh pi@192.168.42.1 "sudo rm /home/pi/RaspiDeep/record.sh"
sudo ifdown wlan0
sudo sh -c "echo 0 > /sys/class/leds/led1/brightness"
