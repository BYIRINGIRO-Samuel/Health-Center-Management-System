<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Registration & Management | PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Patients</h1>
                    <p class="text-muted">Register new patients or manage existing ones.</p>
                </div>
            </header>

        <div class="patients-section">
            <!-- Registration Card -->
            <div class="data-card" style="margin-bottom: 2rem; padding: 2rem;">
                <div class="data-header">
                    <h2 class="section-title">New Patient Registration</h2>
                </div>
                <form action="ReceptionistServlet" method="POST" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; align-items: end;">
                    <input type="hidden" name="action" value="registerPatient">
                    <div>
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Full Name</label>
                        <input type="text" name="fullName" style="width: 100%; padding: 0.75rem; border: 1px solid var(--border-color); border-radius: 8px;" required placeholder="Enter full name">
                    </div>
                    <div>
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Email Address</label>
                        <input type="email" name="email" style="width: 100%; padding: 0.75rem; border: 1px solid var(--border-color); border-radius: 8px;" required placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Phone Number</label>
                        <input type="tel" name="phone" style="width: 100%; padding: 0.75rem; border: 1px solid var(--border-color); border-radius: 8px;" required placeholder="+123456789">
                    </div>
                    <button type="submit" class="btn-primary" style="padding: 0.75rem; border-radius: 8px; font-weight: 600;">Register</button>
                </form>
            </div>

            <!-- Patients Table -->
            <div class="data-card">
                <div class="data-header">
                    <h2 class="section-title">Registered Patients</h2>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<User> patients = (List<User>) request.getAttribute("patients");
                                if (patients != null && !patients.isEmpty()) {
                                    for (User patient : patients) {
                            %>
                                <tr>
                                    <td>#<%= patient.getId() %></td>
                                    <td><strong><%= patient.getFullName() %></strong></td>
                                    <td><%= patient.getEmail() %></td>
                                    <td><%= patient.getPhone() %></td>
                                    <td>
                                        <a href="ReceptionistServlet?action=bookForm&patientId=<%= patient.getId() %>" class="btn-link" style="text-decoration: none; font-weight: 600;">Book Appt</a>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">No patients registered yet.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </main>
    </div>
</body>
</html>
