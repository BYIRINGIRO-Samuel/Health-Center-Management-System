<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payments Overview | Admin Portal</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/folder-cards.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Payments & Revenue</h1>
                    <p class="text-muted">Monitor financial transactions</p>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card" style="background: #f0fdf4;">
                    <div class="stat-info">
                        <h3>Total Earnings</h3>
                        <p>$12,450.00</p>
                        <span style="font-size: 0.75rem; color: #22c55e;">+12.5% from last month</span>
                    </div>
                </div>
                <div class="stat-card" style="background: #fffbeb;">
                    <div class="stat-info">
                        <h3>Pending Invoices</h3>
                        <p>18</p>
                        <span style="font-size: 0.75rem; color: #d97706;">Needs attention</span>
                    </div>
                </div>
            </div>

            <div class="data-card" style="margin-top: 2rem;">
                <div class="data-header">
                    <h2 style="font-weight: 700;">Recent Transactions</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Txn ID</th>
                                <th>Patient</th>
                                <th>Department</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#TXN-8822</td>
                                <td>Sarah Jenkins</td>
                                <td>Cardiology</td>
                                <td>$450.00</td>
                                <td><span class="role-badge badge-Doctor">Success</span></td>
                            </tr>
                            <tr>
                                <td>#TXN-8821</td>
                                <td>Michael Bay</td>
                                <td>Dental Care</td>
                                <td>$120.00</td>
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
