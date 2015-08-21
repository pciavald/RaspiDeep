#!/bin/sh

echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo pkill raspistill
sudo pkill raspivid
sudo ifconfig wlan0 up
sudo service hostapd start
sudo service udhcpd start
sudo service camstream start
echo 1 | sudo tee /sys/class/leds/led0/brightness > /dev/null
