<?php

include '../connection.php';

$userId = $_POST['user_id'];
$subId = $_POST['sub_id'];

$sqlQuery = "UPDATE users SET sub_id = $subId WHERE user_id = $userId;";


$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array('success' => true));
}else{
    echo json_encode(array('success' => false));
}