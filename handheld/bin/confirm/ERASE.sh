#!/bin/sh

connect.sh
ssh pi@192.168.42.1 '
sudo rm -rf /home/pi/RaspiDeep/capture*
sudo rm /home/pi/RaspiDeep/record.sh'
disconnect.sh
