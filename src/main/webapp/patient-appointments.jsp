<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Patient".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | PMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body>
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:2rem;">
                <div class="page-title">
                    <h1>My Appointments</h1>
                    <p style="color: var(--text-muted);">View and manage your scheduled visits</p>
                </div>
                <a href="PatientServlet?action=bookAppointment" class="btn-primary" style="padding: 0.75rem 1.5rem; text-decoration: none; width: auto; margin-top: 0;">New Appointment</a>
            </div>

            <% if ("booked".equals(request.getParameter("status"))) { %>
                <div style="background: var(--teal-soft); color: var(--teal-primary); padding: 1rem; border-radius: 12px; margin-bottom: 2rem; border: 1px solid var(--teal-primary);">
                    Appointment booked successfully! Our team will review and confirm your request.
                </div>
            <% } %>

            <div class="data-card">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Doctor</th>
                                <th>Date & Time</th>
                                <th>Reason</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (appointments != null && !appointments.isEmpty()) {
                                    for (Appointment a : appointments) {
                            %>
                            <tr>
                                <td><%= a.getDoctor().getFullName() %></td>
                                <td><%= a.getAppointmentDate() %></td>
                                <td><%= a.getReason() %></td>
                                <td><span class="role-badge badge-<%= a.getStatus() %>"><%= a.getStatus() %></span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 4rem; color: var(--text-muted);">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 48px; opacity: 0.3; margin-bottom: 1rem;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    <p>You have no appointments scheduled.</p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
