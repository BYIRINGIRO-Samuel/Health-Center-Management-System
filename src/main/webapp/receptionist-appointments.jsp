<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pms.model.Appointment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Appointments | Reception</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Global Appointments List</h1>
                    <p class="text-muted">Manage patient arrivals and coordinate schedules.</p>
                </div>
            </header>

        <section class="container-fluid">
            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                    if (appointments != null && !appointments.isEmpty()) {
                                        for (Appointment app : appointments) {
                                %>
                                    <tr>
                                        <td><strong><%= app.getPatient().getFullName() %></strong></td>
                                        <td>Dr. <%= app.getDoctor().getFullName() %></td>
                                        <td><%= app.getAppointmentDate() %></td>
                                        <td><span class="status-badge <%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span></td>
                                        <td>
                                            <% if ("Scheduled".equals(app.getStatus())) { %>
                                            <form action="ReceptionistServlet" method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="checkin">
                                                <input type="hidden" name="appointmentId" value="<%= app.getId() %>">
                                                <button type="submit" class="btn-sm btn-solid-teal">Check-in</button>
                                            </form>
                                            <a href="ReceptionistServlet?action=billingForm&appointmentId=<%= app.getId() %>&patientId=<%= app.getPatient().getId() %>" class="btn-sm btn-solid-blue" style="text-decoration: none; margin-left: 5px;">Invoice</a>
                                            <% } else if ("Checked-in".equals(app.getStatus())) { %>
                                            <span class="text-success small">Patient is with doctor</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">No appointments found.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
        </main>
    </div>
</body>
</html>
