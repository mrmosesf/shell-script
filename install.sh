#!/bin/bash

wait-to-continue(){
    echo
    echo 'Press Enter to continue or Ctrl-C to exit'
    read
}

install-mysql(){
    echo 'Lets install and configure MySQL, a RDBMS'

    wait-to-continue

    sudo pacman -S mariadb

    #Initialize data directories
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    # start the mysql server
    sudo systemctl start mysqld

    # set a password for the root user, make sure no other users exist, and drop
    # the test db. Set the root password to 'password'
    mysql -u root <<-EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('password');
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
EOF
}

which mysql >/dev/null || install-mysql