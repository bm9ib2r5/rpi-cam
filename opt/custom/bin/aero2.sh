#!/bin/bash

echo -n "Running 3G modem... "
if [ -f /dev/ttyUSB0 ] && ! ping -c1 -w1 8.8.4.4 >/dev/null 2>&1; then
    echo "Yes (this may take few seconds)"
    (
        pon.wvdial aero2
        date "+%H:%M" >/tmp/aero2.log
    ) &
else
    echo "No (modem not plugged in, or network already available)"
fi
exit 0
