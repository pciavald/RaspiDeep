#!/bin/sh

connect.sh
ssh pi@192.168.42.1 "rm /home/pi/RaspiDeep/record.sh"
disconnect.sh
