#!/bin/sh

sshpass -praspberry ssh -o StrictHostKeyChecking=no pi@192.168.42.1 $1
