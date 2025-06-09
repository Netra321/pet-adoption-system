<%-- 
    Document   : register
    Created on : Apr 18, 2025, 3:13:23 PM
    Author     : admin
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Paws & Claws - Register</title>
    <link rel="stylesheet" href="login_style.css">
</head>
<body>
<div class="container">
    <h1>Create Your Account</h1>

    <%-- Show error or success message --%>
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
        <p class="error"><%= error %></p>
    <% } else if (success != null) { %>
        <p class="success"><%= success %></p>
    <% } %>

    <form action="register_servlet" method="post">
        <div class="form-group">
            <label for="fullname">Full Name</label>
            <input type="text" id="fullname" name="fullname" required 
                   value="<%= request.getParameter("fullname") != null ? request.getParameter("fullname") : "" %>">
        </div>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required 
                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
        </div>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required 
                   value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <button type="submit">Sign Up</button>
        <div class="links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </form>
</div>
</body>
</html>