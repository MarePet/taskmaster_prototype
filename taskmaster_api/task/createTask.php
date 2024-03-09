<?php

include '../connection.php'; 

$taskId = $_POST['task_id'];
$taskTitle = $_POST['title'];
$taskDescription = $_POST['description'];
$taskStage = $_POST['stage'];
$creatorId = $_POST['creator_id'];

$sqlQuery = "INSERT INTO task (title, description, stage, creator_id) VALUES ('$taskTitle','$taskDescription','$taskStage',$creatorId)";

$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}