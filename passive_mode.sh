# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    passive_mode.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/16 16:06:20 by pciavald          #+#    #+#              #
#    Updated: 2015/05/16 16:18:13 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
sudo ifconfig wlan0 down
sudo service hostapd stop
sudo service udhcpd stop
