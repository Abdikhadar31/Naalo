<?php
session_start();
require_once '../../config/database.php';
require_once 'includes/functions.php';

// Export Reports to CSV
if (isset($_POST['export_reports'])) {
    header('Content-Type: text/csv');
    header('Content-Disposition: attachment;filename=dashboard_reports_' . date('Ymd_His') . '.csv');
    $output = fopen('php://output', 'w');
    
    // Department Stats
    fputcsv($output, ['Department', 'Employee Count']);
    $stmt = $pdo->query("SELECT d.dept_name, COUNT(e.emp_id) as employee_count FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id GROUP BY d.dept_id, d.dept_name ORDER BY employee_count DESC");
    foreach ($stmt->fetchAll() as $row) {
        fputcsv($output, [$row['dept_name'], $row['employee_count']]);
    }
    
    // Add Employee Hire Report if filtered
    if (isset($_POST['filter_submitted']) && $_POST['filter_submitted'] == '1') {
        fputcsv($output, []); // Spacer
        fputcsv($output, ['Hired Employees Report']);
        $hire_start = !empty($_POST['hire_start']) ? $_POST['hire_start'] : '1900-01-01';
        $hire_end = !empty($_POST['hire_end']) ? $_POST['hire_end'] : date('Y-m-d');
        $role = !empty($_POST['role']) ? $_POST['role'] : '';

        $query = "
            SELECT e.*, u.username, u.email, u.status as user_status, u.role, d.dept_name 
            FROM employees e 
            LEFT JOIN users u ON e.user_id = u.user_id 
            LEFT JOIN departments d ON e.dept_id = d.dept_id 
            WHERE e.hire_date BETWEEN ? AND ?
        ";
        $params = [$hire_start, $hire_end];
        if ($role) {
            $query .= " AND u.role = ?";
            $params[] = $role;
        }
        $query .= " ORDER BY e.hire_date ASC";
        
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $filtered_employees = $stmt->fetchAll();

        fputcsv($output, ['Name', 'Gender', 'Role', 'Department', 'Email', 'Phone', 'Hire Date', 'Status']);
        foreach ($filtered_employees as $emp) {
            $status = 'Deleted';
            if (!empty($emp['user_status']) && $emp['user_status'] === 'active') {
                $status = 'Active';
            }
            fputcsv($output, [
                $emp['first_name'] . ' ' . $emp['last_name'],
                ucfirst($emp['gender']),
                ucfirst($emp['role'] ?? 'N/A'),
                $emp['dept_name'] ?? 'Not Assigned',
                $emp['email'] ?? 'N/A',
                $emp['phone'],
                $emp['hire_date'],
                $status
            ]);
        }
    }

    fclose($output);
    exit();
}

