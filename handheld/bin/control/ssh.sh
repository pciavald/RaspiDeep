expect << EOF
spawn {`which ssh`} {-o StrictHostKeyChecking=no} {pi@192.168.42.1} {"echo lol"}
expect "pi@192.168.42.1's password: "
send "raspberry\r"
exit
EOF
