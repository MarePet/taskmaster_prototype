<?php

include '../connection.php'; 

$sqlQuery = "SELECT * FROM categories";

$result = $connectNow->query($sqlQuery);

$categories = [];
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
    
    // Output tasks as JSON
    echo json_encode($categories);