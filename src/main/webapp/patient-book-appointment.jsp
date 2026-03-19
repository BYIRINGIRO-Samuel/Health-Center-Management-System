<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Patient".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<User> doctors = (List<User>) request.getAttribute("doctors");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | PMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar logic (simplified for placeholder) -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand">
                    <div class="brand-icon">
                        <svg viewBox="0 0 24 24"><path d="M19 14l-7 7-7-7" /><path d="M12 21V3" /></svg>
                    </div>
                    <span style="font-size: 1.5rem; font-weight: 700; color: var(--text-dark); margin-left: 10px;">PMS</span>
                </div>
            </div>
            <nav class="sidebar-menu">
                <a href="PatientServlet?action=dashboard" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    <span>Dashboard</span>
                </a>
                <a href="PatientServlet?action=profile" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>My Profile</span>
                </a>
                <a href="PatientServlet?action=bookAppointment" class="menu-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    <span>Book Appointment</span>
                </a>
                <a href="PatientServlet?action=myAppointments" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    <span>My Appointments</span>
                </a>
                <a href="PatientServlet?action=medicalHistory" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    <span>Medical History</span>
                </a>
                <a href="PatientServlet?action=prescriptions" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2L2 7l10 5 10-5-10-5z"></path><path d="M2 17l10 5 10-5"></path><path d="M2 12l10 5 10-5"></path></svg>
                    <span>Prescriptions</span>
                </a>
                <a href="PatientServlet?action=paymentHistory" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                    <span>Payment History</span>
                </a>
            </nav>
            <div class="sidebar-footer" style="padding: 2rem;">
                <a href="LogoutServlet" class="btn-primary" style="text-decoration: none; display: block; text-align: center;">Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div class="page-title" style="margin-bottom:2rem;">
                <h1>Book Appointment</h1>
                <p style="color: var(--text-muted);">Schedule a consultation with our doctors</p>
            </div>

            <div class="auth-wrapper" style="max-width: 800px; height: auto; margin: 0 auto; display: block; padding: 2rem;">
                <div class="split-right" style="padding: 0;">
                    <div class="form-header">
                        <h2>Appointment Request</h2>
                        <% if ("error".equals(request.getParameter("status"))) { %>
                            <p style="color: #EA4335; font-weight: 600;">Failed to book appointment. Please try again.</p>
                        <% } %>
                    </div>
                    
                    <form action="PatientServlet?action=bookAppointment" method="POST">
                        <div class="form-group">
                            <label>Select Doctor</label>
                            <select name="doctorId" class="form-control" required>
                                <option value="">Select a Doctor</option>
                                <% if (doctors != null) { for (User d : doctors) { %>
                                    <option value="<%= d.getId() %>"><%= d.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Preferred Date & Time</label>
                            <input type="datetime-local" name="appointmentDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Reason for Appointment</label>
                            <textarea name="reason" class="form-control" rows="3" placeholder="Describe your symptoms or reason for visit"></textarea>
                        </div>
                        
                        <button type="submit" class="btn-primary">Confirm Appointment Request</button>
                    </form>
                </div>
            </div>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
