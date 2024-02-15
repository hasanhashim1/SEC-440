#!/bin/bash

# Update and install HAProxy
sudo apt update && sudo apt install -y haproxy

# Append configuration to /etc/haproxy/haproxy.cfg
sudo bash -c 'cat <<EOF >> /etc/haproxy/haproxy.cfg
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
EOF'

# Restart and enable HAProxy
sudo systemctl restart haproxy
sudo systemctl enable haproxy
# Check HAProxy status (this will halt the script; remove or modify for automation)
# sudo systemctl status haproxy

# Update and install Keepalived
sudo apt update && sudo apt install -y keepalived

# Append configuration to /etc/keepalived/keepalived.conf
sudo bash -c 'cat <<EOF >> /etc/keepalived/keepalived.conf
vrrp_script chk_haproxy {
    script "killall -0 haproxy"
    interval 2
    weight 2
}
vrrp_instance VI_1 {
    interface ens160
    state MASTER # set this to BACKUP on the other machine
    priority 200        # set this to 100 on the other machine
    virtual_router_id 51
    smtp_alert          # Activate email notifications
    authentication {
        auth_type AH
        auth_pass myPassw0rd      # Set this to some secret phrase
    }
    virtual_ipaddress {
        10.0.6.10/24
    }
    track_script {
        chk_haproxy
    }
}
EOF'

# Restart and enable Keepalived
sudo systemctl restart keepalived
sudo systemctl enable keepalived

# Reboot the system
sudo reboot
