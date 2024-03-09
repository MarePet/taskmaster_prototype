<?php

include '../connection.php'; 

$taskId = $_POST['task_id'];
$categoryId = $_POST['category_id'];

$sqlQuery = "INSERT INTO `task_category`(`task_id`, `category_id`) VALUES ($taskId , $categoryId)";

$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}