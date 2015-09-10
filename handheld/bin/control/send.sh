#!/bin/sh

connect.sh
ssh -o StrictHostKeyChecking=no pi@192.168.42.1 "
rm /home/pi/RaspiDeep/record.sh 2> /dev/null
$1 > /home/pi/RaspiDeep/record.sh
chmod 755 /home/pi/RaspiDeep/record.sh"
disconnect.sh
