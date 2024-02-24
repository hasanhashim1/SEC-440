#!/bin/bash

# Ask the user for the system identity
read -p "Enter the system number (1, 2, or 3 for u1, u2, u3 respectively): " SYSTEM_NUM

# Validate input and set the hostname and IP address accordingly
case $SYSTEM_NUM in
    1)
        HOSTNAME="u1-hasan"
        IP_ADDRESS="10.0.5.201"
        ;;
    2)
        HOSTNAME="u2-hasan"
        IP_ADDRESS="10.0.5.202"
        ;;
    3)
        HOSTNAME="u3-hasan"
        IP_ADDRESS="10.0.5.203"
        ;;
    *)
        echo "Invalid system number. Please enter 1, 2, or 3."
        exit 1
        ;;
esac

# Update the hostname
sudo hostnamectl set-hostname $HOSTNAME

# Galera configuration for the specified system
cat <<EOT > /etc/mysql/conf.d/galera.cnf
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="galera_cluster"
wsrep_cluster_address="gcomm://10.0.5.201,10.0.5.202,10.0.5.203"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="${IP_ADDRESS}"
wsrep_node_name="${HOSTNAME}"
EOT

# Restart MariaDB to apply Galera Cluster configurations
sudo systemctl restart mariadb

echo "Galera Cluster configuration for ${HOSTNAME} complete."
