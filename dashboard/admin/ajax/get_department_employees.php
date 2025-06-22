<?php
session_start();
require_once '../../../config/database.php';

// Check if user is logged in and is admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    echo json_encode(['error' => 'Unauthorized access']);
    exit();
}

// Check if department ID is provided
if (!isset($_POST['dept_id'])) {
    echo json_encode(['error' => 'Department ID is required']);
    exit();
}

try {
    // Fetch employees for the selected department
    $stmt = $pdo->prepare("
        SELECT 
            emp_id,
            first_name,
            last_name,
            basic_salary
        FROM employees 
        WHERE dept_id = ?
        ORDER BY first_name, last_name
    ");
    
    $stmt->execute([$_POST['dept_id']]);
    $employees = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($employees);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?> 