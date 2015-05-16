#!/bin/sh

#http://wiki.rg.net/wiki/RaspberryAP
#http://elinux.org/RPI-Wireless-Hotspot
#http://blog.sip2serve.com/post/38010690418/raspberry-pi-access-point-using-rtl8192cu
# CA4D513F32A613CDFCA7F55551A22A

# settings for WiFi access point
SSID="Ocean71"
PWD="Raspberry71"

# set locales
export LANGUAGE=fr_FR.UTF-8
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
locale-gen fr_FR.UTF-8
dpkg-reconfigure locales

# add source for TFT and update apt
#curl -SLs https://apt.adafruit.com/add | sudo bash

# upgrade and install software
sudo apt-get update
sudo apt-get autoremove sonic-pi
sudo apt-get upgrade -y
sudo apt-get dist-upgrade
sudo apt-get install -y hostapd udhcpd vim build-essential tightvncserver

# get the TFT ready
#cd
#wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-bin-adafruit.deb
#wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-dev-adafruit.deb
#wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-doc-adafruit.deb
#wget http://adafruit-download.s3.amazonaws.com/libraspberrypi0-adafruit.deb
#wget http://adafruit-download.s3.amazonaws.com/raspberrypi-bootloader-adafruit-112613.deb
#sudo dpkg -i -B *.deb
#rm *.deb
#sudo mv /usr/share/X11/xorg.conf.d/99-fbturbo.conf ~
#sudo echo "
#spi-bcm2708
#fbtft_device" >> /etc/modules
#sudo echo "
#options fbtft_device name=adafruitts rotate=90 frequency=32000000
#" >> /etc/modprobe.d/adafruit.conf
#sudo echo "export FRAMEBUFFER=/dev/fb1" >> .profile

# get the TFT ready
#sudo adafruit-pitft-helper -t 28r

# get the right version of hostapd
wget http://dl.dropbox.com/u/1663660/hostapd/hostapd
sudo chown root:root hostapd
sudo chmod 755 hostapd
sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.FCS
sudo mv hostapd /usr/sbin/hostapd

# udhcpd.conf
sudo echo "
start 192.168.42.2
end 192.168.42.20
interface wlan0
remaining yes
opt dns 8.8.8.8 4.2.2.2
opt subnet 255.255.255.0
opt router 192.168.42.1
opt lease 864000" > /etc/udhcpd.conf

# udhcpd
sudo echo '
DHCPD_OPTS="-S"' > /etc/default/udhcpd

# configuring interfaces
sudo ifconfig wlan0 192.168.42.1
sudo echo "
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
iface wlan0 inet static
  address 192.168.42.1
  netmask 255.255.255.0
auto wlan1
  iface wlan1 inet dhcp" > /etc/network/interfaces

# make it responsible for its network
sudo echo "
authoritative" >> /etc/dhcp/dhcpd.conf

# hostapd.conf
sudo echo "
interface=wlan0
driver=rtl871xdrv
ssid=$SSID
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$PWD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf

# hostapd
sudo echo '
DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

# starting services
sudo service hostapd start
sudo service udhcpd start

# enable at startup
sudo update-rc.d hostapd enable
sudo update-rc.d udhcpd enable

# enable vnc at startup
sudo echo '
### BEGIN INIT INFO
# Provides: vncboot
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start VNC Server at boot time
# Description: Start VNC Server at boot time.
### END INIT INFO

#! /bin/sh
# /etc/init.d/vncboot

USER=pi
HOME=/home/pi

export USER HOME

case "$1" in
 start)
  echo "Starting VNC Server"
  #Insert your favoured settings for a VNC session
  su - pi -c "/usr/bin/vncserver :0 -geometry 1280x800 -depth 16 -pixelformat rgb565"
  ;;

 stop)
  echo "Stopping VNC Server"
  /usr/bin/vncserver -kill :0
  ;;

 *)
  echo "Usage: /etc/init.d/vncboot {start|stop}"
  exit 1
  ;;
esac

exit 0' > /etc/init.d/vncboot
sudo chmod 755 /etc/init.d/vncboot
sudo update-rc.d vncboot defaults
tightvncserver

sudo raspi-config
