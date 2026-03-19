<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | PMS Health</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div class="page-title" style="margin-bottom:2rem;">
                <h1>Profile Settings</h1>
                <p class="text-muted">Manage your personal information</p>
            </div>

            <div class="data-card" style="max-width: 600px; padding: 2.5rem;">
                <div style="display: flex; align-items: center; gap: 2rem; margin-bottom: 2.5rem; padding-bottom: 2rem; border-bottom: 1px solid var(--border-color);">
                    <div class="avatar" style="width: 80px; height: 80px; font-size: 2rem;"><%= currentUser.getFullName().charAt(0) %></div>
                    <div>
                        <h2 style="font-size: 1.5rem; color: var(--text-dark);"><%= currentUser.getFullName() %></h2>
                        <p class="text-muted" style="font-size: 0.95rem;"><%= currentUser.getRole() %></p>
                    </div>
                </div>

                <form action="<%= currentUser.getRole() %>Servlet" method="POST">
                    <input type="hidden" name="action" value="updateProfile">
                    <% if ("success".equals(request.getParameter("status"))) { %>
                        <div style="margin-bottom: 1.5rem; padding: 1rem; background: #ecfdf5; color: #10b981; border-radius: 12px; font-weight: 600;">
                            Profile updated successfully!
                        </div>
                    <% } %>
                    <div class="input-group" style="margin-bottom: 1.5rem;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); margin-bottom: 0.5rem;">Full Name</label>
                        <input type="text" name="fullName" value="<%= currentUser.getFullName() %>" required style="width: 100%; padding: 0.75rem 1rem; border: 1px solid var(--border-color); border-radius: 12px; background: #fff;">
                    </div>
                    <div class="input-group" style="margin-bottom: 1.5rem;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); margin-bottom: 0.5rem;">Email Address</label>
                        <input type="email" name="email" value="<%= currentUser.getEmail() %>" required style="width: 100%; padding: 0.75rem 1rem; border: 1px solid var(--border-color); border-radius: 12px; background: #fff;">
                    </div>
                    <div class="input-group" style="margin-bottom: 1.5rem;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); margin-bottom: 0.5rem;">Phone Number</label>
                        <input type="tel" name="phone" value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>" style="width: 100%; padding: 0.75rem 1rem; border: 1px solid var(--border-color); border-radius: 12px; background: #fff;">
                    </div>
                    <div class="input-group" style="margin-bottom: 1.5rem;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-muted); margin-bottom: 0.5rem;">Role Assigned</label>
                        <input type="text" value="<%= currentUser.getRole() %>" readonly style="width: 100%; padding: 0.75rem 1rem; border: 1px solid var(--border-color); border-radius: 12px; background: #f9fafb;">
                    </div>
                    <button type="submit" class="btn-primary">Update Profile</button>
                </form>
            </div>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
