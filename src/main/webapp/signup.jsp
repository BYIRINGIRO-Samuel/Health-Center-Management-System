<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | Patient Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .split-right {
            padding-top: 2rem;
            padding-bottom: 2rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="auth-page-wrapper">
        <div class="auth-wrapper">
            <!-- Left Side: Graphic & Brand -->
            <div class="split-left">
                <div class="left-content">
                    <div class="brand">
                        <div class="brand-icon">
                            <svg viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                        </div>
                        PMS Health
                    </div>

                    <div class="welcome-text">
                        <h1>Join PMS Health!</h1>
                        <p>We are a community, together helping thousands of people out there who are struggling.</p>
                    </div>

                    <div class="image-bubbles">
                        <div class="bubble bubble-1"><svg fill="currentColor" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div>
                        <div class="bubble bubble-2"><svg fill="currentColor" viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg></div>
                        <div class="bubble bubble-3"><svg fill="currentColor" viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-1.99.9-1.99 2L3 19c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-6 13h-2v-2h2v2zm0-4h-2V7h2v5z"/></svg></div>
                        <div class="bubble bubble-4"><svg fill="currentColor" viewBox="0 0 24 24"><path d="M13 3h-2v10h2V3zm4.83 2.17l-1.42 1.42A6.92 6.92 0 0 1 19 11c0 3.87-3.13 7-7 7s-7-3.13-7-7c0-2.05.88-3.9 2.26-5.18L5.84 4.4A8.91 8.91 0 0 0 3 11c0 4.97 4.03 9 9 9s9-4.03 9-9c0-2.65-1.15-5.02-2.99-6.6a.04.04 0 0 0-.01-.06z"/></svg></div>
                    </div>

                    <div class="slider-dots">
                        <div class="dot active"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Form -->
            <div class="split-right">
                <div class="form-header" style="margin-bottom: 1.5rem;">
                    <h2>Get Started</h2>
                </div>

                <form action="SignupServlet" method="POST">
                    <div class="form-group">
                        <label for="fullName">Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Jane Doe" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="jane.doe@example.com" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        <div class="password-toggle" onclick="var p=document.getElementById('password'); if(p.type==='password'){p.type='text';}else{p.type='password';}">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="role">Register As</label>
                        <select id="role" name="role" class="form-control" required>
                            <option value="" disabled selected>Select your role</option>
                            <option value="Admin">System Admin</option>
                            <option value="Doctor">Doctor / Physician</option>
                            <option value="Receptionist">Receptionist</option>
                            <option value="Patient">Patient</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-primary">Sign Up</button>
                </form>

                <div class="auth-footer" style="margin-top: 1.5rem; text-align: center;">
                    <p>Already have account? <a href="login.jsp">Sign In</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
