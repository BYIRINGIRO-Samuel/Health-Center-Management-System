<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pms.model.Billing" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Invoices | Reception</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="main-content">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
            <div class="page-title" style="margin-bottom:2rem;">
                <h1>Invoices & Billing</h1>
                <p class="text-muted">Track patient payments and manage outstanding balances.</p>
            </div>

        <section class="billing-section">
            <!-- Add Billing Form (Simple) -->
            <% if (request.getParameter("appointmentId") != null) { %>
            <div class="data-card" style="margin-bottom: 2rem; padding: 2.5rem; max-width: 800px;">
                <div class="data-header" style="border: none; padding: 0 0 2rem 0;">
                    <h2 class="section-title">Manual Billing Form</h2>
                    <p class="text-muted">Enter the details to create a formal invoice for the patient.</p>
                </div>
                <form action="ReceptionistServlet" method="POST">
                    <input type="hidden" name="action" value="addBilling">
                    <input type="hidden" name="patientId" value="<%= request.getParameter("patientId") %>">
                    <input type="hidden" name="appointmentId" value="<%= request.getParameter("appointmentId") %>">
                    
                    <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">
                        <div class="form-group">
                            <label class="form-label">Patient ID Ref</label>
                            <input type="text" value="<%= request.getParameter("patientId") %>" readonly class="form-control" style="background: #f8fafc; color: var(--text-muted);">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Consultation Fee ($)</label>
                            <input type="number" step="0.01" name="amount" class="form-control" required placeholder="Enter amount to bill">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Billing Description / Remarks (Optional)</label>
                        <textarea name="remarks" class="form-control" rows="3" placeholder="Additional notes about the consultation or services rendered..." style="height: auto; padding: 0.75rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                    </div>

                    <div style="margin-top: 2.5rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn-solid-teal" style="padding: 1rem 2.5rem; border-radius: 8px; font-weight: 700;">Generate Official Invoice</button>
                        <a href="ReceptionistServlet?action=billings" class="btn-sm btn-outline-primary" style="padding: 1rem 2rem; text-decoration: none;">Cancel</a>
                    </div>
                </form>
            </div>
            <% } %>

            <!-- Invoices Table -->
            <div class="data-card">
                <div class="data-header">
                    <h2 class="section-title">Billing Records</h2>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Patient</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Billing> billings = (List<Billing>) request.getAttribute("billings");
                                if (billings != null && !billings.isEmpty()) {
                                    for (Billing bill : billings) {
                            %>
                                <tr>
                                    <td><%= bill.getBillingDate() %></td>
                                    <td><strong><%= bill.getPatient().getFullName() %></strong></td>
                                    <td><strong style="color: var(--teal-dark);">$<%= String.format("%.2f", bill.getAmount()) %></strong></td>
                                    <td><span class="role-badge badge-Admin"><%= bill.getStatus() %></span></td>
                                    <td>
                                        <% if ("Pending".equals(bill.getStatus())) { %>
                                            <a href="ReceptionistServlet?action=paymentForm&billingId=<%= bill.getId() %>" class="btn-sm btn-solid-teal" style="text-decoration: none;">Recieve Payment</a>
                                            <form action="ReceptionistServlet" method="POST" style="display:inline; margin-left: 5px;">
                                                <input type="hidden" name="action" value="updateBillingStatus">
                                                <input type="hidden" name="billingId" value="<%= bill.getId() %>">
                                                <input type="hidden" name="status" value="Cancelled">
                                                <button type="submit" class="btn-sm btn-outline-primary" style="padding: 0.4rem 0.8rem; border: none; background: transparent; color: #ef4444;" onclick="return confirm('Cancel this invoice?')">Cancel</button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-success small" style="font-weight: 600;">Paid Via <%= bill.getPaymentMethod() %></span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">No invoices found.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
