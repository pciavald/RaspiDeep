if ! df -h | grep sda ; then
	sudo umount /dev/sda1
fi
