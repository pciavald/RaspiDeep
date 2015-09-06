#!/bin/sh

# settings for WiFi access point
SSID="Ocean71"
PASS="Raspberry71"

LOCALE="fr_FR"

#TODO save whole desktop, change password

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

DIR=`pwd`
if ! grep -q "RASPIDEEP" /home/pi/.profile > /dev/null; then
	echo "export RASPIDEEP=$DIR" >> /home/pi/.profile
	sudo rpi-update
	sudo raspi-config # expand filesystem, boot to desktop
	sudo reboot
	exit 0
fi

echo "setting locales to $LOCALE.UTF-8..."
if ! grep -q "$LOCALE" /home/pi/.profile > /dev/null; then
	echo "\
	export LANGUAGE=$LOCALE.UTF-8
	export LANG=$LOCALE.UTF-8
	export LC_ALL=$LOCALE.UTF-8
	export LC_CTYPE=$LOCALE.UTF-8" >> /home/pi/.profile
	. /home/pi/.profile
	sudo sed -i "s/^# $LOCALE.UTF-8/$LOCALE.UTF-8/" /etc/locale.gen
	sudo locale-gen
	sudo update-locale LANG=$LOCALE.UTF-8
fi

#if [[ $(( $(date +%s) - $(stat -c %Y /var/cache/apt/) )) > $((3600 * 24)) ]]; then
	sudo apt-get update
#fi
sudo apt-get -y install mplayer vim tightvncserver imagemagick build-essential curl expect cmake

echo "replacing mplayer with correct libav version..."
sudo mv mplayer `which mplayer`

echo "setting up PiTFT..."
if ! grep -q "adafruit" /etc/apt/sources.list > /dev/null; then
	curl -SLs https://apt.adafruit.com/add | sudo bash
	sudo apt-get install -y raspberrypi-bootloader
	sudo apt-get install -y adafruit-pitft-helper
fi
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

echo "installing libs"
if [ ! -f /opt/vc/lib/libbcm_host.so ]; then
	sudo cp $RASPIDEEP/lib/* /opt/vc/lib/
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

echo "installing desktop shortcuts"
sudo rm -r /home/pi/Desktop /home/pi/confirm 2> /dev/null
cp -r $DIR/Desktop $DIR/confirm /home/pi

echo "initializing pcmanfm"
export DISPLAY=:0
pcmanfm
sleep 1
sudo killall pcmanfm
sudo service lightdm stop
sudo service lightdm start

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
