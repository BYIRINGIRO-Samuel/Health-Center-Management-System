package com.pms.controller;

import com.pms.dao.AdminDAO;
import com.pms.dao.AdminDAOImpl;
import com.pms.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"Admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "manageUsers":
                manageUsers(request, response);
                break;
            case "managePatients":
                managePatients(request, response);
                break;
            case "manageDoctors":
                manageDoctors(request, response);
                break;
            case "payments":
                showPayments(request, response);
                break;
            case "reports":
                showReports(request, response);
                break;
            case "logs":
                showLogs(request, response);
                break;
            case "listDepartments":
                showDepartments(request, response);
                break;
            case "deleteDept":
                adminDAO.deleteDepartment(Long.parseLong(request.getParameter("id")));
                response.sendRedirect("AdminServlet?action=listDepartments");
                break;
            case "notifications":
                List<NotificationItem> notifs = new java.util.ArrayList<>();
                java.util.Date lastCheck = user.getLastNotifCheck();
                if (lastCheck == null) lastCheck = new java.util.Date(0);

                for(Object[] log : adminDAO.getRecentActivity()) {
                    String logMessage = log[1] + " " + log[0];
                    java.util.Date d = null;
                    if (log[2] instanceof java.util.Date) {
                        d = (java.util.Date) log[2];
                    } else if (log[2] instanceof java.time.OffsetDateTime) {
                        d = java.util.Date.from(((java.time.OffsetDateTime) log[2]).toInstant());
                    } else if (log[2] instanceof java.time.LocalDateTime) {
                        d = java.util.Date.from(((java.time.LocalDateTime) log[2]).atZone(java.time.ZoneId.systemDefault()).toInstant());
                    }
                    boolean unread = d != null && d.after(lastCheck);
                    notifs.add(new NotificationItem("system", "System Activity", logMessage, d, unread, "System", "#f3e8ff", "#7e22ce"));
                }
                request.setAttribute("notificationsList", notifs);
                request.getRequestDispatcher("notifications.jsp").forward(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    private void showDepartments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("depts", adminDAO.getAllDepartments());
        request.getRequestDispatcher("manage-departments.jsp").forward(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalPatients", adminDAO.getTotalPatients());
        request.setAttribute("totalDoctors", adminDAO.getTotalDoctors());
        request.setAttribute("totalAppointments", adminDAO.getTotalAppointments());
        request.setAttribute("totalRevenue", adminDAO.getTotalRevenue());
        request.setAttribute("recentActivity", adminDAO.getRecentActivity());
        
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    private void manageUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", adminDAO.getAllUsers());
        request.getRequestDispatcher("manage-users.jsp").forward(request, response);
    }

    private void managePatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", adminDAO.getAllPatients());
        request.getRequestDispatcher("manage-patients.jsp").forward(request, response);
    }

    private void manageDoctors(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", adminDAO.getAllDoctors());
        request.getRequestDispatcher("manage-doctors.jsp").forward(request, response);
    }

    private void showPayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("billings", adminDAO.getAllBillings());
        request.setAttribute("totalRevenue", adminDAO.getTotalRevenue());
        request.getRequestDispatcher("payments.jsp").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalPatients", adminDAO.getTotalPatients());
        request.setAttribute("totalRevenue", adminDAO.getTotalRevenue());
        request.setAttribute("growthData", adminDAO.getMonthlyPatientGrowth());
        request.setAttribute("revenueByDept", adminDAO.getRevenueByDepartment());
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }

    private void showLogs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("logs", adminDAO.getRecentActivity());
        request.getRequestDispatcher("system-logs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("addDept".equals(action)) {
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            String head = request.getParameter("headOfDept");
            com.pms.model.Department dept = new com.pms.model.Department(name, desc, head);
            adminDAO.addDepartment(dept);
            response.sendRedirect("AdminServlet?action=listDepartments");
        } else if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            if (fullName != null) currentUser.setFullName(fullName);
            if (email != null) currentUser.setEmail(email);
            if (phone != null) currentUser.setPhone(phone);
            
            new com.pms.dao.UserDAOImpl().updateUser(currentUser);
            session.setAttribute("user", currentUser);
            response.sendRedirect("settings.jsp?status=success");
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!currentUser.getPassword().equals(currentPassword)) {
                response.sendRedirect("settings.jsp?error=Current password incorrect");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("settings.jsp?error=New passwords do not match");
                return;
            }

            currentUser.setPassword(newPassword);
            new com.pms.dao.UserDAOImpl().updateUser(currentUser);
            session.setAttribute("user", currentUser);
            response.sendRedirect("settings.jsp?status=success");
        }
    }
}
