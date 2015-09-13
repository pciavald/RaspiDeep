echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if ! df -h | grep sda ; then
	sudo umount /dev/sda1
	mkntfs -Q /dev/sda1
	mountKey.sh
fi
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
