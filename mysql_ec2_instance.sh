#!/bin/bash

db_root_password=Stackinc@11-root

mysql -sfu root <<EOS
-- set root password
UPDATE mysql.user SET Password=PASSWORD('$db_root_password') WHERE User='root';
-- delete anonymous users
DELETE FROM mysql.user WHERE User='';
-- delete remote root capabilities
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- drop database 'test'
DROP DATABASE IF EXISTS test;
-- also make sure there are lingering permissions to it
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- make changes immediately
FLUSH PRIVILEGES;
EOS

if (( $? == 0 ))
then
        echo "success!"
else
        echo "fail!"
        exit
fi
