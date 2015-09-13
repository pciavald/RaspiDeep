if ! df -h | grep sda ; then
	umount /dev/sda1
fi
