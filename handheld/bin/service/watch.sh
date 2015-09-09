#!/bin/sh

connect.sh
gmplayer -demuxer lavf "http://192.168.42.1:5001/?action=stream"
disconnect.sh
