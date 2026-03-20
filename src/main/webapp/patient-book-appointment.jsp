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
        <jsp:include page="components/sidebar.jsp" />

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
