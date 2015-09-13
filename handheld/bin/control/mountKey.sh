KEYDEV=sda1

echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if ls /dev | grep -q $KEYDEV; then
	if df -h | grep $KEYDEV; then
		sudo umount /dev/$KEYDEV
	fi
	sudo mount /dev/$KEYDEV /mnt
fi
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
