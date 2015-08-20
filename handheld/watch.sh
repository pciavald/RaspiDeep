# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    activate.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/17 06:05:00 by pciavald          #+#    #+#              #
#    Updated: 2015/05/17 07:39:14 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

sudo sh -c "echo 1 > /sys/class/leds/led1/brightness"
sudo ifup wlan0
sleep 3
mplayer -demuxer lavf "http://192.168.42.1:5001/?action=stream&video_name=stream.mjpg"
sudo idown wlan0
sudo sh -c "echo 0 > /sys/class/leds/led1/brightness"
