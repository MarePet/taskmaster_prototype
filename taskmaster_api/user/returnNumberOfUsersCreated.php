<?php

include '../connection.php';

$userId = $_POST['user_id'];

$sqlQuery = "SELECT COUNT(*) AS user_count FROM users WHERE owner_id = $userId";

$result = $connectNow->query($sqlQuery);

if ($result) {
    $row = $result->fetch_assoc();
    $user_count = $row['user_count'];
    echo intval($user_count);
} else {
    echo null;
}
