<?php

include '../connection.php';

$subId = $_POST['sub_id'];
$name = $_POST['name'];
$price = $_POST['price'];
$maxUsers = $_POST['max_users'];

$sqlQuery = "UPDATE `subscriptions` SET `sub_id`=$subId,`name`='$name',`price`='$price',`max_users`=$maxUsers WHERE sub_id = $subId";

$result = $connectNow->query($sqlQuery);

if ($result) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}