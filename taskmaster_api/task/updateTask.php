<?php

include '../connection.php'; 

$taskId = $_POST['task_id'];
$taskTitle = $_POST['title'];
$taskDescription = $_POST['description'];
$taskStage = $_POST['stage'];
$creatorId = $_POST['creator_id'];

$sqlQuery = "UPDATE `task` 
SET `task_id`=$taskId,`title`='$taskTitle',`description`='$taskDescription',`stage`='$taskStage',`creator_id`=$creatorId WHERE task_id = $taskId";

$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}