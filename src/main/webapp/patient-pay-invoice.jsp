<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.Billing" %>
<%
    Billing billing = (Billing) request.getAttribute("billing");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment | PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand">
                    <div class="brand-icon">
                        <svg viewBox="0 0 24 24"><path d="M19 14l-7 7-7-7" /><path d="M12 21V3" /></svg>
                    </div>
                    <span style="font-size: 1.5rem; font-weight: 700; color: var(--text-dark); margin-left: 10px;">PMS</span>
                </div>
            </div>
            <nav class="sidebar-menu">
                <a href="PatientServlet?action=dashboard" class="menu-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    <span>Dashboard</span>
                </a>
                <a href="PatientServlet?action=paymentHistory" class="menu-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                    <span>Payments</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Complete Payment</h1>
                    <p class="text-muted">Securely pay your outstanding medical bills.</p>
                </div>
            </header>

            <div class="data-card" style="max-width: 600px; margin: 2rem auto; padding: 3rem;">
                <div class="data-header" style="border: none; padding: 0 0 2rem 0; text-align: center;">
                    <h2 class="section-title">Manual Checkout Form</h2>
                </div>

                <div style="background: #f1f5f9; padding: 2rem; border-radius: 16px; margin-bottom: 2.5rem; text-align: center;">
                    <p style="color: var(--text-muted); margin-bottom: 0.5rem; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px;">Amount to Pay</p>
                    <h1 style="font-size: 2.5rem; font-weight: 700; color: var(--text-dark);">$<%= String.format("%.2f", billing.getAmount()) %></h1>
                    <p class="text-muted" style="margin-top: 1rem; font-size: 0.85rem;">Invoice Ref: #INV-<%= billing.getId() %></p>
                </div>

                <form action="PatientServlet" method="POST">
                    <input type="hidden" name="action" value="pay">
                    <input type="hidden" name="billingId" value="<%= billing.getId() %>">

                    <div class="form-group">
                        <label class="form-label">Choose Payment Method</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <label style="border: 2px solid var(--border-color); padding: 1rem; border-radius: 12px; cursor: pointer; display: flex; align-items: center; gap: 10px;">
                                <input type="radio" name="paymentMethod" value="Credit Card" checked>
                                <span>Credit Card</span>
                            </label>
                            <label style="border: 2px solid var(--border-color); padding: 1rem; border-radius: 12px; cursor: pointer; display: flex; align-items: center; gap: 10px;">
                                <input type="radio" name="paymentMethod" value="Mobile Money">
                                <span>Mobile Money</span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group" style="margin-top: 2rem;">
                        <label class="form-label">Manual Card / Tel Number</label>
                        <input type="text" class="form-control" placeholder="Enter card or mobile number" required>
                    </div>

                    <div style="margin-top: 3rem;">
                        <button type="submit" class="btn-solid-teal" style="width: 100%; padding: 1.25rem; border-radius: 12px; font-weight: 700; font-size: 1.1rem;">Process Manual Payment</button>
                    </div>
                    
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <a href="PatientServlet?action=paymentHistory" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem;">Back to History</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
