#!/bin/bash

# VyOS Configuration Script

# Enter configuration mode
configure

# Set hostname
set system host-name vyos1-HasanHashim

# Configure Ethernet interfaces
set interfaces ethernet eth0 address 10.0.17.15/24
set interfaces ethernet eth0 description "WAN"
set interfaces ethernet eth1 address 10.0.5.2/24
set interfaces ethernet eth1 description "LAN"

# Set default gateway and DNS server
set protocols static route 0.0.0.0/0 next-hop 10.0.17.2
set system name-server 10.0.17.2

# NAT Rules
set nat source rule 10 outbound-interface eth0
set nat source rule 10 source address 10.0.5.0/24
set nat source rule 10 description "Lan to Wan"
set nat source rule 10 translation address masquerade

# DNS Forwarding
set service dns forwarding listen-address 10.0.5.1
set service dns forwarding allow-from 10.0.5.0/24
set service dns forwarding system

# SSH Service
set service ssh listen address 0.0.0.0

# Commit and save configuration
commit
save

# Exit configuration mode
exit

# Display NAT rule 10, services configuration, and test connectivity
run show nat source rule 10
run show service
run ping google.com
