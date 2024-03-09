<?php

include '../connection.php'; 

$userId = $_POST['user_id'];

$sqlQuery = "SELECT task.* FROM task 
             INNER JOIN user_task ON task.task_id = user_task.task_id 
             WHERE user_task.user_id = $userId";

$result = $connectNow->query($sqlQuery);

$tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
    
    // Output tasks as JSON
    echo json_encode($tasks);