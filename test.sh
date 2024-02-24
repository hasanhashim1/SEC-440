#!/bin/bash

# Define MySQL Database Credentials
DB_SERVER="10.0.5.201" # Change to your MySQL server IP
DB_USER="cat_user" # Your MySQL username
DB_PASS="PasswØrd!" # Your MySQL password
DB_NAME="cats" # Your MySQL database name

# Install PHP and MySQL extension
echo "Installing PHP and MySQL extension..."
sudo yum install -y php php-mysqlnd

# Enable HTTPD to connect to MySQL Database
echo "Setting SELinux boolean for HTTPD to connect to DB..."
sudo setsebool -P httpd_can_network_connect_db on

# Restart Apache to apply changes
echo "Restarting HTTPD service..."
sudo systemctl restart httpd.service

# Create PHP file to display PHP info
echo "Creating info.php file..."
cat <<EOF | sudo tee /var/www/html/info.php
<?php
phpinfo();
?>
EOF

# Create PHP file to interact with MySQL Database
echo "Creating cats.php file..."
cat <<EOF | sudo tee /var/www/html/cats.php
<?php
\$servername = "$DB_SERVER";
\$username = "$DB_USER";
\$password = "$DB_PASS";
\$dbname = "$DB_NAME";

// Get name from HTML form
\$name = \$_POST['name'];

// Connect to DB
\$connect = new mysqli(\$servername, \$username, \$password, \$dbname);
if (\$connect->connect_error) {
    die("Connection failed: " . \$connect->connect_error);
}

\$query = \$connect->prepare("SELECT * FROM tabbies WHERE name = ?");
\$query->bind_param("s", \$name);
\$query->execute();
\$result = \$query->get_result();

if (\$result->num_rows > 0) {
    while(\$row = \$result->fetch_assoc()) {
        echo "Name: " . \$row["name"] . "<br>";
        echo "Age: " . \$row["age"] . "<br>";
        echo "Birthday: " . \$row["birthday"] . "<br>";
        echo "Weight: " . \$row["weight"] . "<br>";
        echo "Fur Color: " . \$row["fur_color"] . "<br>";
        echo "Description: " . \$row["description"] . "<br><br>";
    }
} else {
    echo "0 results";
}
\$connect->close();
?>
EOF

# Create HTML form to query the database
echo "Creating index.html file..."
cat <<EOF | sudo tee /var/www/html/index.html
<html>
<body>
<h1>Cat Info Database</h1>
<form action="cats.php" method="post">
Which cat do you want to know about? (Options: Whiskers, Shadow)<br>
Cat name: <input type="text" name="name"><br>
<input type="submit">
</form>
</body>
</html>
EOF

echo "Setup completed on web02. Test by accessing http://web02_ip/info.php and http://web02_ip/index.html"
