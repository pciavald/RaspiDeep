#!/bin/sh

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
echo "\
auto lo
  iface lo inet loopback
auto eth0
  iface eth0 inet dhcp
iface wlan0 inet manual
  wpa-roam /etc/wpa_supplicant.conf
iface default inet static
  address 192.168.42.2
  gateway 192.168.42.1" | sudo tee /etc/network/interfaces > /dev/null
echo $PASS | wpa_passphrase $SSID | sudo tee /etc/wpa_supplicant.conf > /dev/null

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
$DIR/bin/control/init.sh" | sudo tee /etc/init.d/setup > /dev/null
sudo chmod 755 /etc/init.d/setup
sudo update-rc.d setup defaults

echo "installing desktop shortcuts"
sudo rm -r /home/pi/Desktop
cp -r $DIR/content/Desktop /home/pi

echo "initializing raspideep bin path..."
if ! grep -q "/bin/service" /home/pi/.profile > /dev/null; then
	echo '
export PATH=$RASPIDEEP/bin/service:$PATH
export PATH=$RASPIDEEP/bin/control:$PATH' >> /home/pi/.profile
fi

echo "initializing pcmanfm"
export DISPLAY=:0
pcmanfm
sleep 2
sudo killall pcmanfm
sudo service lightdm stop
sudo service lightdm start
sleep 7

echo "reducing lxde bar..."
sed -i "s/autohide=0/autohide=1/" /home/pi/.config/lxpanel/LXDE-pi/panels/panel
sed -i "s/heightwhenhidden=2/heightwhenhidden=1/" /home/pi/.config/lxpanel/LXDE-pi/panels/panel

echo "hiding trash and menus, setting one-click,  setting wallpaper..."
sed -i "s/show_trash=1/show_trash=0/" /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
sed -i "s/side_pane_mode=dirtree/side_pane_mode=hidden;dirtree/" /home/pi/.config/pcmanfm/LXDE-pi/pcmanfm.conf
sed -i "s/toolbar=newtab;navigation;home;/toolbar=hidden;newtab;navigation;home;/" /home/pi/.config/pcmanfm/LXDE-pi/pcmanfm.conf
sed -i "s/show_statusbar=1/show_statusbar=0/" /home/pi/.config/pcmanfm/LXDE-pi/pcmanfm.conf
sed -i "s/single_click=0/single_click=1/" /home/pi/.config/libfm/libfm.conf
sed -i "s/auto_selection_delay=600/auto_selection_delay=0/" /home/pi/.config/libfm/libfm.conf

echo "setting list view"
echo "\
[/home/pi/Desktop/confs]
Sort=gicon;ascending;
ViewMode=compact
ShowHidden=false" >> /home/pi/.config/libfm/dir-settings.conf
#TODO set wallpaper
