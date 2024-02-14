#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Startting
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin



configure


set interfaces ethernet eth2 description "OPT"
# for vyos 1
# set interfaces ethernet eth2 address 10.0.6.2/24
# for vyos 2
# set interfaces ethernet eth2 address 10.0.6.3/24
set nat source rule 20 description "FROM OPT to WAN"
set nat source rule 20 outbound-interface eth0
set nat source rule 20 source address 10.0.6.0/24
set nat source rule 20 translation address masquerade
set service dns forwarding listen-address 10.0.6.1
set service dns forwarding allow-from 10.0.6.0/24
set high-availability vrrp group OPT vrid 30
set high-availability vrrp group OPT interface eth2
# vyos 1
# set high-availability vrrp group OPT priority '200'
# vyos 2
# set high-availability vrrp group OPT priority '100'
set high-availability vrrp group OPT address 10.0.6.1/24
commit
save

# testing
show interfaces
show nat source rule 20
show service
ping hashimtech.com
show high-availability vrrp



# Exitting
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."