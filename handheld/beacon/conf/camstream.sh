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
		LD_PRELOAD=/usr/lib/uv4l/uv4lext/armv6l/libuv4lext.so mjpg_streamer \
			-i "/usr/local/lib/input_uvc.so -d /dev/video0 -r 320x240 -f 15" \
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

#Daemon=mjpg_streamer
#DaemonBase=/usr/local
#DaemonArgs="-i \"input_raspicam.so -fps 5 -hf -vf\" -o \"output_http.so\""
#
#case "$1" in
#	start)
#		eval LD_LIBRARY_PATH=${DaemonBase}/lib ${DaemonBase}/bin/${Daemon} ${DaemonArgs} >/dev/null 2>&1 &
#		echo "$0: started"
#		;;
#	stop)
#		pkill -x ${Daemon}
#		echo "$0: stopped"
#		;;
#	*)
#		echo "Usage: $0 {start|stop}" >&2
#		;;
#esac
