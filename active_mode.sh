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

echo 1 | sudo tee /sys/class/leds/led0/brightness > /dev/null
sudo ifconfig wlan0 up
sudo service hostapd start
sudo service udhcpd start
LD_PRELOAD=/usr/lib/uv4l/uv4lext/armv6l/libuv4lext.so mjpg_streamer \
  -i "/usr/local/lib/input_uvc.so -d /dev/video0 -r 320x240 -f 15" \
  -o "/usr/local/lib/output_http.so -w /usr/local/www -p 5001" &
