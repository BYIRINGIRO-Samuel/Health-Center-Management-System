<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Schedule Appointment</h1>
                    <p class="text-muted">Connect patients with their preferred medical specialists.</p>
                </div>
            </header>

        <div class="patients-section" style="padding-top: 2rem;">
            <div class="data-card" style="max-width: 600px; margin: 0 auto; padding: 3rem;">
                <div class="data-header" style="border: none; padding: 0 0 2rem 0;">
                    <h2 class="section-title">Schedule New Appointment</h2>
                </div>
                
                <form action="ReceptionistServlet" method="POST">
                    <input type="hidden" name="action" value="bookAppointment">
                    
                    <div class="form-group">
                        <label>Select Patient</label>
                        <select name="patientId" class="form-select" required>
                            <option value="">Choosing a patient...</option>
                            <%
                                List<User> patients = (List<User>) request.getAttribute("patients");
                                String preSelectedPid = request.getParameter("patientId");
                                if (patients != null) {
                                    for (User p : patients) {
                                        String selectedAttr = (preSelectedPid != null && preSelectedPid.equals(String.valueOf(p.getId()))) ? "selected" : "";
                            %>
                                <option value="<%= p.getId() %>" <%= selectedAttr %>><%= p.getFullName() %> (<%= p.getEmail() %>)</option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-top: 1.5rem;">
                        <label>Select Doctor</label>
                        <select name="doctorId" class="form-select" required>
                            <option value="">Choose a doctor/specialist...</option>
                            <%
                                List<User> doctors = (List<User>) request.getAttribute("doctors");
                                if (doctors != null) {
                                    for (User d : doctors) {
                            %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getFullName() %></option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-top: 1.5rem;">
                        <label>Preferred Date & Time</label>
                        <input type="datetime-local" name="appointmentDate" class="form-control" required style="padding-right: 2rem;">
                    </div>

                    <div class="mt-4" style="margin-top: 2.5rem;">
                        <button type="submit" class="btn-primary" style="width: 100%; padding: 1rem; font-weight: 700;">Confirm Appointment</button>
                    </div>
                </form>
            </div>
        </div>
        </main>
    </div>
</body>
</html>
