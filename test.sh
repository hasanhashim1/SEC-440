#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
# Start configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin

# Set system host-name
conf
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


commit
save
show nat destination rule 10
show nat destination rule 20

# Exit configuration mode
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end

echo "Configuration applied successfully."
