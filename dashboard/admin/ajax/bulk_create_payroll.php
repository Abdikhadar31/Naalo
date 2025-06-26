<?php
session_start();
require_once '../../../config/database.php';

// Check if user is logged in and is admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    echo json_encode(['success' => false, 'error' => 'Unauthorized access']);
    exit();
}

if (!isset($_POST['department']) || !isset($_POST['pay_period'])) {
    echo json_encode(['success' => false, 'error' => 'Missing required fields']);
    exit();
}

$dept_id = $_POST['department'];
$pay_period = $_POST['pay_period'];
$first_day = date('Y-m-01', strtotime($pay_period));
$last_day = date('Y-m-t', strtotime($pay_period));

// Fetch all active employees and managers in the department
$stmt = $pdo->prepare('
    SELECT e.emp_id, e.basic_salary
    FROM employees e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.dept_id = ?
      AND u.status = "active"
      AND u.role IN ("employee", "manager")
');
$stmt->execute([$dept_id]);
$employees = $stmt->fetchAll(PDO::FETCH_ASSOC);

$success_count = 0;
$error_count = 0;
$errors = [];

foreach ($employees as $emp) {
    $employee_id = $emp['emp_id'];
    $basic_salary = $emp['basic_salary'];
    // Prevent duplicate payroll for the same employee and month
    $stmt2 = $pdo->prepare('
        SELECT COUNT(*) FROM payroll p
        JOIN payroll_periods pp ON p.period_id = pp.period_id
        WHERE p.employee_id = ? AND pp.start_date = ? AND pp.end_date = ? AND p.status != "cancelled"
    ');
    $stmt2->execute([$employee_id, $first_day, $last_day]);
    if ($stmt2->fetchColumn() > 0) {
        $error_count++;
        $errors[] = "Payroll already exists for employee ID $employee_id.";
        continue;
    }
    try {
        $pdo->beginTransaction();
        // Create payroll period if it doesn't exist
        $stmt2 = $pdo->prepare("
            INSERT INTO payroll_periods (start_date, end_date, status, created_by) 
            VALUES (?, ?, 'draft', ?)
        ");
        $stmt2->execute([$first_day, $last_day, $_SESSION['user_id']]);
        $period_id = $pdo->lastInsertId();
        // Get attendance performance for the period
        $stmt2 = $pdo->prepare("
            SELECT * FROM attendance_performance 
            WHERE emp_id = ? AND month = ? AND year = ?
        ");
        $month = date('m', strtotime($pay_period));
        $year = date('Y', strtotime($pay_period));
        $stmt2->execute([$employee_id, $month, $year]);
        $attendance = $stmt2->fetch();
        // Calculate bonus based on attendance
        $bonus_percentage = 0;
        if ($attendance && $attendance['days_present'] >= 22) {
            $bonus_percentage = 10;
        } elseif ($attendance && $attendance['days_present'] >= 15) {
            $bonus_percentage = 5;
        }
        $bonus_amount = $basic_salary * ($bonus_percentage / 100);
        // Calculate gross and net salary
        $gross_salary = $basic_salary + $bonus_amount;
        $net_salary = $gross_salary;
        // Create payroll record
        $stmt2 = $pdo->prepare("
            INSERT INTO payroll (
                employee_id, period_id, basic_salary, gross_salary, net_salary, status
            ) VALUES (?, ?, ?, ?, ?, 'draft')
        ");
        $stmt2->execute([
            $employee_id,
            $period_id,
            $basic_salary,
            $gross_salary,
            $net_salary
        ]);
        $payroll_id = $pdo->lastInsertId();
        // Add bonus as adjustment if applicable
        if ($bonus_amount > 0) {
            $stmt2 = $pdo->prepare("
                INSERT INTO payroll_adjustments (
                    payroll_id, employee_id, adjustment_type, amount, description, status, approved_by
                ) VALUES (?, ?, 'bonus', ?, ?, 'approved', ?)
            ");
            $stmt2->execute([
                $payroll_id,
                $employee_id,
                $bonus_amount,
                "Attendance bonus for " . ($attendance ? $attendance['days_present'] : 0) . " days present",
                $_SESSION['user_id']
            ]);
        }
        $pdo->commit();
        $success_count++;
    } catch (Exception $e) {
        $pdo->rollBack();
        $error_count++;
        $errors[] = "Error for employee ID $employee_id: " . $e->getMessage();
    }
}

if ($success_count > 0) {
    echo json_encode(['success' => true, 'message' => "Bulk payroll processed: $success_count success, $error_count errors.", 'errors' => $errors]);
} else {
    echo json_encode(['success' => false, 'error' => 'No payrolls processed. ' . implode(' ', $errors)]);
} 