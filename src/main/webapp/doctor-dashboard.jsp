<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.Appointment" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | PMS Health</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/folder-cards.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Doctor".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
        if (appointments == null) {
            response.sendRedirect("DoctorServlet?action=dashboard");
            return;
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div class="page-title" style="margin-bottom:2rem;">
                <h1>Clinic Overview</h1>
                <p class="text-muted">Welcome back, Dr. <%= currentUser.getFullName() %></p>
            </div>

            <div class="stats-scroll-container" style="display: flex; flex-wrap: nowrap; overflow-x: auto; -webkit-overflow-scrolling: touch; width: 100%; min-width: 0;">
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Today's Appts</h3>
                        <p><%= appointments.size() %></p>
                    </div>
                </div>
                <!-- More stats can be added here -->
            </div>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700;">Upcoming Appointments</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>Patient Name</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (appointments.isEmpty()) { %>
                                <tr><td colspan="5" style="text-align: center; padding: 3rem;">No appointments scheduled today.</td></tr>
                            <% } else { %>
                                <% for (Appointment a : appointments) { %>
                                    <tr>
                                        <td><%= a.getAppointmentDate() %></td>
                                        <td style="font-weight: 600;"><%= a.getPatient().getFullName() %></td>
                                        <td><%= a.getReason() %></td>
                                        <td><span class="role-badge badge-Patient"><%= a.getStatus() %></span></td>
                                        <td>
                                            <a href="DoctorServlet?action=viewHistory&patientId=<%= a.getPatient().getId() %>" class="btn-primary" style="padding: 0.3rem 0.6rem; font-size: 0.8rem; text-decoration: none;">View Profile</a>
                                        </td>
                                    </tr>
                                <% } %>
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
