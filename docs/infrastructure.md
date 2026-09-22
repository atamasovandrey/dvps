Hostname: app-01
OS: Ubuntu 22.04.5 LTS
IP: 192.168.1.185
CPUs: 2
RAM: 2GB
HDD: 20GB

On this server was configured user 'dvps', ssh access by key, firewall.
Also on app-01 installed Docker engine. Docker passed default INPUT rules. If you create a conteiner it will be available despite of defaul INPUT rule. 
If you want to make port unavailable you should run a container with key -p 127.0.0.1:HOSTPORT:CONTAINERPORT or change DOCKER-USER rules. 

