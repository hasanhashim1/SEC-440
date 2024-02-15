#!/bin/bash

# Update and install HAProxy
sudo apt update && sudo apt install -y haproxy

# Append configuration to /etc/haproxy/haproxy.cfg
sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null <<EOT
frontend myweb
bind *:80
option tcplog
mode tcp
default_backend web-servers

backend web-servers
mode tcp
balance roundrobin
option tcp-check
server web01 10.0.5.100:80 check fall 3 rise 2
server web02 10.0.5.101:80 check fall 3 rise 2
EOT

# Restart and enable HAProxy
sudo systemctl restart haproxy
sudo systemctl enable haproxy

# Update and install Keepalived
sudo apt update && sudo apt install -y keepalived

# Append configuration to /etc/keepalived/keepalived.conf
sudo tee -a /etc/keepalived/keepalived.conf > /dev/null <<EOT
vrrp_script chk_haproxy {
    script "killall -0 haproxy"
    interval 2
    weight 2
}
vrrp_instance VI_1 {
    interface ens160
    state BACKUP
    priority 100
    virtual_router_id 51
    smtp_alert
    authentication {
        auth_type AH
        auth_pass myPassw0rd
    }
    virtual_ipaddress {
        10.0.6.10/24
    }
    track_script {
        chk_haproxy
    }
}
EOT

# Restart and enable Keepalived
sudo systemctl restart keepalived
sudo systemctl enable keepalived

# Reboot the system
sudo reboot
