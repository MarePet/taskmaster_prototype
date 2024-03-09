<?php

include '../connection.php'; 

$taskId = $_POST['task_id'];

$sqlQuery = "DELETE FROM `task` WHERE task_id = $taskId";


$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}