// Export Reports to PDF
if (isset($_POST['export_reports_pdf'])) {
    $has_fpdf = file_exists(__DIR__ . '/includes/fpdf.php');
    if (!$has_fpdf) {
        header('Content-Type: text/plain');
        echo "FPDF library not found. Please download fpdf.php from http://www.fpdf.org/ and place it in the includes directory.";
        exit();
    }
    require_once __DIR__ . '/includes/fpdf.php';

    class PDF_Report extends FPDF
    {
        // Page header
        function Header()
        {
            // Logo
            if (file_exists('../../assets/images/LOGO.jpg')) {
                $this->Image('../../assets/images/LOGO.jpg', 10, 8, 20);
            }
            // Arial bold 15
            $this->SetFont('Arial', 'B', 20);
            $this->SetTextColor(90, 92, 105);
            // Move to the right
            $this->Cell(80);
            // Title
            $this->Cell(30, 10, 'Company Report', 0, 0, 'C');
            // Report Date
            $this->SetFont('Arial', '', 10);
            $this->SetTextColor(133, 135, 150);
            $this->Cell(0, 10, 'Generated on: ' . date('Y-m-d'), 0, false, 'R');
            // Line break
            $this->Ln(25);
        }

        // Page footer
        // function Footer()
        // {
        //     // Position at 1.5 cm from bottom
        //     $this->SetY(-15);
        //     // Arial italic 8
        //     $this->SetFont('Arial', 'I', 8);
        //     $this->SetTextColor(150);
        //     // Page number
        //     $this->Cell(0, 10, 'Page ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
        // }

        // Section Title
        function SectionTitle($title)
        {
            $this->SetFont('Arial', 'B', 14);
            $this->SetFillColor(78, 115, 223); // Primary blue
            $this->SetTextColor(255, 255, 255);
            $this->Cell(0, 10, "  " . $title, 0, 1, 'L', true);
            $this->Ln(5);
        }

        // Table Header
        function FancyHeader($header, $widths)
        {
            $this->SetFont('Arial', 'B', 10);
            $this->SetFillColor(233, 238, 250); // Light blue-gray
            $this->SetTextColor(90, 92, 105); // Dark text
            $this->SetDrawColor(227, 230, 240);
            $this->SetLineWidth(0.3);
            for ($i = 0; $i < count($header); $i++) {
                $this->Cell($widths[$i], 7, $header[$i], 1, 0, 'C', true);
            }
            $this->Ln();
        }
    }

    $pdf = new PDF_Report('P', 'mm', 'A4');
    $pdf->AliasNbPages();
    $pdf->AddPage();
    $pdf->SetFont('Arial', '', 10);

    // Department Stats
    $pdf->SectionTitle('Department Statistics');
    $header = ['Department', 'Employee Count'];
    $widths = [140, 50];
    $pdf->FancyHeader($header, $widths);
    $stmt = $pdo->query("SELECT d.dept_name, COUNT(e.emp_id) as employee_count FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id GROUP BY d.dept_id, d.dept_name ORDER BY employee_count DESC");
    $pdf->SetFillColor(248, 249, 252);
    $pdf->SetTextColor(0);
    $fill = false;
    foreach ($stmt->fetchAll() as $row) {
        $pdf->Cell($widths[0], 6, $row['dept_name'], 'LR', 0, 'L', $fill);
        $pdf->Cell($widths[1], 6, $row['employee_count'], 'LR', 0, 'C', $fill);
        $pdf->Ln();
        $fill = !$fill;
    }
    $pdf->Cell(array_sum($widths), 0, '', 'T');
    $pdf->Ln(10);

    // Project Stats
    $pdf->SectionTitle('Project Status');
    $header = ['Status', 'Count'];
    $widths = [140, 50];
    $pdf->FancyHeader($header, $widths);
    $fill = false;
    $statuses = ['planning', 'ongoing', 'completed', 'on-hold'];
    foreach ($statuses as $status) {
        $count = $pdo->query("SELECT COUNT(*) FROM projects WHERE status = '" . $status . "'")->fetchColumn();
        $pdf->Cell($widths[0], 6, ucfirst($status), 'LR', 0, 'L', $fill);
        $pdf->Cell($widths[1], 6, $count, 'LR', 0, 'C', $fill);
        $pdf->Ln();
        $fill = !$fill;
    }
    $pdf->Cell(array_sum($widths), 0, '', 'T');
    $pdf->Ln(10);
    
    // Attendance Stats
    $pdf->SectionTitle('Attendance (Current Month)');
    $header = ['Status', 'Count'];
    $widths = [140, 50];
    $pdf->FancyHeader($header, $widths);
    $fill = false;
    $statuses = ['present', 'late', 'absent', 'half-day'];
    foreach ($statuses as $status) {
        $count = $pdo->query("SELECT COUNT(*) FROM attendance WHERE status = '" . $status . "' AND MONTH(attendance_date) = MONTH(CURRENT_DATE) AND YEAR(attendance_date) = YEAR(CURRENT_DATE)")->fetchColumn();
        $pdf->Cell($widths[0], 6, ucfirst($status), 'LR', 0, 'L', $fill);
        $pdf->Cell($widths[1], 6, $count, 'LR', 0, 'C', $fill);
        $pdf->Ln();
        $fill = !$fill;
    }
    $pdf->Cell(array_sum($widths), 0, '', 'T');
    $pdf->Ln(10);

    // Leave Stats
    $pdf->SectionTitle('Approved Leaves by Type');
    $header = ['Leave Type', 'Count'];
    $widths = [140, 50];
    $pdf->FancyHeader($header, $widths);
    $fill = false;
    $stmt = $pdo->query("SELECT lt.leave_type_name, COUNT(lr.leave_id) as count FROM leave_types lt LEFT JOIN leave_requests lr ON lt.leave_type_id = lr.leave_type_id AND lr.status = 'approved' GROUP BY lt.leave_type_id, lt.leave_type_name ORDER BY count DESC");
    foreach ($stmt->fetchAll() as $row) {
        $pdf->Cell($widths[0], 6, $row['leave_type_name'], 'LR', 0, 'L', $fill);
        $pdf->Cell($widths[1], 6, $row['count'], 'LR', 0, 'C', $fill);
        $pdf->Ln();
        $fill = !$fill;
    }
    $pdf->Cell(array_sum($widths), 0, '', 'T');

    // Hired Employees Report
    if (isset($_POST['filter_submitted']) && $_POST['filter_submitted'] == '1') {
        $hire_start = !empty($_POST['hire_start']) ? $_POST['hire_start'] : '1900-01-01';
        $hire_end = !empty($_POST['hire_end']) ? $_POST['hire_end'] : date('Y-m-d');
        $role = !empty($_POST['role']) ? $_POST['role'] : '';

        $query = "
            SELECT e.*, u.username, u.email, u.status as user_status, u.role, d.dept_name 
            FROM employees e 
            LEFT JOIN users u ON e.user_id = u.user_id 
            LEFT JOIN departments d ON e.dept_id = d.dept_id 
            WHERE e.hire_date BETWEEN ? AND ?
        ";
        $params = [$hire_start, $hire_end];
        if ($role) {
            $query .= " AND u.role = ?";
            $params[] = $role;
        }
        $query .= " ORDER BY e.hire_date ASC";
        
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $filtered_employees = $stmt->fetchAll();

        $pdf->AddPage('L', 'A4');
        $pdf->SectionTitle('Filtered Employee Report');
        $header = ['Name', 'Gender', 'Role', 'Department', 'Email', 'Hire Date', 'Status'];
        $widths = [50, 15, 25, 45, 58, 25, 20];
        $pdf->FancyHeader($header, $widths);
        $fill = false;
        foreach ($filtered_employees as $emp) {
            $status = 'Deleted';
            if (!empty($emp['user_status']) && $emp['user_status'] === 'active') {
                $status = 'Active';
            }
            $pdf->Cell($widths[0], 6, $emp['first_name'] . ' ' . $emp['last_name'], 'LR', 0, 'L', $fill);
            $pdf->Cell($widths[1], 6, ucfirst($emp['gender']), 'LR', 0, 'L', $fill);
            $pdf->Cell($widths[2], 6, ucfirst($emp['role'] ?? 'N/A'), 'LR', 0, 'L', $fill);
            $pdf->Cell($widths[3], 6, $emp['dept_name'] ?? 'Not Assigned', 'LR', 0, 'L', $fill);
            $pdf->Cell($widths[4], 6, $emp['email'] ?? 'N/A', 'LR', 0, 'L', $fill);
            $pdf->Cell($widths[5], 6, $emp['hire_date'], 'LR', 0, 'C', $fill);
            $pdf->Cell($widths[6], 6, $status, 'LR', 0, 'C', $fill);
            $pdf->Ln();
            $fill = !$fill;
        }
        $pdf->Cell(array_sum($widths), 0, '', 'T');
    }

    $pdf->Output('D', 'Naallo_Report_' . date('Y-m-d') . '.pdf');
    exit();
}

