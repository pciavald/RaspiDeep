#!/bin/sh
sudo sh -c "echo 1 > /sys/class/leds/led1/brightness"
sudo ifup wlan0
#check key TODO
sudo scp -r -i /home/pi/.ssh/id_rsa pi@192.168.42.1:/home/pi/RaspiDeep/beacon/capture* /mnt
sudo ifdown wlan0
pcmanfm /mnt
sudo sh -c "echo 0 > /sys/class/leds/led1/brightness"
