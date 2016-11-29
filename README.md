### INSTALL RASPBIAN IMAGE
```
wget http://director.downloads.raspberrypi.org/raspbian/images/raspbian-2015-05-07/2015-05-05-raspbian-wheezy.zip
unzip 2015-05-05-raspbian-wheezy.zip
sudo umount /dev/sdX
sudo dd bs=4M if=2015-05-05-raspbian-wheezy.img of=/dev/sdX
```

### UPGRADE && PACKAGES 
```
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
rpi-update
reboot
apt-get install usb-modeswitch wvdial ppp vim dnsutils comgt
```
### usb-modeswitch
lsusb

### logrotate
	mkdir -p /var/log/rpicam
	cd /etc/logrotate.d/; ln -s /opt/custom/logrotate.d/rpicam ./ 

### OPENVPN
```
apt-get install openvpn
service openvpn stop
cd /etc/openvpn ; mv vpn.conf vpn.orig; ls -s /opt/custom/openvpn/conf/vpn.conf ./
```
	=== DISABLE openvpn at startup
	update-rc.d disable openvpn
	update-rc.d -f remove openvpn
	
### DHCP eth0
```
apt-get install isc-dhcp-server
service isc-dhcp-server stop
cd /etc/dhcp/; ln -s /opt/custom/dhcp/dhcpd.conf ./
```
	=== /etc/network/interfaces
	auto eth0
	iface eth0 inet static
	address 192.168.25.1
	netmask 255.255.255.0

### wvdial
	=== /etc/wvdial.conf
	cd /etc; ln -s /opt/custom/wvdial/${modem-version}-wvdial.conf ./

### START at bootup
	=== /etc/rc.local
	/opt/custom/bin/orange.sh >> /tmp/orange.log 2>&1
	sleep 10
	/opt/custom/bin/iptables.sh

### crontab
	=== crontab -e
	*/2 * * * * /opt/custom/bin/check_network.sh >/dev/null 2>&1
	*/3 * * * * /opt/custom/bin/check_cam.sh >/dev/null 2>&1
	0 3,23 * * * /usr/bin/pkill -SIGHUP -x pppd

### samba
	apt-get install samba samba-common-bin
	sudo smbpasswd -a pi
	cd /etc/samba; ln -s /opt/custom/samba/dhcp.conf ./
	mkdir -p /home/pi/cam-video; chown pi. /home/pi/cam-video
	service samba restart

	root@raspberrypi:~# smbclient -L 192.168.25.1 -U pi
	Enter pi's password: 
	Domain=[RPICAM] OS=[Unix] Server=[Samba 3.6.6]

	Sharename       Type      Comment
	---------       ----      -------
	camvideo        Disk      CAM VIDEO

### SMS notification
	apt-get install gammu python-gammu
	cd /root; ln -s /opt/custom/gammu/.gammurc-E3131 ./.gammurc

	# Check
	root@raspberrypi:~# gammu --identify
	```
	Device               : /dev/ttyUSB2
	Manufacturer         : Huawei
	Model                : unknown (E3131)
	Firmware             : 21.157.11.00.264
	IMEI                 : XXXXXXXXXXXXXXX
	SIM IMSI             : XXXXXXXXXXXXXXX
	```

### CHECK GSM SIGNAL STRENGTH
	root@raspberrypi:~# comgt sig -d /dev/ttyUSB2
	Signal Quality: 10,99

### USSD CODES
gammu --getussd *124*#
