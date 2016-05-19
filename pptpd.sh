#!/bin/sh
#VPN 2 - Setup PPTP Server
# Update server
#apt-get update && apt-get upgrade -y

echo "nospoof on" >> /etc/host.conf

echo "starting PPTPD install"
apt-get update 
apt-get upgrade 
apt-get install pptpd -y
echo "PPTPD install complete"

echo "updating /etc/ppp/pptpd-options"

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
debug
#dump
netmask 255.255.255.0
lock
nobsdcomp
EOF

echo "updating /etc/pptpd.conf "
cat > /etc/pptpd.conf <<EOF
option /etc/ppp/pptpd-options
logwtmp
bcrelay eth0
localip 198.142.70.106
remoteip 192.168.10.1-255
netmask 255.255.255.0
EOF


echo "clearing iptables"
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

echo "updating iptables"
iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -i eth0 -p gre -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
iptables --table nat --append POSTROUTING   --out-interface ppp0 --jump MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

#netflix iptables
iptables -I FORWARD -d 23.246.0.0/255.255.192.0 -j REJECT
iptables -I FORWARD -d 37.77.176.0/255.255.240.0 -j REJECT
iptables -I FORWARD -d 191.45.56.0/255.255.248.0 -j REJECT
iptables -I FORWARD -d 191.45.48.0/255.255.240.0 -j REJECT
iptables -I FORWARD -d 198.38.96.0/255.255.224.0 -j REJECT
iptables -I FORWARD -d 185.2.216.0/255.255.248.0 -j REJECT
iptables -I FORWARD -d 108.175.32.0/255.255.240.0 -j REJECT
#end
#sh -c "iptables-save > /etc/iptables.rules"

#cat > /etc/network/if-pre-up.d/iptablesload <<EOF
##!/bin/sh
#iptables-restore < /etc/iptables.rules
#exit 0
#EOF

#chmod +x /etc/network/if-pre-up.d/iptablesload
#apt-get install denyhosts fail2ban

echo "15.1 workaround"
#ubuntu 15.1 work around
#sed -i s/^logwtmp/#logwtmp/ /etc/pptpd.conf
#
echo "installing denyhosts & fail2ban"
apt-get install denyhosts fail2ban

#FTP
apt-get install vsftpd
rm /etc/vsftpd.conf
cat > /etc/vsftpd.conf <<EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
EOF

#install PPTPD monitor
wget https://github.com/pjbish/pptpd-monitor/raw/master/src/pptpd-monitor.py

#restart
#echo "restarting PPTPD"
#service pptpd restart
