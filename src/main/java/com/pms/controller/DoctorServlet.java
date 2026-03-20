package com.pms.controller;

import com.pms.dao.DoctorDAO;
import com.pms.dao.DoctorDAOImpl;
import com.pms.dao.UserDAO;
import com.pms.dao.UserDAOImpl;
import com.pms.model.Appointment;
import com.pms.model.MedicalRecord;
import com.pms.model.Prescription;
import com.pms.model.User;
import com.pms.model.NotificationItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/DoctorServlet")
public class DoctorServlet extends HttpServlet {
    private DoctorDAO doctorDAO = new DoctorDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        HttpSession session = request.getSession();
        User doctor = (User) session.getAttribute("user");

        if (doctor == null || !"Doctor".equals(doctor.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response, doctor);
                break;
            case "appointments":
                listAppointments(request, response, doctor);
                break;
            case "patients":
                listPatients(request, response, doctor);
                break;
            case "viewHistory":
                viewHistory(request, response);
                break;
            case "records":
                listRecords(request, response, doctor);
                break;
            case "prescriptions":
                listPrescriptions(request, response, doctor);
                break;
            case "notifications":
                java.util.List<NotificationItem> notifs = new java.util.ArrayList<>();
                java.util.Date lastCheck = doctor.getLastNotifCheck();
                if (lastCheck == null) lastCheck = new java.util.Date(0);

                for(Appointment a : doctorDAO.getAppointmentsForDoctor(doctor.getId())) {
                    if ("Scheduled".equals(a.getStatus())) {
                        boolean unread = a.getCreatedAt() != null && a.getCreatedAt().after(lastCheck);
                        notifs.add(new NotificationItem("appointment", "Upcoming Appointment", "You have an appointment with " + a.getPatient().getFullName(), a.getAppointmentDate(), unread, "Appointment", "#dbeafe", "#1e40af"));
                    }
                }
                request.setAttribute("notificationsList", notifs);
                request.getRequestDispatcher("notifications.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("doctor-dashboard.jsp");
        }
    }

    private void listRecords(HttpServletRequest request, HttpServletResponse response, User doctor) throws ServletException, IOException {
        List<MedicalRecord> records = doctorDAO.getAllRecordsForDoctor(doctor.getId());
        request.setAttribute("records", records);
        request.getRequestDispatcher("doctor-medical-records.jsp").forward(request, response);
    }

    private void listPrescriptions(HttpServletRequest request, HttpServletResponse response, User doctor) throws ServletException, IOException {
        List<Prescription> prescriptions = doctorDAO.getAllPrescriptionsForDoctor(doctor.getId());
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("doctor-prescriptions.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User doctor = (User) session.getAttribute("user");

        if (doctor == null || !"Doctor".equals(doctor.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("addRecord".equals(action)) {
            addMedicalRecord(request, response, doctor);
        } else if ("addPrescription".equals(action)) {
            addPrescription(request, response, doctor);
        } else if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            if (fullName != null) doctor.setFullName(fullName);
            if (email != null) doctor.setEmail(email);
            if (phone != null) doctor.setPhone(phone);
            userDAO.updateUser(doctor);
            session.setAttribute("user", doctor);
            response.sendRedirect("settings.jsp?status=success");
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!doctor.getPassword().equals(currentPassword)) {
                response.sendRedirect("settings.jsp?error=Current password incorrect");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("settings.jsp?error=New passwords do not match");
                return;
            }

            doctor.setPassword(newPassword);
            userDAO.updateUser(doctor);
            session.setAttribute("user", doctor);
            response.sendRedirect("settings.jsp?status=success");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User doctor) throws ServletException, IOException {
        List<Appointment> upcoming = doctorDAO.getAppointmentsForDoctor(doctor.getId());
        request.setAttribute("appointments", upcoming);
        request.getRequestDispatcher("doctor-dashboard.jsp").forward(request, response);
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response, User doctor) throws ServletException, IOException {
        List<Appointment> appointments = doctorDAO.getAppointmentsForDoctor(doctor.getId());
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("doctor-appointments.jsp").forward(request, response);
    }

    private void listPatients(HttpServletRequest request, HttpServletResponse response, User doctor) throws ServletException, IOException {
        List<User> patients = doctorDAO.getPatientsForDoctor(doctor.getId());
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("doctor-patients.jsp").forward(request, response);
    }

    private void viewHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long pid = Long.parseLong(request.getParameter("patientId"));
        User patient = userDAO.getUserById(pid);
        List<MedicalRecord> history = doctorDAO.getPatientHistory(pid);
        List<Prescription> prescriptions = doctorDAO.getPrescriptionsForPatient(pid);
        
        request.setAttribute("patient", patient);
        request.setAttribute("history", history);
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("doctor-patient-details.jsp").forward(request, response);
    }

    private void addMedicalRecord(HttpServletRequest request, HttpServletResponse response, User doctor) throws IOException {
        Long pid = Long.parseLong(request.getParameter("patientId"));
        MedicalRecord record = new MedicalRecord();
        record.setPatient(userDAO.getUserById(pid));
        record.setDoctor(doctor);
        record.setSymptoms(request.getParameter("symptoms"));
        record.setDiagnosis(request.getParameter("diagnosis"));
        record.setTreatment(request.getParameter("treatment"));
        record.setRecordDate(new Date());

        doctorDAO.createMedicalRecord(record);
        response.sendRedirect("DoctorServlet?action=viewHistory&patientId=" + pid);
    }

    private void addPrescription(HttpServletRequest request, HttpServletResponse response, User doctor) throws IOException {
        Long pid = Long.parseLong(request.getParameter("patientId"));
        Prescription prescription = new Prescription();
        prescription.setPatient(userDAO.getUserById(pid));
        prescription.setDoctor(doctor);
        prescription.setMedications(request.getParameter("medications"));
        prescription.setInstructions(request.getParameter("instructions"));
        prescription.setDatePrescribed(new Date());

        doctorDAO.writePrescription(prescription);
        response.sendRedirect("DoctorServlet?action=viewHistory&patientId=" + pid);
    }
}
