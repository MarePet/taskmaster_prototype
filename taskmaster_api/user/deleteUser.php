<?php

include '../connection.php';

$userId = $_POST['user_id'];

$sqlQuery = "DELETE FROM Users WHERE user_id = $userId";

$result = $connectNow->query($sqlQuery);

if ($result === TRUE) {
    echo json_encode(
        array(
            "success" => true,
        )
    );
} else {
    echo json_encode(
        array(
            "success" => true,
        )
    );
}