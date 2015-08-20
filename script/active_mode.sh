# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    active_mode.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/16 16:05:13 by pciavald          #+#    #+#              #
#    Updated: 2015/05/17 06:39:53 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo pkill raspistill
sudo pkill raspivid
sudo ifconfig wlan0 up
sudo service hostapd start
sudo service udhcpd start
sudo service camstream start
echo 1 | sudo tee /sys/class/leds/led0/brightness > /dev/null
