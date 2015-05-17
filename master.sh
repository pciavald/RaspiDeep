#!/bin/sh

#http://wiki.rg.net/wiki/RaspberryAP
#http://elinux.org/RPI-Wireless-Hotspot
#http://blog.sip2serve.com/post/38010690418/raspberry-pi-access-point-using-rtl8192cu
# CA4D513F32A613CDFCA7F55551A22A

# settings for WiFi access point
SSID="Ocean71"
PWD="Raspberry71"

cd ~
echo "setting locales to fr_FR..."
if ! grep -q "fr_FR" .profile; then
	echo "
	export LANGUAGE=fr_FR.UTF-8
	export LANG=fr_FR.UTF-8
	export LC_ALL=fr_FR.UTF-8
	export LC_CTYPE=fr_FR.UTF-8" >> .profile
fi
locale-gen fr_FR.UTF-8
. .profile
dpkg-reconfigure locales

echo "upgrading and installing software..."
sudo apt-get update
sudo apt-get autoremove -y sonic-pi
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y hostapd udhcpd vim build-essential tightvncserver

if ! ls /usr/sbin/hostapd.FCS; then
	echo "getting the right version of hostapd..."
	wget http://dl.dropbox.com/u/1663660/hostapd/hostapd
	sudo chown root:root hostapd
	sudo chmod 755 hostapd
	sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.FCS
	sudo mv hostapd /usr/sbin/hostapd
fi

echo "generating /etc/udhcpd.conf..."
sudo echo "
start 192.168.42.2
end 192.168.42.20
interface wlan0
remaining yes
opt dns 8.8.8.8 4.2.2.2
opt subnet 255.255.255.0
opt router 192.168.42.1
opt lease 864000" > /etc/udhcpd.conf

echo "generating /etc/default/udhcpd..."
sudo echo '
DHCPD_OPTS="-S"' > /etc/default/udhcpd

echo "configuring interfaces..."
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

if ! grep -q "\nauthoritative"; then
	echo "make it responsible for its network..."
	sudo echo "
	authoritative" >> /etc/dhcp/dhcpd.conf
fi

echo "generating /etc/hostapd/hostapd.conf..."
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

echo "generating /etc/default/hostapd..."
sudo echo '
DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

echo "starting hostapd and udhcpd..."
sudo service hostapd start
sudo service udhcpd start
echo "enabling hostapd and udhcpd at startup..."
sudo update-rc.d hostapd enable
sudo update-rc.d udhcpd enable

echo "configuring and enabling vnc server..."
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
