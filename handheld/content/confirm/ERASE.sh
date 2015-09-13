#!/bin/sh

connect.sh
ssh.sh "
rm -rf /home/pi/RaspiDeep/capture*
rm /home/pi/RaspiDeep/record.sh"
#TODO display remaining space on card
disconnect.sh
