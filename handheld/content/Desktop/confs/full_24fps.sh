#!/bin/sh

send.sh "raspivid -t 0 -fps 24 -o /home/pi/RaspiDeep/capture\$1/video.h264"
