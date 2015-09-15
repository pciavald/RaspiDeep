#!/bin/sh

connect.sh
if ls /dev | grep -q sda1; then
	mountKey.sh
	$RASPIDEEP/bin/service/sshpass -praspberry scp -r pi@192.168.42.1:/home/pi/capture* /mnt
fi
disconnect.sh
pcmanfm /mnt
