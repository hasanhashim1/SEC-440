#!/bin/bash

read -p "Enter the system type you are running this script on (u1/u2/u3/ha1/ha2): " system_type

# Function to setup MySQL servers (u1, u2, u3)
setup_mysql_server() {
  # Your password placeholder
  MYSQL_ROOT_PASSWORD='root' # Change this to your root password
  HAPROXY_USER_PASSWORD='Passw0rd!' # Change this to the password you want to use for haproxy_root

  # MySQL commands
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE USER 'ha'@'10.0.6.10';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'ha_root'@'10.0.6.10' IDENTIFIED BY '$HAPROXY_USER_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SELECT User, Host FROM mysql.user;
EOF

  # Additional MySQL configuration
  ss tulpn
  cd /etc/mysql
  ls
  grep -H "127.0.0.1" */*
  sudo sed -i 's/bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' mariadb.conf.d/50-server.cnf
  sudo systemctl restart mysql
}

# Function to setup HAProxy servers (ha1, ha2)
setup_haproxy_server() {
  sudo sed -i "s/ENABLED=0/ENABLED=1/" /etc/default/haproxy
  sudo service haproxy restart
  sudo apt-get update && sudo apt-get install -y mysql-client

  # Append configuration to HAProxy
  cat <<EOF | sudo tee -a /etc/haproxy/haproxy.cfg
listen mysql-cluster
bind *:3306
mode tcp
option mysql-check user haproxy_check
balance roundrobin
server mysql-1 10.0.5.201:3306 check fall 3 rise 2
server mysql-2 10.0.5.202:3306 check fall 3 rise 2
server mysql-3 10.0.5.203:3306 check fall 3 rise 2
EOF

  sudo service haproxy restart
  echo "Rebooting system to apply changes..."
  sudo reboot
}

# Check the system type and call the respective function
case $system_type in
  u1|u2|u3)
    echo "Setting up MySQL on $system_type..."
    setup_mysql_server
    ;;
  ha1|ha2)
    echo "Setting up HAProxy on $system_type..."
    setup_haproxy_server
    ;;
  *)
    echo "Invalid system type entered. Please run the script again with a valid system type."
    ;;
esac
