<?php
session_start();
require_once './config/database.php';

// Only allow access if verified
if (!isset($_SESSION['verified_email'])) {
    header('Location: forget-password.php');
    exit();
}
$email = $_SESSION['verified_email'];
$error = '';
$success = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['password']) && isset($_POST['confirm_password'])) {
    if ($_POST['password'] !== $_POST['confirm_password']) {
        $error = "Passwords do not match.";
    } else {
        $new_password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        try {
            // Update password and clear reset_code
            $stmt = $pdo->prepare("UPDATE users SET password = ?, reset_code = NULL, reset_code_expires = NULL WHERE email = ?");
            $stmt->execute([$new_password, $email]);
            unset($_SESSION['verified_email']);
            $success = true;
        } catch (Exception $e) {
            $error = "Error resetting password. Please try again.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Naallo</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1e40af;
            --secondary-color: #0ea5e9;
            --dark-color: #0f172a;
            --light-color: #f1f5f9;
            --accent-color: #f97316;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .reset-card {
            background: white;
            border-radius: 10px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.5s ease-out;
        }
        .reset-header {
            margin-bottom: 30px;
        }
        .reset-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            text-align: center;
        }
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .alert-danger {
            background-color: #fee2e2;
            border: 1px solid #fecaca;
            color: #dc2626;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #64748b;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        .password-container {
            position: relative;
            width: 100%;
        }
        .password-container input {
            padding-right: 40px;
        }
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #64748b;
            font-size: 16px;
        }
        .toggle-password:hover {
            color: var(--primary-color);
        }
        .btn-reset {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-reset:hover {
            background-color: var(--secondary-color);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <div class="container">
        <div class="reset-card">
            <div class="reset-header">
                <h2>Reset Password</h2>
                <p style="color: #666; margin-top: 5px; text-align:center;">Enter your new password below</p>
            </div>
            <?php if ($error): ?>
                <div class="alert alert-danger"><?php echo htmlspecialchars($error); ?></div>
            <?php endif; ?>
            <?php if (!$success): ?>
            <form method="POST" id="resetForm">
                <div class="form-group">
                    <label for="password">New Password</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" required>
                        <span class="toggle-password" onclick="togglePassword('password', this)">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="confirm_password">Confirm New Password</label>
                    <div class="password-container">
                        <input type="password" id="confirm_password" name="confirm_password" required>
                        <span class="toggle-password" onclick="togglePassword('confirm_password', this)">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                </div>
                <button type="submit" class="btn-reset">Reset Password</button>
            </form>
            <?php endif; ?>
        </div>
    </div>
    <?php if ($success): ?>
    <script>
    Swal.fire({
        icon: 'success',
        title: 'Password Reset Successful',
        text: 'You can now login with your new password.',
        confirmButtonColor: '#4e73df'
    }).then(function() {
        window.location.href = 'login.php';
    });
    </script>
    <?php endif; ?>
    <?php if (!$success): ?>
    <script>
    function togglePassword(fieldId, el) {
        var input = document.getElementById(fieldId);
        var icon = el.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
    </script>
    <?php endif; ?>
</body>
</html>
