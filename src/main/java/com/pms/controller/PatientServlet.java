package com.pms.controller;

import com.pms.dao.PatientDAO;
import com.pms.dao.PatientDAOImpl;
import com.pms.dao.UserDAO;
import com.pms.dao.UserDAOImpl;
import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.MedicalRecord;
import com.pms.model.Prescription;
import com.pms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {
    private PatientDAO patientDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("Initializing PatientServlet...");
        try {
            patientDAO = new PatientDAOImpl();
            userDAO = new UserDAOImpl();
            System.out.println("PatientServlet initialized successfully.");
        } catch (Exception e) {
            System.err.println("Failed to initialize PatientServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");

        if (patient == null || !"Patient".equals(patient.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response, patient.getId());
                break;
            case "profile":
                showProfile(request, response, patient.getId());
                break;
            case "bookAppointment":
                showBookingForm(request, response);
                break;
            case "myAppointments":
                listAppointments(request, response, patient.getId());
                break;
            case "payForm":
                Long bidParam = Long.parseLong(request.getParameter("billingId"));
                request.setAttribute("billing", patientDAO.getBillingsByPatientId(patient.getId()).stream().filter(b -> b.getId().equals(bidParam)).findFirst().orElse(null));
                request.getRequestDispatcher("patient-pay-invoice.jsp").forward(request, response);
                break;
            case "medicalHistory":
                listMedicalHistory(request, response, patient.getId());
                break;
            case "prescriptions":
                listPrescriptions(request, response, patient.getId());
                break;
            case "paymentHistory":
                listPaymentHistory(request, response, patient.getId());
                break;
            case "notifications":
                java.util.List<com.pms.model.NotificationItem> notifs = new java.util.ArrayList<>();
                java.util.Date lastCheck = patient.getLastNotifCheck();
                if (lastCheck == null) lastCheck = new java.util.Date(0);

                for(com.pms.model.Appointment a : patientDAO.getAppointmentsByPatientId(patient.getId())) {
                    boolean unread = a.getCreatedAt() != null && a.getCreatedAt().after(lastCheck);
                    notifs.add(new com.pms.model.NotificationItem("appointment", "Appointment " + a.getStatus(), "Appointment with " + a.getDoctor().getFullName(), a.getAppointmentDate(), unread, "Appointment", "#dbeafe", "#1e40af"));
                }
                for(com.pms.model.Billing b : patientDAO.getBillingsByPatientId(patient.getId())) {
                    if("Pending".equals(b.getStatus())) {
                        boolean unread = b.getBillingDate() != null && b.getBillingDate().after(lastCheck);
                        notifs.add(new com.pms.model.NotificationItem("payment", "Pending Payment", "You have a pending payment of $" + b.getAmount(), b.getBillingDate(), unread, "Payment", "#dcfce7", "#15803d"));
                    }
                }
                request.setAttribute("notificationsList", notifs);
                request.getRequestDispatcher("notifications.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("PatientServlet?action=dashboard");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("user");

        if (patient == null || !"Patient".equals(patient.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, patient);
        } else if ("bookAppointment".equals(action)) {
            bookAppointment(request, response, patient);
        } else if ("pay".equals(action)) {
            processPayment(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        List<Appointment> appointments = patientDAO.getAppointmentsByPatientId(patientId);
        List<Prescription> prescriptions = patientDAO.getPrescriptionsByPatientId(patientId);
        List<Billing> billings = patientDAO.getBillingsByPatientId(patientId);

        request.setAttribute("appointments", appointments);
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("billings", billings);
        request.getRequestDispatcher("patient-dashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        User user = patientDAO.getPatientById(patientId);
        request.setAttribute("patient", user);
        request.getRequestDispatcher("patient-profile.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> doctors = patientDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("patient-book-appointment.jsp").forward(request, response);
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        List<Appointment> appointments = patientDAO.getAppointmentsByPatientId(patientId);
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("patient-appointments.jsp").forward(request, response);
    }

    private void listMedicalHistory(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        List<MedicalRecord> records = patientDAO.getMedicalRecordsByPatientId(patientId);
        request.setAttribute("records", records);
        request.getRequestDispatcher("patient-medical-history.jsp").forward(request, response);
    }

    private void listPrescriptions(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        List<Prescription> prescriptions = patientDAO.getPrescriptionsByPatientId(patientId);
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("patient-prescriptions.jsp").forward(request, response);
    }

    private void listPaymentHistory(HttpServletRequest request, HttpServletResponse response, Long patientId) throws ServletException, IOException {
        List<Billing> billings = patientDAO.getBillingsByPatientId(patientId);
        request.setAttribute("billings", billings);
        request.getRequestDispatcher("patient-payment-history.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User patient) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // In a real application, you would hash passwords and compare hashes.
        // For this example, we're doing a direct string comparison.
        if (!patient.getPassword().equals(currentPassword)) {
            response.sendRedirect("settings.jsp?error=Current password incorrect");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("settings.jsp?error=New passwords do not match");
            return;
        }

        // In a real application, you would hash the new password before setting it.
        patient.setPassword(newPassword);
        userDAO.updateUser(patient); // Assuming userDAO has an updateUser method that handles password updates
        response.sendRedirect("settings.jsp?status=passwordUpdated");
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentPatient) throws IOException {
        currentPatient.setFullName(request.getParameter("fullName"));
        currentPatient.setEmail(request.getParameter("email"));
        currentPatient.setPhone(request.getParameter("phone"));
        patientDAO.updateProfile(currentPatient);
        response.sendRedirect("settings.jsp?status=profileUpdated");
    }

    private void bookAppointment(HttpServletRequest request, HttpServletResponse response, User patient) throws IOException {
        Long doctorId = Long.parseLong(request.getParameter("doctorId"));
        String dateStr = request.getParameter("appointmentDate");
        String reason = request.getParameter("reason");

        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date appointmentDate = sdf.parse(dateStr);
            Appointment appointment = new Appointment();
            appointment.setPatient(patient);
            appointment.setDoctor(userDAO.getUserById(doctorId));
            appointment.setAppointmentDate(appointmentDate);
            appointment.setReason(reason);
            appointment.setStatus("Pending");
            patientDAO.bookAppointment(appointment);
            response.sendRedirect("PatientServlet?action=myAppointments&status=booked");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PatientServlet?action=bookAppointment&status=error");
        }
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long billingId = Long.parseLong(request.getParameter("billingId"));
        String method = request.getParameter("paymentMethod");
        patientDAO.payBilling(billingId, method);
        response.sendRedirect("PatientServlet?action=paymentHistory&status=paid");
    }
}
