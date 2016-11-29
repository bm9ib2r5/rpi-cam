#!/bin/bash

if [ "$(ping -c 1 8.8.8.8 | grep '100% packet loss')" -a "$(ping -c 1 8.8.4.4 | grep '100% packet loss')" ]; then
	echo "$(date) Internet connection is down. Rebooting..."
	/sbin/shutdown -r now
elif [ "$(ip link show dev ppp0 2>/dev/null)" == "" ]; then 
	echo "$(date) interface ppp0 doesn't exist. Modem hangup? Rebooting..."
	/sbin/shutdown -r now
elif [ "$(ip link show dev tun0 2>/dev/null)" == "" ]; then 
	echo "$(date) interface tun0 doesn't exist. VPN down. Rebooting..."
	/sbin/shutdown -r now
elif [ "$(ip addr show dev eth0 2>/dev/null | grep inet )" == "" ]; then 
	echo "Restarting network..."
	/usr/sbin/service networking restart
	echo "Restarting dhcp server..."
	/usr/sbin/service isc-dhcp-server restart
else 
	echo "$(date) Network OK"

fi
