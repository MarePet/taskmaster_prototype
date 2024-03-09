<?php

include '../connection.php'; 

$creatorId = $_POST['creator_id'];

$sqlQuery = "SELECT * FROM Task WHERE creator_id = $creatorId ORDER BY task_id DESC LIMIT 1";

$result = $connectNow->query($sqlQuery);

if ($result->num_rows > 0) {
    $task = array();
    while ($row = $result->fetch_assoc()) {
        $task[] = $row;
    }
    echo json_encode(
        array(
            "success" => true,
            "task" => $task[0],
        )
    );
} else {
    echo json_encode(array("success" => false));
}