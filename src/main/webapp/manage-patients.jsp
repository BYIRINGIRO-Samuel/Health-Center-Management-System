<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Patients | Admin Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<User> users = (List<User>) request.getAttribute("users");
        if (users == null) {
            users = java.util.Collections.emptyList();
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Manage Patients</h1>
                    <p class="text-muted">Total registered: <%= users.size() %></p>
                </div>
            </header>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700; margin: 0;">Patient Directory</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Patient Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : users) { %>
                                <tr>
                                    <td>#<%= u.getId() %></td>
                                    <td style="font-weight: 600;"><%= u.getFullName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="role-badge badge-Patient">Active</span></td>
                                    <td>
                                        <a href="AdminServlet?action=deleteUser&id=<%= u.getId() %>" 
                                           onclick="return confirm('Remove patient?')"
                                           class="btn-primary" 
                                           style="padding: 0.25rem 0.5rem; background: #fee2e2; color: #991b1b; font-size: 0.75rem; text-decoration: none; border: none;">Remove</a>
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
