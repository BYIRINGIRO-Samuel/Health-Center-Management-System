package com.pms.controller;

import com.pms.dao.UserDAO;
import com.pms.dao.UserDAOImpl;
import com.pms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl(); // Create JPA/Hibernate DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.authenticateUser(email, password);
            if (user != null) {
                // Attach the user object to Session
                request.getSession().setAttribute("user", user);

                // Then route to proper dashboard
                directToDashboard(user.getRole(), response);
            } else {
                request.setAttribute("error", "Invalid credentials. Please attempt sign in again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }

    private void directToDashboard(String role, HttpServletResponse response) throws IOException {
        switch (role) {
            case "Admin":
                response.sendRedirect("admin-dashboard.jsp");
                break;
            case "Doctor":
                response.sendRedirect("doctor-dashboard.jsp");
                break;
            case "Receptionist":
                response.sendRedirect("receptionist-dashboard.jsp");
                break;
            case "Patient":
                response.sendRedirect("PatientServlet?action=dashboard");
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }
}
