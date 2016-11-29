#!/bin/bash

LOGDIR="/var/log/rpicam"
set -x 
check_cam() { 
	CAM_IP=$1
	if [ "$(ping -c 1 $CAM_IP | grep '100% packet loss')" ]; then
		echo "=== $(date) camera $CAM_IP is down. ==="
		attempt=$(cat $LOGDIR/camera_check_attempt_${CAM_IP})
		echo "CAMERA CHECK ATTEMPT: $attempt"
		expr $attempt + 1 > ${LOGDIR}/camera_check_attempt_${CAM_IP}
		if [ $attempt -gt 3 ]; then
			if [ ! -f $LOGDIR/camera.down.${CAM_IP} ]; then
				echo "Sending notification sms... - rpicam down"
				echo "RPICAM $CAM_IP is down - $(date "+%Y-%m-%d %H:%M:%S")" | /usr/bin/gammu sendsms TEXT XXXXXXXXX
				if [ $? -eq 0 ]; then
					touch ${LOGDIR}/camera.down.${CAM_IP}
				else
					echo "SMS send failed!"
				fi
			fi
			echo "Reached maximum check attempt. Rebooting..."
			/sbin/shutdown -r now
		fi
		
	elif [ "$(ping -c 1 $CAM_IP | grep '0% packet loss')" ]; then
		echo "=== $(date) camera $CAM_IP OK ==="
		echo "1" > $LOGDIR/camera_check_attempt_${CAM_IP}
		if [ -f $LOGDIR/camera.down.${CAM_IP} ]; then
			echo "Sending notification sms... - rpi ok"
			echo "RPICAM $CAM_IP is OK - $(date "+%Y-%m-%d %H:%M:%S")" | /usr/bin/gammu sendsms TEXT XXXXXXXXX
			if [ $? -eq 0 ]; then
				rm -rf $LOGDIR/camera.down.${CAM_IP}
			else
				echo "SMS send failed!"
			fi
		fi

	else
		echo "Unknown error"
	fi
}

IP="$(grep "fixed-address" /etc/dhcp/dhcpd.conf | awk '{print $2}' | sed 's/\;//g')"

for a in $IP; do

	if [ ! -f "${LOGDIR}/camera_check_attempt_${a}" ]; then
		touch ${LOGDIR}/camera_check_attempt_${a}
	fi

	check_cam $a

done
