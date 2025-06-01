#!/bin/sh

echo "Loading database passwords from secrets..."
export DB_PASS=$(cat /run/secrets/db_password)
export DB_ROOT=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "MariaDB system db not found. Initializing db files..."
        chown -R mysql:mysql /var/lib/mysql
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then
        echo "WordPress db not found. Creating WordPress db and user..."
        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DELETE FROM     mysql.user WHERE User='${DB_USER}';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
fi

echo "Starting MariaDB server..."
exec /usr/bin/mysqld --skip-log-error