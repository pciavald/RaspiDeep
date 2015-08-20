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

sudo service camstream stop
sudo service hostapd stop
sudo service udhcpd stop
sudo ifconfig wlan0 down
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
if ls /home/pi/RaspiDeep/record.sh; then
    sleep 1
    echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
    sleep 1
    echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null
    sleep 1
    echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
    n=0;
    while ! mkdir /home/pi/RaspiDeep/capture$n
    do
        n=$((n+1))
    done;
    sudo /home/pi/RaspiDeep/record.sh $n &
fi
