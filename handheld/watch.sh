#!/bin/sh

echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo ifup wlan0
sleep 3
#check for connection TODO
mplayer -demuxer lavf "http://192.168.42.1:5001/?action=stream&video_name=stream.mjpg"
sudo ifdown wlan0
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
