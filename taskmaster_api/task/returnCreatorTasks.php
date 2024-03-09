<?php

include '../connection.php'; 

$creatorId = $_POST['creator_id'];

$sqlQuery = "SELECT * FROM Task WHERE creator_id = $creatorId";

$result = $connectNow->query($sqlQuery);

$tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
    
    // Output tasks as JSON
    echo json_encode($tasks);

