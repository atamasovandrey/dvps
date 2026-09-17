#!/bin/bash

set -euo pipefail

sudo apt-get update
sudo apt-get install iputils-ping

# sshd_config
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf > /dev/null <<'EOF'
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
EOF

if sudo sshd -t; then
    sudo systemctl reload sshd.service
else
    exit 1
fi

# sudo
sudo tee /etc/dvps > /dev/null <<'EOF'
Defaults timestamp_timeout=60
EOF
sudo chmod 440 /etc/dvps

if sudo visudo -c /etc/dvps; then
    sudo mv /etc/dvps /etc/sudoers.d/dvps
else
    exit 1
fi

#timezone
sudo timedatectl set-timezone Asia/Krasnoyarsk

#firewall
sudo DEBIAN_FRONTEND=noninteractive apt-get install iptables-persistent -y
sudo tee /etc/iptables/rules.v4 > /dev/null <<'EOF'
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate INVALID -j DROP
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
-A INPUT -p icmp -j ACCEPT
COMMIT
EOF
sudo netfilter-persistent restart

sudo tee /etc/sysctl.d/10-ipv6-disable.conf > /dev/null <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.ens18.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sudo chmod 644 /etc/sysctl.d/10-ipv6-disable.conf
sudo sysctl -p /etc/sysctl.d/10-ipv6-disable.conf
