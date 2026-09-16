#!/bin/bash

set -euo pipefail


# sshd_config
sudo sh -c 'echo "PermitRootLogin no\nPubkeyAuthentication yes\nPasswordAuthentication no" > /etc/ssh/sshd_config.d/10-hardering.conf'
sudo systemctl reload sshd.service

# sudo
sudo sh -c 'echo "Defaults timestamp_timeout=60" > /etc/sudoers.d/dvps'

#timezone
sudo timedatectl set-timezone Asia/Krasnoyarsk

#firewall
sudo apt install iptables-persistent -y
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A INPUT -p icmp -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
sudo netfilter-persistent save


