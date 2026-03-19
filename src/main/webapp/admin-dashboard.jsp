<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, java.util.List" %>
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

            <%-- Stats Grid (Now Scrollable) --%>
            <div class="stats-scroll-container">
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Total Patients</h3>
                        <p><%= request.getAttribute("totalPatients") %></p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Active Doctors</h3>
                        <p><%= request.getAttribute("totalDoctors") %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Appointments</h3>
                        <p><%= request.getAttribute("totalAppointments") %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 1.343-3 3s1.343 3 3 3 3-1.343 3-3-1.343-3-3-3zM17 16v2a2 2 0 01-2 2H9a2 2 0 01-2-2v-2"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Total Revenue</h3>
                        <p>$<%= String.format("%.2f", (Double)request.getAttribute("totalRevenue")) %></p>
                    </div>
                </div>
            </div>

            <div class="data-card">
                <div class="data-header">
                    <h2 style="font-weight: 700; margin: 0;">Recent System Activity</h2>
                    <a href="AdminServlet?action=manageUsers" class="btn-primary" style="padding: 0.5rem 1rem; font-size: 0.8rem; text-decoration: none;">View All Users</a>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Activity</th>
                                <th>User</th>
                                <th>Timestamp</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Object[]> activity = (List<Object[]>) request.getAttribute("recentActivity");
                                if (activity != null && !activity.isEmpty()) {
                                    for (Object[] row : activity) {
                            %>
                            <tr>
                                <td><span class="role-badge badge-Admin"><%= row[0] %></span></td>
                                <td style="font-weight: 600;"><%= row[1] %></td>
                                <td><%= row[2] %></td>
                                <td><span class="role-badge" style="background: var(--teal-soft); color: var(--teal-primary);"><%= row[3] %></span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr><td colspan="4" style="text-align: center; padding: 2rem;">No recent activity.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
