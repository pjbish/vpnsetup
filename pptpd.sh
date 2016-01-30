#!/bin/sh
#VPN 2 - Setup PPTP Server
# Update server
apt-get update && apt-get upgrade -y

echo "nospoof on" >> /etc/host.conf

apt-get install pptpd -y

cat > /etc/ppp/pptpd-options <<EOF
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
#ms-wins 10.0.0.3
#ms-wins 10.0.0.4
proxyarp
nodefaultroute
#debug
#dump
netmask 255.255.255.0
lock
nobsdcomp
EOF

cat > /etc/pptpd.conf <<EOF
option /etc/ppp/pptpd-options
logwtmp
bcrelay eth0
localip 198.142.70.106
remoteip 192.168.10.1-255
netmask 255.255.255.0
EOF



iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -nvL

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p

iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -i eth0 -p gre -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
iptables --table nat --append POSTROUTING   --out-interface ppp0 --jump MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

sh -c "iptables-save > /etc/iptables.rules"

cat > /etc/network/if-pre-up.d/iptablesload <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
EOF

chmod +x /etc/network/if-pre-up.d/iptablesload

apt-get install denyhosts fail2ban


#ubuntu 15.1 work around
sed -i s/^logwtmp/#logwtmp/ /etc/pptpd.conf
#
apt-get -y install fail2ban

#install PPTPD monitor
wget https://github.com/pjbish/pptpd-monitor/raw/master/src/pptpd-monitor.py

#restart
service pptpd restart
