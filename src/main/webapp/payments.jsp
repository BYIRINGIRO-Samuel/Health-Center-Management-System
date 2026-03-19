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
<%@ page import="com.pms.model.Billing, java.util.List" %>
    <%
        List<Billing> billings = (List<Billing>) request.getAttribute("billings");
        Double totalRevenue = (Double) request.getAttribute("totalRevenue");
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

            <div class="stats-scroll-container">
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Total Revenue</h3>
                        <p>$<%= String.format("%.2f", totalRevenue != null ? totalRevenue : 0.0) %></p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255,255,255,0.2); color: white;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Total Invoices</h3>
                        <p><%= billings != null ? billings.size() : 0 %></p>
                    </div>
                </div>
            </div>

            <div class="data-card" style="margin-top: 1rem;">
                <div class="data-header">
                    <h2 style="font-weight: 700;">Recent Transactions</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Patient</th>
                                <th>Billing Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (billings != null && !billings.isEmpty()) {
                                    for (Billing b : billings) {
                            %>
                            <tr>
                                <td>#<%= b.getId() %></td>
                                <td style="font-weight: 600;"><%= b.getPatient().getFullName() %></td>
                                <td><%= b.getBillingDate() %></td>
                                <td style="color: var(--teal-dark); font-weight: 700;">$<%= String.format("%.2f", b.getAmount()) %></td>
                                <td><span class="role-badge badge-Admin">Paid</span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr><td colspan="5" style="text-align: center; padding: 3rem;">No transactions found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
