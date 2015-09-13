if ! df -h | grep sda ; then
	sudo umount /dev/sda1
	mkntfs -Q /dev/sda1
	mountKey.sh
fi
