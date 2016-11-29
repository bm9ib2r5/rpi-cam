#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward


### FLUSH IPTABLES
iptables -F; iptables -t nat -F; iptables -t mangle -F


### REDIRECT TO CAM
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A FORWARD -o tun0 -j ACCEPT

iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

### CAM 1
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 80 -j DNAT --to 192.168.25.10:80
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 443 -j DNAT --to 192.168.25.10:443
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 554 -j DNAT --to 192.168.25.10:554
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 8000 -j DNAT --to 192.168.25.10:8000

### CAM 2
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 180 -j DNAT --to 192.168.25.11:80
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 1443 -j DNAT --to 192.168.25.11:443
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 1554 -j DNAT --to 192.168.25.11:554
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 18000 -j DNAT --to 192.168.25.11:8000

### CAM 3
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 280 -j DNAT --to 192.168.25.12:80
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 2443 -j DNAT --to 192.168.25.12:443
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 2554 -j DNAT --to 192.168.25.12:554
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 28000 -j DNAT --to 192.168.25.12:8000

### CAM 4
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 380 -j DNAT --to 192.168.25.13:80
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 3443 -j DNAT --to 192.168.25.13:443
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 3554 -j DNAT --to 192.168.25.13:554
iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 38000 -j DNAT --to 192.168.25.13:8000

### INTERNET ON ETH0
#iptables -A FORWARD -i eth0 -j ACCEPT
#iptables -A FORWARD -o eth0 -j ACCEPT

iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o ppp0 -j ACCEPT

### SHOW IPTABLES
iptables -vL && iptables -vL -t nat
