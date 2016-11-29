#!/bin/bash
echo -n "Running 3G modem... "
sleep 20 

if [ -c /dev/ttyUSB0 ] ; then
    echo "Connecting ... this may take few seconds"
    (
        pon.wvdial orange
        date "+%H:%M" >/tmp/orange.log
	service openvpn start
    ) &
else
    echo "No (modem not plugged in, or network already available)"
fi
exit 0
