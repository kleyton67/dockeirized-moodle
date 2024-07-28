<?php

$DBHOST = getenv('DBHOST');
$DBUSER = getenv('DBUSER');
$DBPASS = getenv('DBPASS');
$DBPORT = getenv('DBPORT');
$DBNAME = getenv('DBNAME');

while (true) {
    try {

        if ($mysqli = mysqli_connect($DBHOST, $DBUSER, $DBPASS, $DBNAME, $DBPORT)) {
            if (mysqli_ping($mysqli)) {
                echo "MySQL is up and running!\n";
                $result = $mysqli -> query("SELECT VERSION();");
                echo "Returned rows are: " . $result -> num_rows;
                break;
            } else {
                echo "Failed to connect or ping MySQL server.\n";
            }
        } else {
            echo "MySQL connection failed: \n";
        }
        sleep(5);
    } catch (Exception $e) {
        echo 'Exceção capturada: ',  $e->getMessage(), "\n";
        sleep(5);
    }
}
