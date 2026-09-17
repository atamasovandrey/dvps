## Impact
Was not worked resolve dns names for about 10 minutes.

## Symptoms
Can't get an answer for curl requests on trying to run 'apt update'. Network is ok. Ping in local and global network responded.

## Investigation
1. Check ip address on interface
2. Check curl requests.
3. Try to run apt update

## Root Cause
Was modified file /etc/resolve.conf. In the file was dns address '192.0.2.1'. In the result DNS names couldn't be resolved.

## Resolution
Revert DNS address as it was. Last dns was found in log systemd-resolved - '192.168.1.1'.

## Preventation
Add 'nameserver 192.168.1.1' to the resolve.conf in bootstrap.sh