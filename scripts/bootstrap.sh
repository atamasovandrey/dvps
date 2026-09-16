#!/bin/bash

set -euo pipefail

# export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

# sshd_config
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf > /dev/null <<'EOF'
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
EOF

if $(sudo sshd -t); then
    sudo systemctl reload sshd.service
else
    exit 1
fi

# sudo
sudo DEBIAN_FRONTEND=noninteractive tee /etc/sudoers.d/dvps > /dev/null <<'EOF'
Defaults timestamp_timeout=60
EOF
sudo chmod 440 /etc/sudoers.d/dvps
sudo visudo -c

#timezone
sudo timedatectl set-timezone Asia/Krasnoyarsk

#firewall
sudo apt-get install iptables-persistent -y
sudo tee /etc/iptables/rules.v4 > /dev/null <<'EOF'
*filter
:INPUT DROP [35:5750]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [16452:5385350]
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate INVALID -j DROP
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-P INPUT DROP
-P FORWARD DROP
-P OUTPUT ACCEPT
COMMIT
EOF
sudo netfilter-persistent restart