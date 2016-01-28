#VPN 2 - Setup PPTP Server
apt-get install pptpd -y
echo "nospoof on" >> /etc/host.conf
echo "localip 198.142.70.106" >> /etc/pptpd.conf
echo "remoteip 192.168.10.1-255" >> /etc/pptpd.conf
echo "netmask 255.255.255.0" >> /etc/pptpd.conf
echo "bcrelay eth0" >> /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options
echo "proxyarp" >> /etc/ppp/pptpd-options
echo "nodefaultroute" >> /etc/ppp/pptpd-options
echo "netmask 255.255.255.0" >> /etc/ppp/pptpd-options
echo "lock" >> /etc/ppp/pptpd-options
echo "nobsdcomp" >> /etc/ppp/pptpd-

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

iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -i eth0 -p gre -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
iptables --table nat --append POSTROUTING   --out-interface ppp0 --jump MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

sh -c "iptables-save > /etc/iptables.rules"
sed -i s/^logwtmp/#logwtmp/ /etc/pptpd.conf

apt-get -y install fail2ban

service pptpd restart
