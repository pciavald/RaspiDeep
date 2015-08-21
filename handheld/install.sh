# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    slave.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/17 05:57:41 by pciavald          #+#    #+#              #
#    Updated: 2015/08/21 16:28:15 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# settings for WiFi access point
SSID="Ocean71"
PWD="Raspberry71"

LOCALE="fr_FR"

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

sudo raspi-config
sudo rpi-update

DIR=`pwd`
cd /home/pi

echo "setting locales to $LOCALE.UTF-8..."
if ! grep -q "$LOCALE" /home/pi/.profile; then
	echo "
	export RASPIDEEP=$DIR
	export LANGUAGE=$LOCALE.UTF-8
	export LANG=$LOCALE.UTF-8
	export LC_ALL=$LOCALE.UTF-8
	export LC_CTYPE=$LOCALE.UTF-8" >> /home/pi/.profile
	. /home/pi/.profile
	sudo sed -i "s/^# $LOCALE.UTF-8/$LOCALE.UTF-8/" /etc/locale.gen
	sudo locale-gen
	sudo update-locale LANG=$LOCALE.UTF-8
fi

if ! grep -q "READY" /home/pi/.profile; then
	echo "preparing installation for reboots..."
	echo "
	### BEGIN INIT INFO
	# Provides:          installer
	# Required-Start:    $local_fs $network
	# Required-Stop:     $local_fs
	# Default-Start:     2 3 4 5
	# Default-Stop:      0 1 6
	# Short-Description: installer
	# Description:       handles installation reboots
	### END INIT INFO
	#!/bin/sh

	rm /etc/init.d/install.sh
	update-rc.d install.sh remove
	echo 'export READY' > /home/pi/.profile
	rpi-update
	reboot

	" | sudo tee /etc/init.d/install.sh > /dev/null
	sudo chmod 755 /etc/init.d/install.sh
	sudo update-rc.d install.sh defaults
	sudo raspi-config
fi

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install mplayer vim tightvncserver

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
