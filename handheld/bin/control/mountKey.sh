KEYDEV=sda1

if ls /dev | grep -q $KEYDEV; then
	if df -h | grep $KEYDEV; then
		sudo umount /dev/$KEYDEV
	fi
	sudo mount /dev/$KEYDEV /mnt
fi
