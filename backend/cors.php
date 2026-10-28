<?php

// ===============================================
// IQRA - CORS Configuration
// For Flutter Web and Android API compatibility
// ===============================================

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';

// Production website
$productionOrigin = 'https://salahayash.helioho.st';

// Flutter Web local development
$isLocalhost = preg_match(
    '#^http://(localhost|127\.0\.0\.1):[0-9]{1,5}$#',
    $origin
) === 1;

// Allow the IQRA website and local development
$isAllowed = (
    $origin === $productionOrigin ||
    $isLocalhost
);

if ($isAllowed) {

    header(
        "Access-Control-Allow-Origin: $origin"
    );

    header("Vary: Origin");

    header(
        "Access-Control-Allow-Methods: GET, POST, OPTIONS"
    );

    header(
        "Access-Control-Allow-Headers: Content-Type, Authorization"
    );
}

// Handle browser preflight requests
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {

    if (!$isAllowed) {
        http_response_code(403);
        exit;
    }

    http_response_code(204);
    exit;
}
?>
