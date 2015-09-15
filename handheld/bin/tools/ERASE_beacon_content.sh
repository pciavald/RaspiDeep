#!/bin/sh

connect.sh
ssh.sh "
sudo rm -rf /home/pi/capture*
sudo rm /home/pi/record.sh"
#TODO display remaining space on card
disconnect.sh
