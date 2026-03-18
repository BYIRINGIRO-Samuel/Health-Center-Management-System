<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.model.MedicalRecord" %>
<%@ page import="com.pms.model.Prescription" %>
<%@ page import="com.pms.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient History | Doctor Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Doctor".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        User patient = (User) request.getAttribute("patient");
        List<MedicalRecord> history = (List<MedicalRecord>) request.getAttribute("history");
        List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");

        if (patient == null) {
            response.sendRedirect("doctor-dashboard.jsp");
            return;
        }
    %>

    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <div class="page-title">
                    <h1>Patient: <%= patient.getFullName() %></h1>
                    <p class="text-muted">Medical History & Records</p>
                </div>
            </header>

            <div class="stats-grid">
                <div class="data-card" style="padding: 1.5rem;">
                    <h2 style="font-weight: 700; margin-bottom: 1.5rem;">Add Medical Record</h2>
                    <form action="DoctorServlet" method="POST">
                        <input type="hidden" name="action" value="addRecord">
                        <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                        <div class="input-group" style="margin-bottom: 1rem;">
                            <label style="font-size: 0.8rem; font-weight: 600;">Symptoms</label>
                            <textarea name="symptoms" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                        </div>
                        <div class="input-group" style="margin-bottom: 1rem;">
                            <label style="font-size: 0.8rem; font-weight: 600;">Diagnosis</label>
                            <textarea name="diagnosis" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                        </div>
                        <div class="input-group" style="margin-bottom: 1rem;">
                            <label style="font-size: 0.8rem; font-weight: 600;">Treatment Plan</label>
                            <textarea name="treatment" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                        </div>
                        <button type="submit" class="btn-primary">Save Record</button>
                    </form>
                </div>

                <div class="data-card" style="padding: 1.5rem;">
                    <h2 style="font-weight: 700; margin-bottom: 1.5rem;">Write Prescription</h2>
                    <form action="DoctorServlet" method="POST">
                        <input type="hidden" name="action" value="addPrescription">
                        <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                        <div class="input-group" style="margin-bottom: 1rem;">
                            <label style="font-size: 0.8rem; font-weight: 600;">Medications</label>
                            <textarea name="medications" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                        </div>
                        <div class="input-group" style="margin-bottom: 1rem;">
                            <label style="font-size: 0.8rem; font-weight: 600;">Dosage Instructions</label>
                            <textarea name="instructions" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 8px;"></textarea>
                        </div>
                        <button type="submit" class="btn-primary" style="background: #0ea5e9;">Prescribe</button>
                    </form>
                </div>
            </div>

            <div class="data-card" style="margin-top: 2rem;">
                <div class="data-header"><h2 style="font-weight: 700;">Clinical History</h2></div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Diagnosis</th>
                                <th>Treatment</th>
                                <th>Symptoms</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (history.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align: center; padding: 2rem;">No previous medical records.</td></tr>
                            <% } else { %>
                                <% for (MedicalRecord m : history) { %>
                                    <tr>
                                        <td><%= m.getRecordDate() %></td>
                                        <td style="font-weight: 600;"><%= m.getDiagnosis() %></td>
                                        <td><%= m.getTreatment() %></td>
                                        <td><%= m.getSymptoms() %></td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
