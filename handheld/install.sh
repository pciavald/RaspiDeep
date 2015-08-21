#!/bin/sh

# settings for WiFi access point
SSID="Ocean71"
PWD="Raspberry71"

LOCALE="fr_FR"

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

DIR=`pwd`
if ! grep -q "RASPIDEEP" /home/pi/.profile > /dev/null; then
	echo "export RASPIDEEP=$DIR" >> /home/pi/.profile
	sudo rpi-update
	sudo raspi-config
	sudo reboot
	exit 0
fi

echo "setting locales to $LOCALE.UTF-8..."
if ! grep -q "$LOCALE" /home/pi/.profile > /dev/null; then
	echo "
	export LANGUAGE=$LOCALE.UTF-8
	export LANG=$LOCALE.UTF-8
	export LC_ALL=$LOCALE.UTF-8
	export LC_CTYPE=$LOCALE.UTF-8" >> /home/pi/.profile
	. /home/pi/.profile
	sudo sed -i "s/^# $LOCALE.UTF-8/$LOCALE.UTF-8/" /etc/locale.gen
	sudo locale-gen
	sudo update-locale LANG=$LOCALE.UTF-8
fi

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get -y install mplayer vim tightvncserver

echo "setting up PiTFT..."
echo '
Section "Device"
  Identifier "Adafruit PiTFT"
  Driver "fbdev"
  Option "fbdev" "/dev/fb1"
EndSection' | sudo tee /usr/share/X11/xorg.conf.d/99-pitft.conf > /dev/null
echo "
BLANK_TIME=0
BLANK_DPMS=off
POWERDOWN_TIME=0" | sudo tee /etc/kbd/config > /dev/null

echo "setting up interfaces..."
echo "
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
iface wlan0 inet static
  address 192.168.42.2" | sudo tee /etc/network/interfaces > /dev/null
echo $SSID | wpa_passphrase $PWD | sudo tee /etc/wpa_supplicant.conf > /dev/null

echo "installing desktop shortcuts"
sudo rm -r /home/pi/Desktop /home/pi/confirm > /dev/null
cp -r $DIR/Desktop $DIR/confirm /home/pi
