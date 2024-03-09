<?php

include '../connection.php'; 

$sqlQuery = "SELECT * FROM subscriptions";

$result = $connectNow->query($sqlQuery);

$subscriptions = [];
    while ($row = $result->fetch_assoc()) {
        $subscriptions[] = $row;
    }
    
    // Output tasks as JSON
    echo json_encode($subscriptions);
