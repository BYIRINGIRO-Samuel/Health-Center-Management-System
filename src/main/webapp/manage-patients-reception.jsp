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
    <jsp:include page="components/sidebar.jsp" />
    
    <main class="main-content">
        <header class="content-header">
            <div>
                <h1>Patients</h1>
                <p>Register new patients or manage existing ones.</p>
            </div>
        </header>

        <div class="container-fluid">
            <!-- Registration Card -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">New Patient Registration</h5>
                </div>
                <div class="card-body">
                    <form action="ReceptionistServlet" method="POST" class="row g-3">
                        <input type="hidden" name="action" value="registerPatient">
                        <div class="col-md-4">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control" required placeholder="Enter full name">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Email Address</label>
                            <input type="email" name="email" class="form-control" required placeholder="email@example.com">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phone" class="form-control" required placeholder="+123456789">
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">Register</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Patients Table -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-0 py-3">
                    <h5 class="mb-0">Registered Patients</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
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
                                            <a href="ReceptionistServlet?action=bookForm&patientId=<%= patient.getId() %>" class="btn btn-sm btn-outline-primary">Book Appt</a>
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
        </div>
    </main>
</body>
</html>
