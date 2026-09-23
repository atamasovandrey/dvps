# dvps

Were created two hosts: app-01 and app-02. For learning and tests.

Servers were configured.
OS: Linux Ubuntu 22.04.5
CPU: 2 cores
RAM: 2GB
HDD: 20GB
IP: 192.168.1.185

Was configured:
- hostname: app-01, app-02
- timezone: Asia/Krasnoyarsk
- firewall: iptables (all drop except 22 port and icmp)
- user: dvps with sudo permissions, can be entered only by the key

known limitation: «script assumes the dvps user already exists; user provisioning is out of scope until the Ansible stage».
ipv6 rules set to DROP. Because ipv6 will not be in use.

For install a new node just run bootstrap.sh.

Lab environment: 3 VM hosts working on OS Ubuntu based on Proxmox

We've made an application running on docker engine.
To build an image you must run "docker build -t docker-app01:v1 app/".
To run the application run "docker run -d --name docker-app01 -p 127.0.0.1:8000:8000 docker-app01"
