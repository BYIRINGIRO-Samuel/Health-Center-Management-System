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
    <title>Process Payment | PMS</title>
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
                <h1>Settle Invoice</h1>
                <p class="text-muted">Recording a manual payment for an outstanding balance.</p>
            </div>

            <div class="data-card" style="max-width: 600px; margin: 2rem auto; padding: 3rem;">
                <div class="data-header" style="border: none; padding: 0 0 2rem 0; text-align: center;">
                    <h2 class="section-title">Manual Payment Form</h2>
                </div>

                <div style="background: var(--teal-soft); padding: 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid var(--teal-primary);">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span class="text-muted">Patient Name:</span>
                        <strong class="text-dark"><%= billing.getPatient().getFullName() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 1.25rem;">
                        <span class="text-muted">Total Amount Due:</span>
                        <strong style="color: var(--teal-dark); font-weight: 700;">$<%= String.format("%.2f", billing.getAmount()) %></strong>
                    </div>
                </div>

                <form action="ReceptionistServlet" method="POST">
                    <input type="hidden" name="action" value="updateBillingStatus">
                    <input type="hidden" name="billingId" value="<%= billing.getId() %>">
                    <input type="hidden" name="status" value="Paid">

                    <div class="form-group">
                        <label class="form-label">Payment Method</label>
                        <select name="paymentMethod" class="form-select" required>
                            <option value="">Select how the patient is paying...</option>
                            <option value="Cash">Cash (Manual Handover)</option>
                            <option value="POS / Card">Credit / Debit Card (At Terminal)</option>
                            <option value="Mobile Money">Mobile Money Transfer</option>
                            <option value="Insurance">Insurance Provider</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-top: 1.5rem;">
                        <label class="form-label">Transaction Reference (Optional)</label>
                        <input type="text" name="refNum" class="form-control" placeholder="Receipt or Transaction ID">
                    </div>

                    <div style="margin-top: 3rem;">
                        <button type="submit" class="btn-solid-teal" style="width: 100%; padding: 1.25rem; border-radius: 12px; font-weight: 700; font-size: 1.1rem;">Confirm & Record Payment</button>
                    </div>
                    
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <a href="ReceptionistServlet?action=billings" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem;">Back to Billing Records</a>
                    </div>
                </form>
            </div>
            </div><!-- /.main-inner-content -->
        </main>
    </div>
</body>
</html>
