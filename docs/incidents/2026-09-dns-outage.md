## Impact
Resolve dns names didn't work for about 10 minutes.

## Symptoms
Didn't got responses for curl requests on trying to run 'apt update'. Network is ok. ping — not available on the host, connectivity was confirmed indirectly

## Investigation
1. Check ip address on interface
2. Check curl requests.
3. Try to run apt update

## Root Cause
The file file /etc/resolv.conf was modified recently. In the file was dns address '192.0.2.1'. In the result DNS names couldn't be resolved.

## Resolution
DNS address was reverted as it was. Last dns was found in log systemd-resolved - '192.168.1.1'. Started the service systemd-resolved.

## Prevention

TODO