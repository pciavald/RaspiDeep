#!/bin/sh

send.sh 'raspistill -t 0 -w 1280 -h 1024 -o /home/pi/capture\$1/%d.jpg -tl 500'
