#!/bin/sh

echo "installing desktop shortcuts"
sudo rm -r /home/pi/Desktop
cp -r $RASPIDEEP/content/Desktop /home/pi

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
