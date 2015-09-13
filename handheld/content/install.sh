#!/bin/sh

# https://rbnrpi.wordpress.com/project-list/wifi-to-ethernet-adapter-for-an-ethernet-ready-tv/

# settings for WiFi access point
SSID="Ocean71"
PASS="Raspberry71"

LOCALE="fr_FR"

#TODO save whole desktop, change password

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

DIR=`pwd`
if ! grep -q "RASPIDEEP" /home/pi/.profile > /dev/null; then
	sudo rpi-update
	echo "export RASPIDEEP=$DIR" >> /home/pi/.profile
	sudo raspi-config # expand filesystem, boot to desktop
	sudo reboot
	exit 0
fi

echo "setting locales to $LOCALE.UTF-8..."
if ! grep -q "$LOCALE" /home/pi/.profile > /dev/null; then
	sudo sed -i "s/^# $LOCALE.UTF-8/$LOCALE.UTF-8/" /etc/locale.gen
	sudo locale-gen
	echo "\
export LANGUAGE=$LOCALE.UTF-8
export LANG=$LOCALE.UTF-8
export LC_ALL=$LOCALE.UTF-8
export LC_CTYPE=$LOCALE.UTF-8" >> /home/pi/.profile
	. /home/pi/.profile
	sudo update-locale LANG=$LOCALE.UTF-8
fi

sudo apt-get update
sudo apt-get -y install \
	mplayer \
	vim \
	tightvncserver \
	imagemagick \
	build-essential \
	curl \
	expect \
	cmake \
	htop

echo "replacing mplayer with correct libav gui-enabled version..."
MPATH=$(dirname `which mplayer`)
sudo cp $RASPIDEEP/content/mplayer `which mplayer`
sudo ln -sf `which mplayer` $MPATH/gmplayer
SKINDIR="/usr/local/share/mplayer/skins"
sudo mkdir -p $SKINDIR
sudo cp -r $RASPIDEEP/content/mplayer_skin $SKINDIR/default

echo "setting up PiTFT..."
if ! grep -q "/dev/fb1" /home/pi/.profile > /dev/null; then
	curl -SLs https://apt.adafruit.com/add | sudo bash
	sudo apt-get install -y raspberrypi-bootloader
	sudo apt-get install -y adafruit-pitft-helper
	sudo expect << EOF
spawn {/usr/bin/sudo} {/usr/bin/adafruit-pitft-helper} -t 28r
expect "Would you like the console to appear on the PiTFT display? \[y/n\] "
send "y\r"
expect "Would you like GPIO #23 to act as a on/off button? \[y/n\] "
send "y\r"
exit
EOF
	echo
	echo "\
Section \"Device\"
  Identifier \"Adafruit PiTFT\"
  Driver \"fbdev\"
  Option \"fbdev\" \"/dev/fb1\"
EndSection" | sudo tee /usr/share/X11/xorg.conf.d/99-pitft.conf > /dev/null
	if ! grep -q "pi1" /boot/config.txt > /dev/null; then
		echo "\
[pi1]
device_tree=bcm2708-rpi-b-plus.dtb
[pi2]
device_tree=bcm2709-rpi-2-b.dtb
[all]
dtparam=spi=on
dtparam=i2c1=on
dtparam=i2c_arm=on
dtoverlay=pitft28r,rotate=90,speed=32000000,fps=20" | sudo tee --append /boot/config.txt > /dev/null
	fi
	echo "\
BLANK_TIME=0
BLANK_DPMS=off
POWERDOWN_TIME=0" | sudo tee /etc/kbd/config > /dev/null
	sudo reboot
	exit 0
fi

echo "installing libs"
if [ ! -f /opt/vc/lib/libbcm_host.so ]; then
	sudo cp $RASPIDEEP/content/lib/* /opt/vc/lib/
fi

echo "setting vnc password"
expect << EOF
spawn "/usr/bin/vncpasswd"
expect "Password:"
send "$SSID\r"
expect "Verify:"
send "$SSID\r"
expect "Would you like to enter a view-only password (y/n)? "
send "n\r"
exit
EOF
echo

echo "setting up interfaces..."
sudo cp $RASPIDEEP/content/network/iptables /etc/network/iptables
echo $PASS | wpa_passphrase $SSID | sudo tee /etc/wpa_supplicant.conf > /dev/null
echo "\
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
iface wlan0 inet manual
  wpa-roam /etc/wpa_supplicant.conf
iface default inet static
  address 192.168.42.2
  gateway 192.168.42.1
pre-up iptables-restore < /etc/network/iptables" | sudo tee /etc/network/interfaces > /dev/null
sudo sed -i "s/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
sudo sysctl --system

echo "generating startup script..."
echo "\
### BEGIN INIT INFO
# Provides:          handheld
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: handheld
# Description:       starting the handheld runtime
### END INIT INFO
#!/bin/sh
echo 'starting handheld...'
$RASPIDEEP/bin/control/init.sh" | sudo tee /etc/init.d/setup > /dev/null
sudo chmod 755 /etc/init.d/setup
sudo update-rc.d setup defaults

$RASPIDEEP/bin/control/resetDesktop.sh
