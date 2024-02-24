#!/bin/bash

# MySQL/MariaDB root password
ROOT_PASSWORD='Passw0rd!' # Change this to your MySQL root password
DB_NAME='cats'
DB_USER='cat_user'
DB_PASSWORD='Passw0rd!' # Change this to a secure password

# SQL statements
SQL_STATEMENTS="
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

USE ${DB_NAME};

CREATE TABLE IF NOT EXISTS tabbies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    age VARCHAR(50) NOT NULL,
    birthday VARCHAR(150) NOT NULL,
    weight VARCHAR(50) NOT NULL,
    fur_color VARCHAR(100) NOT NULL,
    description TEXT
);

INSERT INTO tabbies (name, age, birthday, weight, fur_color, description) VALUES
('Whiskers', '3 years', '2019-07-18', '10 lbs', 'Black and white', 'Very playful and loves to nap in the sun.'),
('Shadow', '5 years', '2018-05-24', '12 lbs', 'Gray', 'Shy at first, but very affectionate once she warms up to you.');
"

# Execute SQL statements
echo "${SQL_STATEMENTS}" | mysql -u root -p"${ROOT_PASSWORD}"

echo "Database and user setup complete."
