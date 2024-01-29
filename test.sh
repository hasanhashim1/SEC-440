#!/bin/vbash

# Enter VyOS configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin

# Set interface eth0 address and description
set interfaces ethernet eth0 address '10.0.17.15/24'
set interfaces ethernet eth0 description 'WAN'

# Set interface eth1 address and description
set interfaces ethernet eth1 address '10.0.5.2/24'
set interfaces ethernet eth1 description 'LAN'

# Commit and save the configuration
commit
save

# Exit VyOS configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end
