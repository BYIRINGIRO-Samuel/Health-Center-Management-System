<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/folder-cards.css">
    <style>
        .dashboard-container { text-align: center; padding: 4rem; background: var(--white); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); z-index: 1;}
        h1 { color: var(--teal-primary); margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <%-- Include Sidebar --%>
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Dashboard Overview</h1>
                    <p class="text-muted">Welcome back, <%= user.getFullName() %></p>
                </div>
                <div class="user-profile">
                    <div class="avatar">
                        <%= user.getFullName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-info">
                        <p style="font-weight: 700; margin: 0;"><%= user.getFullName() %></p>
                        <p style="font-size: 0.75rem; color: var(--text-muted); margin: 0;">System Administrator</p>
                    </div>
                </div>
            </header>

            <%-- Stats Grid --%>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="background: #e0f2fe; color: #0ea5e9;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Total Patients</h3>
                        <p>1,284</p>
                    </div>
                </div>
                <!-- more stats... -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #f0fdf4; color: #22c55e;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Active Doctors</h3>
                        <p>42</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: #fefce8; color: #eab308;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 1.343-3 3s1.343 3 3 3 3-1.343 3-3-1.343-3-3-3zM17 16v2a2 2 0 01-2 2H9a2 2 0 01-2-2v-2"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Revenue</h3>
                        <p>$84,200</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: #faf5ff; color: #a855f7;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Departments</h3>
                        <p>12</p>
                    </div>
                </div>
            </div>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700; margin: 0;">Recent System Activity</h2>
                    <a href="system-logs.jsp" class="btn-primary" style="padding: 0.5rem 1rem; font-size: 0.8rem; text-decoration: none;">View All</a>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Activity</th>
                                <th>User</th>
                                <th>Timestamp</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>New Doctor Registered</td>
                                <td>Dr. Michael Smith</td>
                                <td>5 mins ago</td>
                                <td><span class="role-badge badge-Doctor">Completed</span></td>
                            </tr>
                            <tr>
                                <td>System Backup</td>
                                <td>System Admin</td>
                                <td>1 hour ago</td>
                                <td><span class="role-badge badge-Admin">Success</span></td>
                            </tr>
                            <tr>
                                <td>New Patient Signup</td>
                                <td>Sarah Jenkins</td>
                                <td>2 hours ago</td>
                                <td><span class="role-badge badge-Patient">Pending</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
