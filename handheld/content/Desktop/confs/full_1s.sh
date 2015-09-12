#!/bin/sh

send.sh 'raspistill -t 0 -o /home/pi/RaspiDeep/capture\$1/%d.jpg -tl 1000'
