echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if ls /dev | grep -q sda1; then
	sudo umount /dev/sda1
	sudo mkntfs -Q /dev/sda1
	mountKey.sh
fi
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
