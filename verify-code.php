<?php
session_start();
require_once './config/database.php';
$email = $_GET['email'] ?? '';
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $code = implode('', array_map('trim', $_POST['code']));
    $stmt = $pdo->prepare("SELECT user_id FROM users WHERE email = ? AND reset_code = ? AND reset_code_expires > NOW()");
    $stmt->execute([$email, $code]);
    $user = $stmt->fetch();
    if ($user) {
        $_SESSION['verified_email'] = $email;
        header('Location: reset-password.php');
        exit();
    } else {
        $error = 'Invalid or expired verification code.';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Code - Naallo</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1e40af 0%, #0ea5e9 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .verify-card { background: white; border-radius: 10px; padding: 40px; width: 100%; max-width: 400px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .verify-header { margin-bottom: 30px; }
        .verify-header h1 { font-size: 24px; font-weight: 600; color: #333; margin-bottom: 5px; }
        .code-inputs { display: flex; gap: 10px; justify-content: center; margin-bottom: 20px; }
        .code-inputs input { width: 48px; height: 48px; font-size: 2rem; text-align: center; border: 1px solid #e2e8f0; border-radius: 6px; transition: border-color 0.2s; }
        .code-inputs input:focus { border-color: #1e40af; outline: none; }
        .btn { width: 100%; padding: 12px; background-color: #1e40af; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; transition: background-color 0.3s; }
        .btn:hover { background-color: #0ea5e9; }
        .error { background-color: #fee2e2; color: #991b1b; padding: 15px; border-radius: 6px; margin-bottom: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="verify-card">
        <div class="verify-header">
            <h1>Enter Verification Code</h1>
            <p>We've sent a 6-digit code to your email.<br>Please enter it below.</p>
        </div>
        <?php if ($error): ?>
            <div class="error"><?php echo htmlspecialchars($error); ?></div>
        <?php endif; ?>
        <form method="POST" id="codeForm" autocomplete="off">
            <input type="hidden" name="email" value="<?php echo htmlspecialchars($email); ?>">
            <div class="code-inputs">
                <?php for ($i = 0; $i < 6; $i++): ?>
                    <input type="text" name="code[]" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                <?php endfor; ?>
            </div>
            <button type="submit" class="btn">Verify Code</button>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    // Professional 6-digit input UX
    const inputs = document.querySelectorAll('.code-inputs input');
    inputs[0].focus();
    inputs.forEach((input, idx) => {
        input.addEventListener('input', function(e) {
            if (this.value.length === 1 && idx < 5) {
                inputs[idx + 1].focus();
            }
            // Auto-submit if all filled
            if ([...inputs].every(inp => inp.value.length === 1)) {
                document.getElementById('codeForm').submit();
            }
        });
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && !this.value && idx > 0) {
                inputs[idx - 1].focus();
            }
        });
        input.addEventListener('paste', function(e) {
            const paste = (e.clipboardData || window.clipboardData).getData('text');
            if (/^\d{6}$/.test(paste)) {
                for (let i = 0; i < 6; i++) {
                    inputs[i].value = paste[i];
                }
                document.getElementById('codeForm').submit();
            }
            e.preventDefault();
        });
    });
    <?php if ($error): ?>
    Swal.fire({
        icon: 'error',
        title: 'Invalid Code',
        text: <?php echo json_encode($error); ?>,
        confirmButtonColor: '#e74a3b'
    });
    <?php endif; ?>
    </script>
</body>
</html> 