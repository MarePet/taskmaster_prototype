<?php

include '../connection.php';

$taskId = $_POST['task_id'];

$sqlQuery = "SELECT categories.* FROM categories
JOIN task_category ON categories.category_id = task_category.category_id
WHERE task_category.task_id = $taskId";

$result = $connectNow->query($sqlQuery);

$categories = [];
while ($row = $result->fetch_assoc()) {
    $categories[] = $row;
}
echo json_encode($categories);