


# Galera Cluster and HAProxy Configuration

## Initial Setup on All Nodes (`u1`, `u2`, `u3`)

Before starting, ensure that all nodes (`u1`, `u2`, `u3`) are prepared for the Galera Cluster setup. This involves setting the network adapter to the LAN Network, as shown below:
![0.png](./Images/0.png)

## Stopping MariaDB on All Nodes

Stop the MariaDB service on all nodes to prepare for the Galera Cluster initialization.
```
sudo systemctl stop mariadb
```
Check the status to ensure MariaDB is stopped:
```
sudo systemctl status mariadb
```
## Starting the Galera Cluster on the First Node (`u1`)

On `u1`, initialize the Galera Cluster:
```
sudo galera_new_cluster
```
Verify the cluster size:
```
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
```
![1.png](./Images/1.png)

## Joining the Cluster on Second (`u2`) and Third Nodes (`u3`)

On `u2` and `u3`, start MariaDB and join the cluster:
```
sudo systemctl start mariadb
```
Check the status and verify the cluster size:
```
sudo systemctl status mariadb
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
```

![2.png](./Images/2.png)
![3.png](./Images/3.png)

![4.png](./Images/4.png)
![5.png](./Images/5.png)

## Verifying Replication on the First Node (`u1`)

Create a test database and table on `u1` to verify replication:

```
mysql -u root -p
CREATE DATABASE classdb_440_440;
USE classdb_440_440;
CREATE TABLE worker (id int, name varchar(20), surname varchar(20));
INSERT INTO worker VALUES (1,"Hasan","Hashim"), (2,"Ali","Hashim");
SELECT * FROM worker;
```
![6.png](./Images/6.png)
![7.png](./Images/7.png)

## Verifying Replication on Second (`u2`) and Third Nodes (`u3`)

On `u2` and `u3`, verify that the `classdb_440` database and its contents are replicated:

```
mysql -u root -p
SHOW DATABASES;
USE classdb_440;
SELECT * FROM worker;
```
![8.png](./Images/8.png)
![9.png](./Images/9.png)

On `u2`, add a new entry:
```
INSERT INTO worker VALUES (3,"nisha","sharma");
SELECT * FROM worker;
```
![10.png](./Images/10.png)

On `u3`, verify the updated entries:
```
SELECT * FROM worker;
```
![11.png](./Images/11.png)

## Setting Up HAProxy for MySQL Load Balancing

Install and configure HAProxy on the HAProxy nodes (`ha1`, `ha2`) following the detailed steps provided in the referenced guides. This includes adjusting the HAProxy configuration file (`/etc/haproxy/haproxy.cfg`) to manage MySQL traffic and ensure high availability.

Do this on all nodes ```u1, u2, and u3```

```
mysql -u root -p; CREATE USER 'ha'@'10.0.6.10'; FLUSH PRIVILAGES;
GRANT ALL PRIVILEGES ON *.* TO 'ha_root'@'10.0.6.10' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;flush privileges;
mysql -u root -p -e "SELECT User, Host FROM mysql.user"
```
![12.png](./Images/12.png)
![13.png](./Images/13.png)
![14.png](./Images/14.png)

![16.png](./Images/16.png)

![17.png](./Images/17.png)

### HAProxy Configuration

- **Install and Configure HAProxy** on `ha1` and `ha2` to manage MySQL traffic.
  - Adjust the HAProxy configuration to include all Galera nodes.
![18.png](./Images/18.png)
## Database and User Configuration

1. **Create Database and Tables:**
   - Use MariaDB commands to create databases and tables as needed.
   - Example command for creating a user and granting privileges:
     ```
     CREATE USER 'cat_user'@'%' IDENTIFIED BY 'password';
     GRANT ALL PRIVILEGES ON cats.* TO 'cat_user'@'%';
     FLUSH PRIVILEGES;
     ```

2. **Adjust Permissions for Remote Access:**
   - Ensure users can access the database from web servers.
![19.png](./Images/19.png)


## Web Server Setup (`web01` and `web02`)

1. **Configure PHP Scripts:**
   - Adjust connection strings in PHP scripts to interact with the database.
   - Example PHP code snippet for database connection:
    ![21.png](./Images/21.png)

2. **Deploy and Test PHP Scripts:**
   - Copy PHP scripts to web servers and test database connectivity.
   - Example commands for copying files and testing: [image_goes_here]
![21.png](./Images/21.png)
![20.png](./Images/20.png)

Final look:
![22.png](./Images/22.png)

## Reflection
During the project, setting up the virtual IP for the database servers turned out to be more challenging than anticipated. It was a complex task that required a detailed understanding of network configurations and how they interact with database clusters. I initially struggled to ensure seamless communication and failover between nodes. However, this hurdle ultimately served as a valuable learning experience, enhancing my troubleshooting skills and deepening my knowledge of high-availability systems.