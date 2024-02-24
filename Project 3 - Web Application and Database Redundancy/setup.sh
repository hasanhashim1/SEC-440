#!/bin/bash

# Ask the user for the system identity
read -p "Enter the system number (1, 2, or 3 for u1, u2, u3 respectively): " SYSTEM_NUM

# Validate input
if [[ $SYSTEM_NUM =~ ^[1-3]$ ]]; then
    echo "Setting up for system u$SYSTEM_NUM-Hasan..."
else
    echo "Invalid system number. Please enter 1, 2, or 3."
    exit 1
fi

# Define IP addresses based on the system number
IP_ADDRESS="10.0.5.20$SYSTEM_NUM/24"

# Update the hostname accordingly
sudo hostnamectl set-hostname "u${SYSTEM_NUM}-Hasan"

# Set up network configuration
cat <<EOT > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      dhcp4: no
      addresses:
        - ${IP_ADDRESS}
      gateway4: 10.0.5.1
      nameservers:
        addresses: [10.0.5.1, 8.8.8.8]
EOT

# Apply network configuration
sudo netplan apply

# Install MariaDB
sudo apt-get update
sudo apt-get install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Automated secure MariaDB installation steps
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('Passw0rd!') WHERE User = 'root'"
sudo mysql -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -e "DROP DATABASE test"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
sudo mysql -e "FLUSH PRIVILEGES"

echo "Setup complete for system u$SYSTEM_NUM-Hasan."
