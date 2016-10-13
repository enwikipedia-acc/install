#!/bin/bash

exit; ## this script was written after-the-fact, and gives an idea of what to do, is not guaranteed to work.

sudo apt-get install -q -y mariadb-server mariadb-client augeas-tools

mysqlsection=`augtool match /files/etc/mysql/my.cnf/target | egrep " = mysqld$" | cut -d ' ' -f 1`

sudo augtool set $mysqlsection/bind-address 0.0.0.0
sudo augtool set $mysqlsection/server-id 2
sudo augtool set $mysqlsection/slow_query_log_file /var/log/mysql/mysql-slow.log
sudo augtool set $mysqlsection/slow_query_log 1
sudo augtool set $mysqlsection/long_query_time 0.1
sudo augtool set $mysqlsection/log_queries_not_using_indexes on

sudo augtool set $mysqlsection/innodb_buffer_pool_size 2G
sudo augtool set $mysqlsection/innodb_log_file_size 512M
sudo augtool set $mysqlsection/innodb_file_per_table on

sudo service mysql restart

exit;

OLDDBSERVER='accounts-db2'
mysqldump --master-data --all-databases $OLDDBSERVER > mysql -u root
mysql -u root -e 'set global read_only = on'
mysql -u root -e 'change master to master_host="$OLDDBSERVER", master_user="repluser", master_password="changeme"'
mysql -u root -e 'start slave'
mysql -u root -e 'flush privileges'
