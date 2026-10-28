<?php
// EXAMPLE ONLY: keep backend/db_connect.php private and out of version control.
// Configure these environment variables in your deployment environment.
$host = getenv('IQRA_DB_HOST');
$user = getenv('IQRA_DB_USER');
$password = getenv('IQRA_DB_PASSWORD');
$database = getenv('IQRA_DB_NAME');

if (!$host || !$user || !$password || !$database) {
    throw new RuntimeException('Database environment variables are not configured.');
}

$conn = new mysqli($host, $user, $password, $database);
$conn->set_charset('utf8mb4');
