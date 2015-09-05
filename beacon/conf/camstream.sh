### BEGIN INIT INFO
# Provides: camerastream
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start VNC Server at boot time
# Description: Start VNC Server at boot time.
### END INIT INFO

#! /bin/sh
# /etc/init.d/vncboot

USER=pi
HOME=/home/pi

export USER HOME

case "$1" in
	start)
		echo "Starting camera streaming service."
		sudo modprobe bcm2835-v4l2
		LD_PRELOAD=/usr/lib/uv4l/uv4lext/armv6l/libuv4lext.so mjpg_streamer \
			-i "/usr/local/lib/input_uvc.so -d /dev/video0 -r 320x240 -f 15 -n -y" \
			-o "/usr/local/lib/output_http.so -w /usr/local/www -p 5001" &
		;;

	stop)
		echo "Stopping camera streaming service."
		pkill -x mjpg_streamer
		;;

	*)
		echo "Usage: /etc/init.d/camerastream {start|stop}"
		exit 1
		;;
esac
