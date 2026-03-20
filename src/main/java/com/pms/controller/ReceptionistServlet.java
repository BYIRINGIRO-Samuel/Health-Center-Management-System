package com.pms.controller;

import com.pms.dao.*;
import com.pms.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/ReceptionistServlet")
public class ReceptionistServlet extends HttpServlet {
    private ReceptionistDAO receptionistDAO = new ReceptionistDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();
    private DoctorDAO doctorDAO = new DoctorDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        HttpSession session = request.getSession();
        User receptionist = (User) session.getAttribute("user");

        if (receptionist == null || !"Receptionist".equals(receptionist.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "patients":
                listPatients(request, response);
                break;
            case "appointments":
                listAppointments(request, response);
                break;
            case "billings":
                listBillings(request, response);
                break;
            case "billingForm":
                request.getRequestDispatcher("receptionist-billing.jsp").forward(request, response);
                break;
            case "bookForm":
                showBookingForm(request, response);
                break;
            case "paymentForm":
                Long bidParam = Long.parseLong(request.getParameter("billingId"));
                request.setAttribute("billing", receptionistDAO.getBillingById(bidParam));
                request.getRequestDispatcher("receptionist-payment.jsp").forward(request, response);
                break;
            case "notifications":
                java.util.List<NotificationItem> notifs = new java.util.ArrayList<>();
                for(Billing b : receptionistDAO.getAllBillings()) {
                    if ("Pending".equals(b.getStatus())) {
                        notifs.add(new NotificationItem("payment", "Pending Payment", "Billing of $" + b.getAmount() + " for " + b.getPatient().getFullName() + " is pending.", b.getBillingDate(), true, "Payment", "#dcfce7", "#15803d"));
                    }
                }
                request.setAttribute("notificationsList", notifs);
                request.getRequestDispatcher("notifications.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("receptionist-dashboard.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User receptionist = (User) session.getAttribute("user");

        if (receptionist == null || !"Receptionist".equals(receptionist.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("registerPatient".equals(action)) {
            registerPatient(request, response);
        } else if ("bookAppointment".equals(action)) {
            bookAppointment(request, response);
        } else if ("checkin".equals(action)) {
            checkinPatient(request, response);
        } else if ("addBilling".equals(action)) {
            addBilling(request, response);
        } else if ("updateBillingStatus".equals(action)) {
            updateBillingStatus(request, response);
        } else if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            if (fullName != null) receptionist.setFullName(fullName);
            if (email != null) receptionist.setEmail(email);
            if (phone != null) receptionist.setPhone(phone);
            userDAO.updateUser(receptionist);
            session.setAttribute("user", receptionist);
            response.sendRedirect("settings.jsp?status=success");
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!receptionist.getPassword().equals(currentPassword)) {
                response.sendRedirect("settings.jsp?error=Current password incorrect");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("settings.jsp?error=New passwords do not match");
                return;
            }

            receptionist.setPassword(newPassword);
            userDAO.updateUser(receptionist);
            session.setAttribute("user", receptionist);
            response.sendRedirect("settings.jsp?status=success");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Appointment> all = receptionistDAO.getAllAppointments();
        request.setAttribute("appointments", all);
        request.getRequestDispatcher("receptionist-dashboard.jsp").forward(request, response);
    }

    private void listPatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> patients = receptionistDAO.getAllPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("manage-patients-reception.jsp").forward(request, response);
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Appointment> appointments = receptionistDAO.getAllAppointments();
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("receptionist-appointments.jsp").forward(request, response);
    }

    private void listBillings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Billing> billings = receptionistDAO.getAllBillings();
        request.setAttribute("billings", billings);
        request.getRequestDispatcher("receptionist-billing.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> patients = receptionistDAO.getAllPatients();
        List<User> doctors = userDAO.getAllUsers().stream().filter(u -> "Doctor".equals(u.getRole())).toList();
        request.setAttribute("patients", patients);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
    }

    private void registerPatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User patient = new User();
        patient.setFullName(request.getParameter("fullName"));
        patient.setEmail(request.getParameter("email"));
        patient.setPhone(request.getParameter("phone"));
        patient.setPassword("Patient123!"); // Default password
        patient.setRole("Patient");
        receptionistDAO.registerPatient(patient);
        response.sendRedirect("ReceptionistServlet?action=patients");
    }

    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long pid = Long.parseLong(request.getParameter("patientId"));
        Long did = Long.parseLong(request.getParameter("doctorId"));
        String dateStr = request.getParameter("appointmentDate");
        
        Appointment appointment = new Appointment();
        appointment.setPatient(userDAO.getUserById(pid));
        appointment.setDoctor(userDAO.getUserById(did));
        
        try {
            // Updated to parse datetime-local from form
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            appointment.setAppointmentDate(sdf.parse(dateStr));
        } catch (Exception e) {
            appointment.setAppointmentDate(new java.util.Date()); // Fallback
        }
        
        appointment.setStatus("Scheduled");
        receptionistDAO.bookAppointment(appointment);
        response.sendRedirect("ReceptionistServlet?action=appointments");
    }

    private void checkinPatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long aid = Long.parseLong(request.getParameter("appointmentId"));
        receptionistDAO.updateAppointmentStatus(aid, "Checked-in");
        response.sendRedirect("ReceptionistServlet?action=appointments");
    }

    private void addBilling(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long pid = Long.parseLong(request.getParameter("patientId"));
        Long aid = Long.parseLong(request.getParameter("appointmentId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        
        Billing billing = new Billing();
        billing.setPatient(userDAO.getUserById(pid));
        billing.setAppointment(new Appointment()); // Use simple ref
        billing.getAppointment().setId(aid); 
        billing.setAmount(amount);
        billing.setStatus("Pending");
        billing.setBillingDate(new Date());
        
        receptionistDAO.createBilling(billing);
        response.sendRedirect("ReceptionistServlet?action=billings");
    }

    private void updateBillingStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long bid = Long.parseLong(request.getParameter("billingId"));
        String status = request.getParameter("status");
        String method = request.getParameter("paymentMethod");
        if (method == null) method = "N/A";
        
        receptionistDAO.recordPayment(bid, method, status);
        response.sendRedirect("ReceptionistServlet?action=billings&status=updated");
    }
}
