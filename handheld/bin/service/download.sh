#!/bin/sh

connect.sh
if -e 0 [ df -h | grep sda ]
	sudo sshpass -praspbery scp -r pi@192.168.42.1:/home/pi/capture* /mnt
disconnect.sh
pcmanfm /mnt
