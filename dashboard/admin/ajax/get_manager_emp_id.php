<?php
session_start();
require_once '../../../config/database.php';

header('Content-Type: application/json');

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    echo json_encode(['error' => 'Unauthorized access']);
    exit();
}

if (!isset($_POST['user_id'])) {
    echo json_encode(['error' => 'User ID is required']);
    exit();
}

try {
    $stmt = $pdo->prepare("SELECT emp_id FROM employees WHERE user_id = ?");
    $stmt->execute([$_POST['user_id']]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result) {
        echo json_encode(['emp_id' => $result['emp_id']]);
    } else {
        echo json_encode(['error' => 'Employee not found']);
    }
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?> 