#!/bin/bash

echo "=> Setting MySQL bind address to have access from the Docker host"
sed -i 's/^bind-address\s*=.*$/bind-address = "0.0.0.0"/' /etc/mysql/my.cnf

echo "=> Starting MySQL"
/etc/init.d/mysql start &

echo "=> Waiting till MySQL is started"
mysqladmin --wait=30 ping > /dev/null 2>&1

echo "=> Creating WordPress db"
mysqladmin create wordpress

echo "=> Creating MySQL WP user and granting external access";
mysql -uroot -e "CREATE USER '$MYSQL_WP_USER'@'%' IDENTIFIED BY '$MYSQL_WP_PASSWORD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_WP_USER'@'%' WITH GRANT OPTION;"

echo "=> Shutting down MySQL"
/etc/init.d/mysql stop

echo "=> Starting MySQL again"
/etc/init.d/mysql start