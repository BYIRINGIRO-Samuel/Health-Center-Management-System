<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.Prescription" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescriptions | Doctor Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Doctor".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
        if (prescriptions == null) {
            // Need to update DoctorServlet to handle global prescription list or just handle it here for dummy
            // For now let's assume DoctorServlet list all prescriptions for this doctor
            prescriptions = new java.util.ArrayList<>(); // Placeholder if not provided
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Prescriptions History</h1>
                    <p class="text-muted">Review medications you've prescribed</p>
                </div>
            </header>

            <div class="data-card">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Patient</th>
                                <th>Medication</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (prescriptions.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align: center; padding: 2rem;">No prescriptions issued yet.</td></tr>
                            <% } else { %>
                                <% for (Prescription p : prescriptions) { %>
                                    <tr>
                                        <td><%= p.getDatePrescribed() %></td>
                                        <td style="font-weight: 600;"><%= p.getPatient().getFullName() %></td>
                                        <td><%= p.getMedications() %></td>
                                        <td><a href="DoctorServlet?action=viewHistory&patientId=<%= p.getPatient().getId() %>" class="btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; text-decoration: none;">View Detail</a></td>
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
