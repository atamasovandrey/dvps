#!/bin/bash

set -euo pipefail

sudo apt-get update
sudo apt-get install iputils-ping

# ssh_keys
tee $HOME/.ssh/authorized_keys > /dev/null <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC73pqHHvCS/m5zPo8/HZ3+BQBt0anRPM1qM0GUlriimTOmEhMh7GynjTTGRVn+DK8npKuELtlJQsvp37nGx/eq8nBfGgdLUf/ZEaDb2d9iZDs6z0eVD8c/AyKGfUu+HUlNkBilrIvGSb1PLX2Dx50d2KBkdAuOvpIU8FE+SBX4OnjhfrYAnUxdj1mSL27NJPdKNRDyIo1KMsqX1LGQ1z5oLkXqWu2fD+l2BMPpDgJE/n+L3h3kn/QQL6Ht+KlXMIg0uS6X0STXaej5xNPbt3kQj2OYwGW7FjUmMJdYrCAmENb0I3i8m0UmFQ/AVNH6LIP2zpOI85hKusU8llgB5UP2/zZVPSsxzKs8yYhLdhvMOZQbIGmrpDU1ld7aLRse1bAuuGh6m6ZUI2RJo4dCFt6c340yAYlRsHIc4cCM5heiy9cV1mx0WMp3uXCHB/P+5VxjZ1Q9aMLxMj8TSQ2fyKW/EJTb12G0948I9GipE2A7OMnj+aMg8xOdS/hYjX9bWNc= dvps@app-02
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTEklONRh6V/GhYmFN0R/vFW4sOT8KVaynNs3IqnJQracFYbu4PhlmC/VP+zqb0Nip4ejTvX0v6+O6Gs4bsyVpO18hvWox+9PfcgXGdJrqV7NUx6zTJupgO0JaE1gnjY0yjg8ZmnddV9cjiruW3Y5uETcDVpVb0fLnjKn3MsgVYdk42SSyzWUfXMHqHgIskUW1gGXfnD9Hft84Gynog0NsxsMiddv4qjXix6K3XRbFyXuT3fIJWwF9jz1wvD/PTtqZasi0R5PhIs/sGQJ0e75Tq+ZXZGg8iRSRzOKE3GUqQHZkq8hLUoHiYZCaSwt0kRoRjM15b/QVCxX7Uc435TtMTV4CKIPpQIFwKFB6aVzCZvtu1t0w+omxPKJfnOpnMrIYwclEa8yh7VRIHLjwjjv4LaBfl0zpettZkNSlq5INcAUX9WvRAilBa7NS9D5GcPFBD2H9BT2ouqedpsxqIE9VC8XCZzgRP+UTHMQdStR3VvHVHsV3GbvquXuz0YZEqEs= dvps@app-01
EOF

# hosts
sudo tee /etc/hosts > /dev/null <<'EOF'
127.0.0.1 localhost

192.168.1.147 app-01
192.168.1.248 app-02
192.168.1.222 app-03
192.168.1.1 wwgate
EOF

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
