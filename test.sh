#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Start configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin


# new



configure
set system host-name vyos2-HasanHashim
set interfaces ethernet eth0 address 10.0.17.75/24
set interfaces ethernet eth0 description To WAN
set interfaces ethernet eth1 address 10.0.5.3/24
set interfaces ethernet eth1 description To LAN
set protocols static route 0.0.0.0/0 next-hop 10.0.17.2
set system name-server 10.0.17.2
set nat source rule 10 description "LAN to WAN"
set nat source rule 10 outbound-interface eth0
set nat source rule 10 source address 10.0.5.0/24
set nat source rule 10 translation address masquerade
set nat destination rule 10 description "HTTP to Web01"
set nat destination rule 10 destination port 80
set nat destination rule 10 inbound-interface eth0
set nat destination rule 10 protocol tcp
set nat destination rule 10 translation address 10.0.5.100
set nat destination rule 10 translation port 80
set nat destination rule 20 description "SSH to Web01"
set nat destination rule 20 destination port 22
set nat destination rule 20 inbound-interface eth0
set nat destination rule 20 protocol tcp
set nat destination rule 20 translation address 10.0.5.100
set nat destination rule 20 translation port 22
set service dns forwarding listen-address 10.0.5.3
set service dns forwarding allow-from 10.0.5.0/24
set high-availability vrrp group WAN address 10.0.17.105/24
set high-availability vrrp group WAN interface eth0
set high-availability vrrp group WAN vrid 155
set high-availability vrrp group WAN priority 100
set high-availability vrrp group LAN address 10.0.5.1/24
set high-availability vrrp group LAN interface eth1
set high-availability vrrp group LAN vrid 155
set high-availability vrrp group LAN priority 100

commit
save










# Exit configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."
