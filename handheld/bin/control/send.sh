#!/bin/sh

connect.sh
ssh.sh "
rm /home/pi/RaspiDeep/record.sh 2> /dev/null;
$1 > /home/pi/RaspiDeep/record.sh;
chmod 755 /home/pi/RaspiDeep/record.sh;"
disconnect.sh
