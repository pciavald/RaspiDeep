#!/bin/sh

#http://wiki.rg.net/wiki/RaspberryAP
#http://elinux.org/RPI-Wireless-Hotspot
#http://blog.sip2serve.com/post/38010690418/raspberry-pi-access-point-using-rtl8192cu
#http://stephane.lavirotte.com/perso/rov/video_streaming.html
# CA4D513F32A613CDFCA7F55551A22A

# settings for WiFi access point
SSID="Ocean71"
PWD="Raspberry71"

#TZ="Europe/Paris"
LOCALE="fr_FR"

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

sudo rpi-update
sudo raspi-config

./make.sh
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

echo "upgrading and installing software..."
sudo apt-get update
sudo apt-get autoremove -y sonic-pi
sudo apt-get dist-upgrade -y
sudo apt-get install -y hostapd udhcpd vim build-essential tightvncserver htop

echo "installing UV4L..."
if ! grep -q "uv4l" /etc/apt/sources.list; then
	echo "adding deb source for uv4l..."
	wget -qO- http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc | sudo apt-key add -
	echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ wheezy main" \
		| sudo tee --append /etc/apt/sources.list
	sudo apt-get update
fi
sudo apt-get install -y uv4l
sudo apt-get install -y uv4l-raspicam uv4l-uvc uv4l-mjpegstream uv4l-raspicam-extras

echo "installing mjpg-streamer..."
sudo apt-get install -y libjpeg8-dev imagemagick subversion
if ! ls /home/pi/mjpg-streamer; then
	mkdir /home/pi/mjpg-streamer && cd /home/pi/mjpg-streamer
	svn co https://svn.code.sf.net/p/mjpg-streamer/code/mjpg-streamer/ .
	sudo make
	sudo make install
fi

if ! sudo ls /usr/sbin/hostapd.FCS; then
	echo "getting the right version of hostapd..."
	wget http://dl.dropbox.com/u/1663660/hostapd/hostapd
	sudo chown root:root hostapd
	sudo chmod 755 hostapd
	sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.FCS
	sudo mv hostapd /usr/sbin/hostapd
fi

echo "generating startup script..."
echo "
### BEGIN INIT INFO
# Provides:          beacon
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: beacon
# Description:       starting the beacon runtime
### END INIT INFO
#!/bin/sh
echo 'starting beacon...'
$DIR/init.sh
" | sudo tee /etc/init.d/setup.sh > /dev/null
sudo chmod 755 /etc/init.d/setup.sh

echo "generating /etc/udhcpd.conf..."
echo "
start 192.168.42.2
end 192.168.42.20
interface wlan0
remaining yes
opt dns 8.8.8.8 4.2.2.2
opt subnet 255.255.255.0
opt router 192.168.42.1
opt lease 864000" | sudo tee /etc/udhcpd.conf > /dev/null

echo "generating /etc/default/udhcpd..."
echo 'DHCPD_OPTS="-S"' | sudo tee /etc/default/udhcpd > /dev/null

echo "configuring interfaces..."
sudo ifconfig wlan0 up
sudo ifconfig wlan0 192.168.42.1
echo "
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
iface wlan0 inet static
address 192.168.42.1
netmask 255.255.255.0
auto wlan1
iface wlan1 inet dhcp" | sudo tee /etc/network/interfaces > /dev/null

echo "make it responsible for its network..."
if ! grep -q "\nauthoritative" /etc/dhcp/dhcpd.conf; then
	echo "authoritative" | sudo tee --append /etc/dhcp/dhcpd.conf
fi

echo "generating /etc/hostapd/hostapd.conf..."
echo "
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
rsn_pairwise=CCMP" | sudo tee /etc/hostapd/hostapd.conf > /dev/null

echo "generating /etc/default/hostapd..."
echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' | sudo tee /etc/default/hostapd > /dev/null

echo "starting hostapd and udhcpd..."
sudo service hostapd start
sudo service udhcpd start
echo "enabling hostapd and udhcpd at startup..."
sudo update-rc.d hostapd enable
sudo update-rc.d udhcpd enable

echo "configuring and enabling vnc server..."
sudo cp $DIR/conf/vncboot.sh /etc/init.d/vncboot.sh
sudo chmod 755 /etc/init.d/vncboot.sh
sudo update-rc.d vncboot.sh defaults
expect << EOF
spawn "/usr/bin/vncpasswd"
expect "Password:"
send "$PWD\r"
expect "Verify:"
send "$PWD\r"
expect eof
exit
EOF
echo -n "\n"
sudo service vncboot.sh start
