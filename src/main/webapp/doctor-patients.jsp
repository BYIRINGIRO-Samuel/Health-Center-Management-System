<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient List | Doctor Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Doctor".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<User> patients = (List<User>) request.getAttribute("patients");
        if (patients == null) {
            response.sendRedirect("DoctorServlet?action=patients");
            return;
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Your Patients</h1>
                    <p class="text-muted">Registered patients under your care</p>
                </div>
            </header>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700;">Patient Directory</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>History</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User p : patients) { %>
                                <tr>
                                    <td>#<%= p.getId() %></td>
                                    <td style="font-weight: 600;"><%= p.getFullName() %></td>
                                    <td><%= p.getEmail() %></td>
                                    <td>
                                        <a href="DoctorServlet?action=viewHistory&patientId=<%= p.getId() %>" 
                                           class="btn-primary" style="padding: 0.3rem 0.6rem; font-size: 0.8rem; text-decoration: none;">View Record</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
