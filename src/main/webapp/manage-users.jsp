<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | Admin Portal</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
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
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div class="page-title" style="margin-bottom:2rem;">
                <h1>Manage Users</h1>
                <p class="text-muted">Control user access and information</p>
            </div>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700; margin: 0;">All Registered Users</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 3rem;">No users found in the system.</td>
                                </tr>
                            <% } else { %>
                                <% for (User u : users) { %>
                                    <tr>
                                        <td>#<%= u.getId() %></td>
                                        <td style="font-weight: 600;"><%= u.getFullName() %></td>
                                        <td><%= u.getEmail() %></td>
                                        <td><span class="role-badge badge-<%= u.getRole() %>"><%= u.getRole() %></span></td>
                                        <td>
                                            <div style="display: flex; gap: 0.5rem;">
                                                <a href="AdminServlet?action=deleteUser&id=<%= u.getId() %>" 
                                                   onclick="return confirm('Are you sure you want to delete this user?')"
                                                   class="btn-primary" 
                                                   style="padding: 0.25rem 0.5rem; background: #fee2e2; color: #991b1b; font-size: 0.75rem; text-decoration: none; border: none;">Delete</a>
                                            </div>
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
