# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/16 16:09:41 by pciavald          #+#    #+#              #
#    Updated: 2015/08/20 19:54:05 by pciavald         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

echo none >/sys/class/leds/led0/trigger
echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null
echo none >/sys/class/leds/led1/trigger
echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null
/home/pi/RaspiDeep/beacon/script/passive_mode.sh
/home/pi/RaspiDeep/beacon/sensor