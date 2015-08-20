# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    slave.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/17 05:57:41 by pciavald          #+#    #+#              #
#    Updated: 2015/05/17 07:39:15 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

SSID=Ocean71
PWD=Raspberry71

echo "setting locales to fr_FR..."
if ! grep -q "fr_FR" /home/pi/.profile; then
	echo "
	export LANGUAGE=fr_FR.UTF-8
	export LANG=fr_FR.UTF-8
	export LC_ALL=fr_FR.UTF-8
	export LC_CTYPE=fr_FR.UTF-8" >> /home/pi/.profile
fi
locale-gen fr_FR.UTF-8
. /home/pi/.profile
dpkg-reconfigure locales

sudo rpi-update
sudo apt-get update
sudo apt-get install mplayer vim tightvncserver

sudo echo '
Section "Device"
  Identifier "Adafruit PiTFT"
  Driver "fbdev"
  Option "fbdev" "/dev/fb1"
EndSection' > /usr/share/X11/xorg.conf.d/99-pitft.conf

sudo echo "
BLANK_TIME=0
BLANK_DPMS=off
POWERDOWN_TIME=0" > /etc/kbd/config

sudo echo "
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
iface wlan0 inet static
  address 192.168.42.2" > /etc/network/interfaces
echo $SSID | wpa_passphrase $PWD | sudo tee /etc/wpa_supplicant.conf

sudo raspi-config
