app-01

Linux app-01 5.15.0-191-generic #201-Ubuntu SMP Fri Aug 7 18:39:04 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether bc:24:11:db:f9:d0 brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 192.168.1.185/24 metric 100 brd 192.168.1.255 scope global dynamic ens18
       valid_lft 37501sec preferred_lft 37501sec
    inet6 fd99:771:bf33::7f6/128 scope global dynamic noprefixroute 
       valid_lft 42456sec preferred_lft 42456sec
    inet6 fd99:771:bf33:0:be24:11ff:fedb:f9d0/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 5220sec preferred_lft 2520sec
    inet6 fe80::be24:11ff:fedb:f9d0/64 scope link 
       valid_lft forever preferred_lft forever

Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           40 bits physical, 48 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  2

               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       167Mi       1.1Gi       0.0Ki       681Mi       1.6Gi
Swap:          1.8Gi          0B       1.8Gi
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   20G  0 disk 
├─sda1                      8:1    0    1M  0 part 
├─sda2                      8:2    0  1.8G  0 part /boot
└─sda3                      8:3    0 18.2G  0 part 
  └─ubuntu--vg-ubuntu--lv 253:0    0   10G  0 lvm  /
