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

$dept_id = $_POST['dept_id'];

try {
    // Fetch employees and managers from employees table for the selected department
    $stmt = $pdo->prepare("
        SELECT 
            e.emp_id,
            e.first_name,
            e.last_name,
            e.basic_salary,
            u.role,
            u.user_id
        FROM employees e
        JOIN users u ON e.user_id = u.user_id
        WHERE e.dept_id = ?
          AND u.status = 'active'
          AND u.role IN ('employee', 'manager')
        ORDER BY e.first_name, e.last_name
    ");
    $stmt->execute([$dept_id]);
    $employees = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Get dept_head user_id from departments table
    $stmt2 = $pdo->prepare("SELECT dept_head FROM departments WHERE dept_id = ?");
    $stmt2->execute([$dept_id]);
    $dept_head_user_id = $stmt2->fetchColumn();

    $dept_head_in_list = false;
    foreach ($employees as $emp) {
        if ($emp['user_id'] == $dept_head_user_id) {
            $dept_head_in_list = true;
            break;
        }
    }

    // If dept_head is not in employees list, fetch from users and add
    if ($dept_head_user_id && !$dept_head_in_list) {
        $stmt3 = $pdo->prepare("
            SELECT 
                NULL as emp_id,
                COALESCE(p.first_name, u.username) as first_name,
                COALESCE(p.last_name, '') as last_name,
                0 as basic_salary,
                u.role,
                u.user_id
            FROM users u
            LEFT JOIN profile p ON u.user_id = p.user_id
            WHERE u.user_id = ? AND u.status = 'active' AND u.role = 'manager'
        ");
        $stmt3->execute([$dept_head_user_id]);
        $head = $stmt3->fetch(PDO::FETCH_ASSOC);
        if ($head) {
            $employees[] = $head;
        }
    }

    // Remove user_id from output for frontend compatibility
    foreach ($employees as &$emp) {
        unset($emp['user_id']);
        unset($emp['role']);
    }
    
    echo json_encode($employees);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?> 