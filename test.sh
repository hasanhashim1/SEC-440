#!/bin/bash

# Define variables for MySQL connection
DB_SERVER="10.0.5.201" # Change to your MySQL server IP
DB_USERNAME="your_db_username" # Change to your MySQL username
DB_PASSWORD="your_db_password" # Change to your MySQL password
DB_NAME="cats" # Change to your database name

# Install PHP and necessary extensions
echo "Installing PHP and necessary extensions..."
sudo yum install -y php php-mysqlnd

# Set SELinux boolean for HTTPD to connect to database
echo "Setting SELinux boolean for HTTPD to connect to database..."
sudo setsebool -P httpd_can_network_connect_db on

# Restart HTTPD service to apply changes
echo "Restarting HTTPD service..."
sudo systemctl restart httpd.service

# Create PHP info file
echo "Creating PHP info file..."
cat <<EOF | sudo tee /var/www/html/info.php
<?php
phpinfo();
?>
EOF

# Create HTML form and PHP script for database interaction
echo "Creating HTML form and PHP script for database interaction..."
# HTML form
cat <<EOF | sudo tee /var/www/html/index.html
<html>
<body>
<h1>Cat Info Database</h1>
<form action="cats.php" method="post">
Which cat do you want to know about? (Options: Whiskers, Shadow)</br>
Cat name: <input type="text" name="name"></br>
<input type="submit">
</form>
</body>
</html>
EOF

# PHP script
cat <<EOF | sudo tee /var/www/html/cats.php
<?php
\$servername = "$DB_SERVER";
\$username = "$DB_USERNAME";
\$password = "$DB_PASSWORD";
\$dbname = "$DB_NAME";

// Get name from HTML form
\$name = \$_POST['name'];

// Connect to DB
\$connect = new mysqli(\$servername, \$username, \$password, \$dbname);
if (\$connect->connect_error) {
    die("Connection failed: " . \$connect->connect_error);
}

// SQL query
\$query = "SELECT * FROM tabbies WHERE name = '".\$name."'";
\$output = \$connect->query(\$query) or die(\$connect->error.__LINE__);
if (\$output->num_rows > 0) {
    while(\$row = \$output->fetch_assoc()) {
        echo "Name: " . \$row["name"] . "<br>";
        echo "Age: " . \$row["age"] . "<br>";
        echo "Birthday: " . \$row["birthday"] . "<br>";
        echo "Weight: " . \$row["weight"] . "<br>";
        echo "Fur Color: " . \$row["fur_color"] . "<br>";
        echo "Description: " . \$row["description"] . "<br><br>";
    }
} else {
    echo "No results";
}
\$connect->close();
?>
EOF

echo "Setup complete. Visit http://your_server_ip/info.php and http://your_server_ip/index.html to check."
