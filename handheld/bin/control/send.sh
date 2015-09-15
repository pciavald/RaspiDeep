#!/bin/sh

connect.sh
ssh.sh "\
rm /home/pi/record.sh 2> /dev/null;
echo \"$1\" > /home/pi/record.sh;
chmod 755 /home/pi/record.sh;"
disconnect.sh
