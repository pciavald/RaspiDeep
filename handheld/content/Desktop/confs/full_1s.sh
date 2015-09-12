#!/bin/sh

send.sh 'raspistill -t 0 -o /home/pi/capture\$1/%d.jpg -tl 1000'
