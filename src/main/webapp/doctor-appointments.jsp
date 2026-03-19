<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.Appointment" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | Doctor Portal</title>
    <link rel="stylesheet" href="css/style.css">
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
            response.sendRedirect("DoctorServlet?action=appointments");
            return;
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Appointments Schedule</h1>
                    <p class="text-muted">Total: <%= appointments.size() %></p>
                </div>
            </header>

            <div class="data-card">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Date & Time</th>
                                <th>Patient Name</th>
                                <th>Reason</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (appointments.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align: center; padding: 2rem;">No appointments found.</td></tr>
                            <% } else { %>
                                <% for (Appointment a : appointments) { %>
                                    <tr>
                                        <td><%= a.getAppointmentDate() %></td>
                                        <td style="font-weight: 600;"><%= a.getPatient().getFullName() %></td>
                                        <td><%= a.getReason() %></td>
                                        <td><a href="DoctorServlet?action=viewHistory&patientId=<%= a.getPatient().getId() %>" class="btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; text-decoration: none;">Treat Patient</a></td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