// Check if user is logged in and is admin
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: ../../login/admin.php");
    exit();
}

try {
    // Get total counts
    $counts = [
        'employees' => $pdo->query("SELECT COUNT(*) FROM employees")->fetchColumn(),
        'departments' => $pdo->query("SELECT COUNT(*) FROM departments")->fetchColumn(),
        'projects' => $pdo->query("SELECT COUNT(*) FROM projects WHERE status = 'ongoing'")->fetchColumn(),
        'leaves' => $pdo->query("SELECT COUNT(*) FROM leave_requests WHERE status = 'pending'")->fetchColumn()
    ];

    // Get department distribution
    $stmt = $pdo->query("
        SELECT d.dept_name, COUNT(e.emp_id) as employee_count
        FROM departments d
        LEFT JOIN employees e ON d.dept_id = e.dept_id
        GROUP BY d.dept_id, d.dept_name
        ORDER BY employee_count DESC
    ");
    $department_stats = $stmt->fetchAll();

    // Get project status distribution with all possible statuses
    $stmt = $pdo->query("
        SELECT 
            s.status,
            COUNT(p.project_id) as count
        FROM (
            SELECT 'planning' as status
            UNION SELECT 'ongoing'
            UNION SELECT 'completed'
            UNION SELECT 'on-hold'
        ) s
        LEFT JOIN projects p ON p.status = s.status
        GROUP BY s.status
    ");
    $project_stats = $stmt->fetchAll();

    // Get attendance statistics for current month with all possible statuses
    $stmt = $pdo->query("
        SELECT 
            s.status,
            COUNT(a.attendance_id) as count
        FROM (
            SELECT 'present' as status
            UNION SELECT 'late'
            UNION SELECT 'absent'
            UNION SELECT 'half-day'
        ) s
        LEFT JOIN attendance a ON a.status = s.status
            AND MONTH(a.attendance_date) = MONTH(CURRENT_DATE)
            AND YEAR(a.attendance_date) = YEAR(CURRENT_DATE)
        GROUP BY s.status
    ");
    $attendance_stats = $stmt->fetchAll();

    // Get leave type distribution including all leave types
    $stmt = $pdo->query("
        SELECT 
            lt.leave_type_name,
            COUNT(lr.leave_id) as count
        FROM leave_types lt
        LEFT JOIN leave_requests lr ON lt.leave_type_id = lr.leave_type_id
            AND lr.status = 'approved'
        GROUP BY lt.leave_type_id, lt.leave_type_name
        ORDER BY count DESC
    ");
    $leave_stats = $stmt->fetchAll();

    // Get recent activities
    $stmt = $pdo->query("
        SELECT al.*, u.username
        FROM activity_logs al
        JOIN users u ON al.user_id = u.user_id
        ORDER BY al.created_at DESC
        LIMIT 10
    ");
    $recent_activities = $stmt->fetchAll();

} catch (PDOException $e) {
    $error = "Error generating reports: " . $e->getMessage();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../assets/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
        }
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f8f9fc;
        }
        .main-content {
            background-color: #f8f9fc;
            min-height: 100vh;
        }
        /* Stat Card Styles from index.php */
        .stat-card {
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: all 0.3s ease;
            border: none;
            position: relative;
            overflow: hidden;
            height: 100%;
            color: white;
            background: linear-gradient(45deg, #4e73df, #6f8de3);
        }
        .stat-card.team {
            background: linear-gradient(45deg, var(--primary-color), #6f8de3);
        }
        .stat-card.departments {
            background: linear-gradient(45deg, var(--success-color), #4cd4a3);
        }
        .stat-card.leaves {
            background: linear-gradient(45deg, var(--warning-color), #f8d06b);
        }
        .stat-card.projects {
            background: linear-gradient(45deg, var(--info-color), #5ccfe6);
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        .stat-value {
            font-size: 1.875rem;
            font-weight: 700;
            color: white;
            margin: 0.5rem 0;
        }
        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .stat-card p.text-muted {
            color: rgba(255, 255, 255, 0.8) !important;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.15);
        }
        @media (max-width: 768px) {
            .stat-card {
                margin-bottom: 1rem;
            }
        }
        .chart-card {
            border-radius: 1rem;
            box-shadow: 0 0.25rem 2rem 0 rgba(58,59,69,.10);
            background: #fff;
            margin-bottom: 2rem;
            padding: 0;
        }
        .chart-card .card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--info-color) 100%);
            color: #fff;
            border-radius: 1rem 1rem 0 0;
            border-bottom: none;
            padding: 1rem 1.5rem 0.5rem 1.5rem;
            font-size: 1.1rem;
            font-weight: 700;
        }
        .chart-card .card-body {
            padding: 1rem 1.5rem 1.5rem 1.5rem;
            background: linear-gradient(135deg, #f8f9fc 0%, #e9eefa 100%);
            border-radius: 0 0 1rem 1rem;
        }
        .chart-container {
            position: relative;
            height: 350px;
            margin: 15px 0;
        }
        .chart-container.small {
            height: 250px;
        }
        .chart-container.medium {
            height: 300px;
        }
        @media (max-width: 991px) {
            .chart-container {
                height: 300px;
            }
            .chart-container.small {
                height: 200px;
            }
            .chart-container.medium {
                height: 250px;
            }
        }
        .chart-wrapper {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 25px;
            transition: transform 0.2s;
        }
        .chart-wrapper:hover {
            transform: translateY(-5px);
        }
        .chart-title {
            color: #4e73df;
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .chart-title i {
            font-size: 1.2rem;
            opacity: 0.8;
        }
        .chart-subtitle {
            color: #858796;
            font-size: 0.875rem;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <?php include 'includes/sidebar.php'; ?>

    <div class="main-content">
        <?php include 'includes/topbar.php'; ?>

        <div class="container-fluid py-4">
            <!-- Dashboard Header -->
            <div class="dashboard-header mb-4" style="border-radius: 16px; box-shadow: 0 2px 16px rgba(30,34,90,0.07); padding: 2rem 2rem 1.5rem 2rem; background: #fff;">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <div class="pe-3">
                        <h1 class="fw-bold mb-1" style="font-size:2rem; color:#222;">Reports</h1>
                        <div class="text-muted" style="font-size:1.1rem;">Company-wide analytics and insights</div>
                    </div>
                    <div class="d-flex gap-2">
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="export_reports" value="1">
                            <input type="hidden" name="filter_submitted" value="<?php echo isset($_GET['filter_submitted']) ? '1' : ''; ?>">
                            <input type="hidden" name="hire_start" value="<?php echo isset($_GET['hire_start']) ? htmlspecialchars($_GET['hire_start']) : ''; ?>">
                            <input type="hidden" name="hire_end" value="<?php echo isset($_GET['hire_end']) ? htmlspecialchars($_GET['hire_end']) : ''; ?>">
                            <input type="hidden" name="role" value="<?php echo isset($_GET['role']) ? htmlspecialchars($_GET['role']) : ''; ?>">
                            <button type="submit" class="btn btn-success fw-bold px-4 py-2 d-flex align-items-center" style="font-size:1rem; border-radius:8px; box-shadow:0 2px 8px rgba(40,167,69,0.08);">
                                <i class="fas fa-file-csv me-2"></i> EXPORT CSV
                            </button>
                        </form>
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="export_reports_pdf" value="1">
                            <input type="hidden" name="filter_submitted" value="<?php echo isset($_GET['filter_submitted']) ? '1' : ''; ?>">
                            <input type="hidden" name="hire_start" value="<?php echo isset($_GET['hire_start']) ? htmlspecialchars($_GET['hire_start']) : ''; ?>">
                            <input type="hidden" name="hire_end" value="<?php echo isset($_GET['hire_end']) ? htmlspecialchars($_GET['hire_end']) : ''; ?>">
                            <input type="hidden" name="role" value="<?php echo isset($_GET['role']) ? htmlspecialchars($_GET['role']) : ''; ?>">
                            <button type="submit" class="btn btn-danger fw-bold px-4 py-2 d-flex align-items-center" style="font-size:1rem; border-radius:8px; box-shadow:0 2px 8px rgba(220,53,69,0.08);">
                                <i class="fas fa-file-pdf me-2"></i> EXPORT PDF
                            </button>
                        </form>
                        <!-- <button onclick="window.print();" class="btn btn-secondary fw-bold px-4 py-2 d-flex align-items-center" style="font-size:1rem; border-radius:8px; box-shadow:0 2px 8px rgba(108,117,125,0.08);">
                            <i class="fas fa-print me-2"></i> PRINT REPORTS
                        </button> -->
                    </div>
                </div>
            </div>

            <!-- Add before the main dashboard header (after <div class="container-fluid py-4">): -->
            <form method="GET" class="row g-3 mb-4">
                <input type="hidden" name="filter_submitted" value="1">
                <div class="col-md-3">
                    <label class="form-label">Hire Date From</label>
                    <input type="date" class="form-control" name="hire_start" value="<?php echo isset($_GET['hire_start']) ? htmlspecialchars($_GET['hire_start']) : ''; ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Hire Date To</label>
                    <input type="date" class="form-control" name="hire_end" value="<?php echo isset($_GET['hire_end']) ? htmlspecialchars($_GET['hire_end']) : ''; ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Role</label>
                    <select class="form-select" name="role">
                        <option value="" <?php echo (!isset($_GET['role']) || $_GET['role'] === '') ? 'selected' : ''; ?>>All Roles</option>
                        <option value="employee" <?php echo (isset($_GET['role']) && $_GET['role'] === 'employee') ? 'selected' : ''; ?>>Employee</option>
                        <option value="manager" <?php echo (isset($_GET['role']) && $_GET['role'] === 'manager') ? 'selected' : ''; ?>>Manager</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100"><i class="fas fa-filter"></i> Filter</button>
                </div>
            </form>

            <!-- Add after the dashboard header, before the stat cards: -->
            <?php
            if (isset($_GET['filter_submitted'])) {
                $hire_start = !empty($_GET['hire_start']) ? $_GET['hire_start'] : '1900-01-01';
                $hire_end = !empty($_GET['hire_end']) ? $_GET['hire_end'] : date('Y-m-d');
                $role = !empty($_GET['role']) ? $_GET['role'] : '';

                $query = "
                    SELECT e.*, u.username, u.email, u.status as user_status, u.role, d.dept_name 
                    FROM employees e 
                    LEFT JOIN users u ON e.user_id = u.user_id 
                    LEFT JOIN departments d ON e.dept_id = d.dept_id 
                    WHERE e.hire_date BETWEEN ? AND ?
                ";
                $params = [$hire_start, $hire_end];

                if ($role) {
                    $query .= " AND u.role = ?";
                    $params[] = $role;
                }
                
                $query .= " ORDER BY e.hire_date ASC";

                $stmt = $pdo->prepare($query);
                $stmt->execute($params);
                $filtered_employees = $stmt->fetchAll();
                ?>
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white"><b>Filtered Employee Report</b></div>
                    <div class="card-body table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Gender</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Hire Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            <?php foreach ($filtered_employees as $emp): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name']); ?></td>
                                    <td><?php echo ucfirst($emp['gender']); ?></td>
                                    <td><?php echo ucfirst(htmlspecialchars($emp['role'] ?? 'N/A')); ?></td>
                                    <td><?php echo htmlspecialchars($emp['dept_name'] ?? 'Not Assigned'); ?></td>
                                    <td><?php echo htmlspecialchars($emp['email'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($emp['phone']); ?></td>
                                    <td><?php echo htmlspecialchars($emp['hire_date']); ?></td>
                                    <td>
                                        <?php if ($emp['user_status'] === 'active'): ?>
                                            <span class="badge bg-success">Active</span>
                                        <?php elseif ($emp['user_status']): ?>
                                            <span class="badge bg-danger text-white">Deleted</span>
                                        <?php else: ?>
                                            <span class="badge bg-danger">Deleted</span>
                                        <?php endif; ?>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                            </tbody>
                        </table>
                        <?php if (empty($filtered_employees)) echo '<div class="text-danger">No employees found for the selected filters.</div>'; ?>
                    </div>
                </div>
            <?php } ?>

            <!-- Stat Cards -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card team">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h6 class="stat-label">Total Employees</h6>
                        <h3 class="stat-value"><?php echo $counts['employees']; ?></h3>
                        <p class="text-muted mb-0">Active Staff Members</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card projects">
                        <div class="stat-icon">
                            <i class="fas fa-project-diagram"></i>
                        </div>
                        <h6 class="stat-label">Active Projects</h6>
                        <h3 class="stat-value"><?php echo $counts['projects']; ?></h3>
                        <p class="text-muted mb-0">Ongoing Projects</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card departments">
                        <div class="stat-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <h6 class="stat-label">Departments</h6>
                        <h3 class="stat-value"><?php echo $counts['departments']; ?></h3>
                        <p class="text-muted mb-0">Active Departments</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card leaves">
                        <div class="stat-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h6 class="stat-label">Pending Leaves</h6>
                        <h3 class="stat-value"><?php echo $counts['leaves']; ?></h3>
                        <p class="text-muted mb-0">Leave Requests</p>
                    </div>
                </div>
            </div>

            <!-- Main Charts Section -->
            <div class="row g-4">
                <!-- Employee Growth Chart -->
                <div class="col-xl-8">
                    <div class="chart-wrapper">
                        <div class="chart-title">
                            <i class="fas fa-chart-line"></i>
                            Employee Growth Trends
                        </div>
                        <div class="chart-subtitle">Department-wise employee distribution over time</div>
                        <div class="chart-container">
                            <canvas id="departmentChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Department Distribution Chart -->
                <div class="col-xl-4">
                    <div class="chart-wrapper" style="height: calc(100% - 25px);">
                        <div class="chart-title">
                            <i class="fas fa-building"></i>
                            Department Overview
                        </div>
                        <div class="chart-subtitle">Current staff distribution by department</div>
                        <div class="chart-container" style="height: calc(100% - 100px); min-height: 350px;">
                            <canvas id="projectChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Attendance Chart -->
                <div class="col-xl-6">
                    <div class="chart-wrapper" style="padding: 15px;">
                        <div class="chart-title" style="margin-bottom: 5px;">
                            <i class="fas fa-user-clock"></i>
                            Monthly Attendance
                        </div>
                        <div class="chart-subtitle" style="margin-bottom: 10px; font-size: 0.8rem;">Current month patterns</div>
                        <div class="chart-container medium">
                            <canvas id="attendanceChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Leave Distribution Chart -->
                <div class="col-xl-6">
                    <div class="chart-wrapper">
                        <div class="chart-title">
                            <i class="fas fa-calendar-alt"></i>
                            Leave Distribution
                        </div>
                        <div class="chart-subtitle">Overview of approved leaves by category</div>
                        <div class="chart-container medium">
                            <canvas id="leaveChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Chart.js color palette from index.php
        const palette = ['#4e73df', '#1cc88a', '#f6c23e', '#36b9cc'];

        // Employee Growth (Line Chart, example: use department employee counts as trend)
        const empGrowthCtx = document.getElementById('departmentChart').getContext('2d');
        new Chart(empGrowthCtx, {
            type: 'line',
            data: {
                labels: <?php echo json_encode(array_column($department_stats, 'dept_name')); ?>,
                datasets: [{
                    label: 'Employees',
                    data: <?php echo json_encode(array_column($department_stats, 'employee_count')); ?>,
                    borderColor: palette[0],
                    backgroundColor: 'rgba(78, 115, 223, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointBackgroundColor: palette[0],
                    pointBorderColor: '#fff',
                    pointHoverRadius: 6
                }]
            },
            options: {
                plugins: {
                    legend: { display: false },
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#5a5c69', font: { weight: 'bold' } }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: '#e3e6f0' },
                        ticks: { color: '#5a5c69', font: { weight: 'bold' } }
                    }
                },
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Department Distribution (Doughnut Chart)
        const deptDistCtx = document.getElementById('projectChart').getContext('2d');
        new Chart(deptDistCtx, {
            type: 'doughnut',
            data: {
                labels: <?php echo json_encode(array_column($department_stats, 'dept_name')); ?>,
                datasets: [{
                    data: <?php echo json_encode(array_column($department_stats, 'employee_count')); ?>,
                    backgroundColor: palette,
                    borderWidth: 2,
                    borderColor: '#fff',
                    hoverOffset: 8
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom', labels: { color: '#5a5c69', font: { weight: 'bold' } } },
                },
                cutout: '50%',
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Attendance Chart
        new Chart(document.getElementById('attendanceChart'), {
            type: 'pie',
            data: {
                labels: <?php echo json_encode(array_column($attendance_stats, 'status')); ?>,
                datasets: [{
                    data: <?php echo json_encode(array_column($attendance_stats, 'count')); ?>,
                    backgroundColor: palette.slice(1, 5),
                    borderWidth: 2,
                    borderColor: '#fff',
                    hoverOffset: 8
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom', labels: { color: '#5a5c69', font: { weight: 'bold' } } },
                    tooltip: { enabled: true, backgroundColor: '#222', titleColor: '#fff', bodyColor: '#fff' }
                },
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Leave Chart
        new Chart(document.getElementById('leaveChart'), {
            type: 'bar',
            data: {
                labels: <?php echo json_encode(array_column($leave_stats, 'leave_type_name')); ?>,
                datasets: [{
                    label: 'Approved Leaves',
                    data: <?php echo json_encode(array_column($leave_stats, 'count')); ?>,
                    backgroundColor: palette,
                    borderRadius: 12,
                    borderSkipped: false,
                }]
            },
            options: {
                plugins: {
                    legend: { display: false },
                    tooltip: { enabled: true, backgroundColor: '#222', titleColor: '#fff', bodyColor: '#fff' }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#5a5c69', font: { weight: 'bold' } }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: '#e3e6f0' },
                        ticks: { color: '#5a5c69', font: { weight: 'bold' } }
                    }
                },
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Sidebar Toggle
        $('#toggle-sidebar').on('click', function(e) {
            e.preventDefault();
            $('.sidebar').toggleClass('collapsed');
            $('.main-content').toggleClass('expanded');
            $('.topbar').toggleClass('expanded');
        });
    </script>
</body>
</html> 