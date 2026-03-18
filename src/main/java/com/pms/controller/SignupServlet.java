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

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl(); // Instantiating our DAO logic
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        User user = new User(fullName, email, password, role);

        try {
            // Save through JPA
            userDAO.registerUser(user);
            
            // Set user on session to maintain login
            request.getSession().setAttribute("user", user);

            // Redirect automatically upon signup
            directToDashboard(role, response);

        } catch (Exception e) {
            // Usually handle duplicate emails or validation here.
            request.setAttribute("error", "Signup failed: Email might already be taken!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
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
                response.sendRedirect("patient-dashboard.jsp");
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }
}
