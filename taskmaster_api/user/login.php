<?php

include '../connection.php';

$email = $_POST['email'];
$password = md5($_POST['password']);


$sqlQuery = "SELECT * FROM users
             WHERE email = '$email' AND password = '$password'";

$result = $connectNow->query($sqlQuery);

if ($result->num_rows > 0) {
    $userRecord = array();
    while ($row = $result->fetch_assoc()) {
        $userRecord[] = $row;
    }
    echo json_encode(
        array(
            "success" => true,
            "userData" => $userRecord[0],
        )
    );
} else {
    echo json_encode(array("success" => false));
}