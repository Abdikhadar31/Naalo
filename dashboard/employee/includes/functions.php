<?php
/**
 * Employee Dashboard Functions
 */

/**
 * Get status badge class based on attendance status
 * @param string $status The attendance status
 * @return string Bootstrap badge class
 */
function getStatusBadgeClass($status) {
    switch (strtolower($status)) {
        case 'present':
            return 'success';
        case 'late':
            return 'warning';
        case 'absent':
            return 'danger';
        case 'half-day':
            return 'info';
        default:
            return 'secondary';
    }
}

/**
 * Format date to a readable format
 * @param string $date The date to format
 * @return string Formatted date
 */
function formatDate($date) {
    return date('M d, Y', strtotime($date));
}

/**
 * Format time to 12-hour format
 * @param string $time The time to format
 * @return string Formatted time
 */
function formatTime($time) {
    return $time ? date('h:i A', strtotime($time)) : '-';
}

/**
 * Calculate leave percentage
 * @param int $used Number of used leave days
 * @param int $total Total number of leave days
 * @return float Percentage of used leaves
 */
function calculateLeavePercentage($used, $total) {
    if ($total == 0) return 0;
    return ($used / $total) * 100;
}

/**
 * Get leave progress bar color based on percentage
 * @param float $percentage The percentage of used leaves
 * @return string Bootstrap color class
 */
function getLeaveProgressColor($percentage) {
    if ($percentage > 80) return 'danger';
    if ($percentage > 60) return 'warning';
    return 'success';
}

/**
 * Check if attendance can be marked for today
 * @return bool True if attendance can be marked, false otherwise
 */
function canMarkAttendanceToday() {
    global $pdo;
    $emp_id = $_SESSION['user_id'];
    
    $stmt = $pdo->prepare("
        SELECT COUNT(*) as count 
        FROM attendance 
        WHERE emp_id = ? 
        AND DATE(attendance_date) = CURDATE()
    ");
    $stmt->execute([$emp_id]);
    $result = $stmt->fetch();
    
    return $result['count'] == 0;
}

/**
 * Get employee's current project count
 * @param int $emp_id Employee ID
 * @return int Number of active projects
 */
function getActiveProjectCount($emp_id) {
    global $pdo;
    
    $stmt = $pdo->prepare("
        SELECT COUNT(*) as count 
        FROM project_assignments pa
        JOIN projects p ON pa.project_id = p.project_id
        WHERE pa.emp_id = ? AND p.status = 'ongoing'
    ");
    $stmt->execute([$emp_id]);
    $result = $stmt->fetch();
    
    return $result['count'];
}

/**
 * Get employee's pending leave requests count
 * @param int $emp_id Employee ID
 * @return int Number of pending leave requests
 */
function getPendingLeaveCount($emp_id) {
    global $pdo;
    
    $stmt = $pdo->prepare("
        SELECT COUNT(*) as count 
        FROM leave_requests 
        WHERE emp_id = ? AND status = 'pending'
    ");
    $stmt->execute([$emp_id]);
    $result = $stmt->fetch();
    
    return $result['count'];
}

/**
 * Centralized leave request validation
 * @param PDO $pdo
 * @param int $emp_id
 * @param int $leave_type_id
 * @param string $start_date (Y-m-d)
 * @param string $end_date (Y-m-d)
 * @return true|string Returns true if valid, or error message string
 */
function validateLeaveRequest($pdo, $emp_id, $leave_type_id, $start_date, $end_date) {
    $today = new DateTime();
    $start = new DateTime($start_date);
    $end = new DateTime($end_date);
    if ($start < $today->setTime(0,0,0)) {
        return "You cannot apply for leave starting in the past.";
    }
    // Overlap with approved leave
    $stmt = $pdo->prepare("SELECT * FROM leave_requests WHERE emp_id = ? AND status = 'approved' AND (start_date <= ? AND end_date >= ?)");
    $stmt->execute([$emp_id, $end_date, $start_date]);
    if ($stmt->fetch()) {
        return "You already have an approved leave during this period. You cannot apply for another leave until your current approved leave ends.";
    }
    // Calculate requested days (inclusive)
    $interval = $start->diff($end);
    $requested_days = $interval->days + 1;
    // Get allowed days for this leave type
    $stmt = $pdo->prepare("SELECT default_days FROM leave_types WHERE leave_type_id = ?");
    $stmt->execute([$leave_type_id]);
    $leave_type = $stmt->fetch();
    $allowed_days = $leave_type ? (int)$leave_type['default_days'] : 0;
    // Get used days for this leave type this year
    $stmt = $pdo->prepare("SELECT used_leaves FROM employee_leave_balance WHERE emp_id = ? AND leave_type_id = ? AND year = YEAR(CURRENT_DATE)");
    $stmt->execute([$emp_id, $leave_type_id]);
    $balance = $stmt->fetch();
    $used_days = $balance ? (int)$balance['used_leaves'] : 0;
    // Also count pending requests for this type this year
    $stmt = $pdo->prepare("SELECT SUM(DATEDIFF(end_date, start_date) + 1) as pending_days FROM leave_requests WHERE emp_id = ? AND leave_type_id = ? AND status = 'pending' AND YEAR(start_date) = YEAR(CURRENT_DATE)");
    $stmt->execute([$emp_id, $leave_type_id]);
    $pending = $stmt->fetch();
    $pending_days = $pending && $pending['pending_days'] ? (int)$pending['pending_days'] : 0;
    $total_used = $used_days + $pending_days;
    if ($requested_days + $total_used > $allowed_days) {
        return "You cannot request more than your allowed leave days (" . $allowed_days . ") for this leave type. You have already used or requested " . $total_used . " days.";
    }
    return true;
} 