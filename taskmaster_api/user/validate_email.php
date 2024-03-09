<?php

include '../connection.php'; 

$email = $_POST['email'];
$sqlQuery = "SELECT * FROM users WHERE email = '$email'";

$result = $connectNow->query($sqlQuery);

if($result->num_rows > 0){
    echo json_encode(array("emailFound"=> true));
}
else{
    echo json_encode(array("emailFound"=> false,));
}
