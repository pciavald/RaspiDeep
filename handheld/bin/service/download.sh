#!/bin/sh

connect.sh
#TODO check key
#TODO id_rsa
sudo scp -r -i /home/pi/.ssh/id_rsa pi@192.168.42.1:/home/pi/RaspiDeep/beacon/capture* /mnt
disconnect.sh
pcmanfm /mnt
