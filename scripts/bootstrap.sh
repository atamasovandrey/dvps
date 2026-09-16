#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt update

# sshd_config
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf > /dev/null <<'EOF'
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
EOF

if $(sudo sshd -t 2>/dev/null); then
    sudo systemctl reload sshd.service
else
    exit 1
fi

# sudo
sudo tee /etc/sudoers.d/dvps > /dev/null <<'EOF'
Defaults timestamp_timeout=60
EOF

#timezone
sudo timedatectl set-timezone Asia/Krasnoyarsk

#firewall
sudo apt install iptables-persistent -y
sudo tee /etc/iptables/rules.v4 > /dev/null <<'EOF'
*filter
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate INVALID -j DROP
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A OUTPUT -p sctp -j DROP
COMMIT
EOF

