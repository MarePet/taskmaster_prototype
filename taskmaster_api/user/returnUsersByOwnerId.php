<?php

include '../connection.php'; 

$ownerId = $_POST['owner_id'];

$sqlQuery = "SELECT * FROM users WHERE owner_id = $ownerId";

$result = $connectNow->query($sqlQuery);

$users = [];
    while ($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
    
    // Output tasks as JSON
    echo json_encode($users);
