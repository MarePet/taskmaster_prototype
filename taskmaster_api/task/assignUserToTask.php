<?php

include '../connection.php'; 

$taskId = $_POST['task_id'];
$userId = $_POST['user_id'];

$sqlQuery = "INSERT INTO `user_task`(`user_id`, `task_id`) VALUES ($userId , $taskId)";

$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}