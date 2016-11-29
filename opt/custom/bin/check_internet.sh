#!/bin/bash

if [ "$(ping -c 1 8.8.8.8 | grep '100% packet loss')"  -a "$(ping -c 1 8.8.4.4 | grep '100% packet loss')" ]; then
	echo "$(date) Internet connection is down. Rebooting..."
	shutdown -r now
else 
	echo "$(date) Internet OK"

fi
