#!/bin/sh

# network setup
SSID=Ocean71
PWD=Raspberry71

# start X on PiTFT
sudo mv /usr/share/X11/xorg.conf.d/99-fbturbo.conf ~ 2> /dev/null
sudo echo '
Section "Device"
  Identifier "Adafruit PiTFT"
  Driver "fbdev"
  Option "fbdev" "/dev/fb1"
EndSection' > /usr/share/X11/xorg.conf.d/99-pitft.conf

# network setup
sudo echo '
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
auto wlan0
  allow-hotplug wlan0
  iface wlan0 inet dhcp
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
  iface default inet dhcp' > /etc/network/interfaces

# auto-connect to master
sudo echo "
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid=$SSID
psk=$PWD
proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
auth_alg=OPEN
}" > /etc/wpa_supplicant/wpa_supplicant.conf

