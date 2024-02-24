#!/bin/bash

echo "Enter the system type you are running this script on (u1/u2/u3/ha1/ha2): "
read system_type

MYSQL_ROOT_PASSWORD='Passw0rd!'  # Change this
HAPROXY_USER_PASSWORD='Passw0rd!'  # Change this

setup_mysql_server() {
    echo "Setting up MySQL on $system_type ..."

    # Drop the user if it exists and create anew to avoid ERROR 1396
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOF
DROP USER IF EXISTS 'haproxy_check'@'10.0.6.10';
CREATE USER 'haproxy_check'@'10.0.6.10';
GRANT ALL PRIVILEGES ON *.* TO 'haproxy_root'@'10.0.6.10' IDENTIFIED BY '$HAPROXY_USER_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    # Update bind address and restart MySQL
    sudo sed -i 's/^bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf || echo "Failed to update bind-address in 50-server.cnf"
    sudo systemctl restart mysql
}

setup_haproxy_server() {
    echo "Configuring HAProxy on $system_type ..."

    sudo sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/haproxy || echo "Failed to enable HAProxy in /etc/default/haproxy"
    sudo apt-get update && sudo apt-get install -y mysql-client

    # Append HAProxy configuration for MySQL load balancing
    cat <<-EOF | sudo tee -a /etc/haproxy/haproxy.cfg
listen mysql-cluster
    bind *:3306
    mode tcp
    option mysql-check user haproxy_check
    balance roundrobin
    server mysql-1 10.0.5.201:3306 check fall 3 rise 2
    server mysql-2 10.0.5.202:3306 check fall 3 rise 2
    server mysql-3 10.0.5.203:3306 check fall 3 rise 2
EOF

    sudo systemctl restart haproxy || echo "Failed to restart HAProxy"
    echo "HAProxy configured. It's recommended to reboot the server to ensure all configurations are applied correctly."
}

case $system_type in
    u1|u2|u3)
        setup_mysql_server
        ;;
    ha1|ha2)
        setup_haproxy_server
        ;;
    *)
        echo "Invalid system type entered. Please run the script again with a valid system type (u1/u2/u3/ha1/ha2)."
        ;;
esac
