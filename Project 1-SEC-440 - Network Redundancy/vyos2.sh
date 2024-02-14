#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Startting
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin



configure
set system host-name vyos2-HasanHashim

set nat destination rule 10 description "WEB01 on WAN (HTTP)"
set nat destination rule 10 destination port 80
set nat destination rule 10 inbound-interface eth0
set nat destination rule 10 protocol tcp
set nat destination rule 10 translation address 10.0.5.100
set nat destination rule 10 translation port 80

set nat destination rule 20 description "WEB01 on WAN (SSH)"
set nat destination rule 20 destination port 22
set nat destination rule 20 inbound-interface eth0
set nat destination rule 20 protocol tcp
set nat destination rule 20 translation address 10.0.5.100
set nat destination rule 20 translation port 22

set high-availability vrrp group LAN vrid 20
set high-availability vrrp group LAN interface eth1
set high-availability vrrp group LAN priority '100'
set high-availability vrrp group LAN address 10.0.5.1/24

set high-availability vrrp group WAN vrid 10
set high-availability vrrp group WAN interface eth0
set high-availability vrrp group WAN priority '100'
set high-availability vrrp group WAN address 10.0.17.105/24

commit
save

# testing
show nat destination rule 10
show nat destination rule 20



# Exitting
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."