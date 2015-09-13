#!/bin/sh

connect.sh
ssh.sh "
rm -rf /home/pi/capture*
rm /home/pi/record.sh"
#TODO display remaining space on card
disconnect.sh
