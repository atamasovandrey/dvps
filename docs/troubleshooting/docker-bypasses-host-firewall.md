# Docker bypasses the host firewall

## Symptom
For example port 8080 is available from outside despite the default INPUT DROP policy.

## Why it happens
First the packets come to DNAT in the PREROUTING before routing. Then packets go through FORWARD, not INPUT. 

## How to check
Run "iptables -t nat -L -nv"; check PROROUTING rules and DNAT destination.
Run "iptables -L -nv" to check DROP counter in the INPUT chain.

1. Add a DROP or REJECT rule to the DOCKER-USER chain. If you do so, then every new container will not be available if matches the rule. 
2. Run a container with the -p flag 127.0.0.1:HOSTPORT:CONTAINERPORT

