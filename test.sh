#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Start configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin

# Set system host-name
set system host-name vyos1-HasanHashim

# Configure interfaces
set interfaces ethernet eth0 address 10.0.17.15/24
set interfaces ethernet eth0 description "WAN"
set interfaces ethernet eth1 address 10.0.5.2/24
set interfaces ethernet eth1 description "LAN"

# Configure static route
set protocols static route 0.0.0.0/0 next-hop 10.0.17.2
set system name-server 10.0.17.2

# Commit and save
commit
save

# Configure NAT source rule
set nat source rule 10 outbound-interface eth0
set nat source rule 10 source address 10.0.5.0/24
set nat source rule 10 description "Lan to Wan"
set nat source rule 10 translation address masquerade

# Commit and save
commit
save

# Configure DNS forwarding and SSH
set service dns forwarding listen-address 10.0.5.1
set service dns forwarding allow-from 10.0.5.0/24
set service dns forwarding system
set service ssh listen address 0.0.0.0

# Commit and save
commit
save

# Exit configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."
