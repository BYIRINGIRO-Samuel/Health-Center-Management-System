<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Patient".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .dashboard-container { text-align: center; padding: 4rem; background: var(--white); border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); z-index: 1;}
        h1 { color: var(--teal-primary); margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h1>Welcome to Patient dashboard</h1>
        <p>Hello, <%= user.getFullName() %>!</p>
        <br>
        <a href="LogoutServlet" class="btn-primary" style="text-decoration: none; display: inline-block;">Logout</a>
    </div>
</body>
</html>
