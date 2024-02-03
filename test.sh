#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Start configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin

# Set system host-name
set high-availability vrrp group WAN vrid 10
set high-availability vrrp group WAN interface eth0
set high-availability vrrp group WAN priority '200'
set high-availability vrrp group WAN address 10.0.17.105/24

set high-availability vrrp group LAN vrid 20
set high-availability vrrp group LAN interface eth1
set high-availability vrrp group LAN priority '200'
set high-availability vrrp group LAN address 10.0.5.1/24

show high-availability vrrp
commit
save

# Exit configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."
