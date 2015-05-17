# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    passive_mode.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/16 16:06:20 by pciavald          #+#    #+#              #
#    Updated: 2015/05/17 06:43:43 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

sudo kill -SIGINT `ps -ef | grep mjpg-streamer | awk '{print $2}'`
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
sudo service hostapd stop
sudo service udhcpd stop
sudo ifconfig wlan0 down
