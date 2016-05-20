#!/bin/sh
#VPN 2 - Setup PPTP Server
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -I INPUT 1 -i lo -j ACCEPT

iptables -I INPUT -p udp --dport 1024:1193 -j DROP
iptables -I INPUT -p udp --dport 1195:1644 -j DROP
iptables -I INPUT -p udp --dport 1647:65534 -j ACCEPT

## Allowing all neede ports for OpenVPN L2TP PPTP and RADIUS
iptables -I OUTPUT -p udp --dport 1812 -j ACCEPT
iptables -I OUTPUT -p udp --dport 1813 -j ACCEPT
iptables -I OUTPUT -p udp --dport 1701 -j ACCEPT
iptables -I OUTPUT -p udp --dport 4500 -j ACCEPT
iptables -I OUTPUT -p udp --dport 500 -j ACCEPT
iptables -I OUTPUT -p udp --dport 443 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 1723 -j ACCEPT

## Drop torrents
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP

## Set more radius (alt) ports

iptables -I OUTPUT -p udp --dport 1645 -j ACCEPT
iptables -I OUTPUT -p udp --dport 1646 -j ACCEPT

## Try torrent name filters
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP

## Trying forward
iptables -A FORWARD -p tcp --dport 6881:6889 -j DROP
iptables -A FORWARD -p udp --dport 1024:65534 -j DROP

###### Found on web

iptables -N LOGDROP > /dev/null 2> /dev/null
iptables -F LOGDROP
iptables -A LOGDROP -j DROP

#Torrent
iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j LOGDROP 
iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j LOGDROP
iptables -D FORWARD -m string --algo bm --string "peer_id=" -j LOGDROP
iptables -D FORWARD -m string --algo bm --string ".torrent" -j LOGDROP
iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j LOGDROP 
iptables -D FORWARD -m string --algo bm --string "torrent" -j LOGDROP
iptables -D FORWARD -m string --algo bm --string "announce" -j LOGDROP
iptables -D FORWARD -m string --algo bm --string "info_hash" -j LOGDROP

# DHT keyword
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j LOGDROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j LOGDROP


## Modified debia commands

iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -A FORWARD -p udp -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -A FORWARD -p udp -m string --algo bm --string "tracker" -j DROP

iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -A INPUT -p udp -m string --algo bm --string "torrent" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "announce" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -A INPUT -p udp -m string --algo bm --string "tracker" -j DROP

iptables -I INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -I INPUT -p udp -m string --algo bm --string "torrent" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "announce" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -I INPUT -p udp -m string --algo bm --string "tracker" -j DROP

iptables -D INPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -D INPUT -p udp -m string --algo bm --string "torrent" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "announce" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -D INPUT -p udp -m string --algo bm --string "tracker" -j DROP

iptables -I OUTPUT -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -I OUTPUT -p udp -m string --algo bm --string "torrent" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "announce" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -I OUTPUT -p udp -m string --algo bm --string "tracker" -j DROP

## Delete

iptables -D INPUT -m string --algo bm --string "BitTorrent" -j DROP
iptables -D INPUT -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -D INPUT -m string --algo bm --string "peer_id=" -j DROP
iptables -D INPUT -m string --algo bm --string ".torrent" -j DROP
iptables -D INPUT -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -D INPUT -m string --algo bm --string "torrent" -j DROP
iptables -D INPUT -m string --algo bm --string "announce" -j DROP
iptables -D INPUT -m string --algo bm --string "info_hash" -j DROP
iptables -D INPUT -m string --algo bm --string "tracker" -j DROP

iptables -D OUTPUT -m string --algo bm --string "BitTorrent" -j DROP
iptables -D OUTPUT -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -D OUTPUT -m string --algo bm --string "peer_id=" -j DROP
iptables -D OUTPUT -m string --algo bm --string ".torrent" -j DROP
iptables -D OUTPUT -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -D OUTPUT -m string --algo bm --string "torrent" -j DROP
iptables -D OUTPUT -m string --algo bm --string "announce" -j DROP
iptables -D OUTPUT -m string --algo bm --string "info_hash" -j DROP
iptables -D OUTPUT -m string --algo bm --string "tracker" -j DROP

iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -D FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -D FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP 
iptables -D FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "announce" -j DROP
iptables -D FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables -D FORWARD -m string --algo bm --string "tracker" -j DROP 
