<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pms.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reception Dashboard | PMS</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/folder-cards.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:2rem;">
                <div class="page-title">
                    <h1>Reception Overview</h1>
                    <p class="text-muted">Welcome back! You have a busy day ahead.</p>
                </div>
                <a href="ReceptionistServlet?action=bookForm" class="btn-primary" style="text-decoration: none; padding: 0.75rem 1.5rem; border-radius: 12px; width:auto;">Book New Appointment</a>
            </div>

        <div class="stats-scroll-container" style="display: flex; flex-wrap: nowrap; overflow-x: auto; -webkit-overflow-scrolling: touch; width: 100%; min-width: 0;">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                </div>
                <div class="stat-info">
                    <h3>Total Appts</h3>
                    <p>24</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div class="stat-info">
                    <h3>Checked In</h3>
                    <p>12</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div class="stat-info">
                    <h3>Pending</h3>
                    <p>05</p>
                </div>
            </div>
        </div>

        <section class="appointments-section">
            <div class="data-card">
                <div class="data-header">
                    <h2 class="section-title">Today's Schedule</h2>
                    <a href="ReceptionistServlet?action=appointments" class="btn-link" style="text-decoration: none; color: var(--teal-primary); font-weight: 600;">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Doctor</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Appointment> upcoming = (List<Appointment>) request.getAttribute("appointments");
                                if (upcoming != null && !upcoming.isEmpty()) {
                                    for (Appointment app : upcoming) {
                            %>
                                <tr>
                                    <td><strong><%= app.getPatient().getFullName() %></strong></td>
                                    <td>Dr. <%= app.getDoctor().getFullName() %></td>
                                    <td><%= app.getAppointmentDate() %></td>
                                    <td><span class="role-badge badge-Patient"><%= app.getStatus() %></span></td>
                                    <td>
                                        <div class="action-btns">
                                            <% if ("Scheduled".equals(app.getStatus())) { %>
                                            <form action="ReceptionistServlet" method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="checkin">
                                                <input type="hidden" name="appointmentId" value="<%= app.getId() %>">
                                                <button type="submit" class="btn-sm btn-solid-teal">Check-in</button>
                                            </form>
                                            <% } %>
                                            <a href="ReceptionistServlet?action=billingForm&appointmentId=<%= app.getId() %>&patientId=<%= app.getPatient().getId() %>" class="btn-sm btn-solid-blue" style="margin-left: 10px; text-decoration: none;">Invoice</a>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">No appointments scheduled for today.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
