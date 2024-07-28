#!/bin/bash
# https://docs.moodle.org/403/en/Administration_via_command_line
# https://dev.to/adnanbabakan/dockerizing-laravel-with-compose-nginx-php-fpm-mariadb-phpmyadmin-8n1
# https://github.com/sammuelcp/moodle-docker
# Check if Mysql DB is online

php /usr/docker/wait_for_mysql.php

if [[ "$FIRST_INSTALL" == "true" ]]; then
    echo "First Installation. $FIRST_INSTALL"
    php -c /usr/local/etc/php/php.ini /var/www/html/admin/cli/install.php --lang=pt_br --dbtype=$DBTYPE --dataroot=$DATAROOT --dbhost=$DBHOST --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --dbport=$(($DBPORT-0)) --adminemail=admin@local.com --agree-license --wwwroot=$WWWROOT --fullname="Sala de Aula Prof. Kleyton" --shortname=Aula --adminuser=$ADMINUSER --adminpass=$ADMINPASS --adminemail=admin@local.com --supportemail=admin@local.com --non-interactive

fi

echo "<?php  // Moodle configuration file

unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = '$DBTYPE';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = '$DBHOST';
\$CFG->dbname    = '$DBNAME';
\$CFG->dbuser    = '$DBUSER';
\$CFG->dbpass    = '$DBPASS';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => $DBPORT,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_0900_ai_ci',
);

\$CFG->wwwroot   = '$WWWROOT';
\$CFG->dataroot  = '$DATAROOT';
\$CFG->admin     = '$ADMINUSER';

\$CFG->directorypermissions = 02777;
date_default_timezone_set('America/Sao_Paulo');

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!" > /var/www/html/config.php


echo "Just Updating php configuration file. $FIRST_INSTALL"

chown www-data -R /mnt/data_moodle
chmod 0777 /mnt/data_moodle

LINE='ServerName localhost'
FILE='/etc/apache2/apache2.conf'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

service apache2 start
service cron start
service apache-htcacheclean start

while true; do
  php /var/www/html/admin/cli/checks.php
  echo ""
  sleep 60
done