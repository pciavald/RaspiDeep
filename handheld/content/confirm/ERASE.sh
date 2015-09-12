#!/bin/sh

connect.sh
ssh.sh "
sudo rm -rf /home/pi/RaspiDeep/capture*
sudo rm /home/pi/RaspiDeep/record.sh"
disconnect.sh
