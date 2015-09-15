echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo umount /dev/sda1
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
