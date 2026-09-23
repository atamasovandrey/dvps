# Docker bypasses the host firewall

## Symptom
For example port 8080 is available from outside despite the default policy INPUT DROP.

## Why it happens
First the packets come to DNAT in the PREROUTING before routing. Then packets go through FORWARD, not INPUT. Rules INPUT don't see these packets because they come to default policy DROP.

## How to check
iptables -t nat -L -nv, iptables -L -nv

## Fix
1. Add an DROP or REJECT rule to the DOCKER chain. If you do so, then every new container will not be available if matches the rule. 
2. Run a container with the -p flag 127.0.0.1:HOSTPORT:CONTAINERPORT

