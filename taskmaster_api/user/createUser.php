<?php

include '../connection.php'; 

$firstName = $_POST['first_name'];
$lastName = $_POST['last_name'];
$email = $_POST['email'];
$password = md5($_POST['password']);
$ownerId = $_POST['owner_id'];
$userRole = $_POST['user_role'];

$sqlQuery = "INSERT INTO users 
SET first_name = '$firstName',
    last_name = '$lastName',
    email = '$email',
    password = '$password',
    owner_id = $ownerId,
    user_role = $userRole
    ";

$result = $connectNow->query($sqlQuery);

if($result){
    echo json_encode(array("success"=> true));
}
else{
    echo json_encode(array("success"=> false));
}
