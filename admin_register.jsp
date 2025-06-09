<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Registration - Paws & Claws</title>
    <link rel="stylesheet" href="login_style.css">
</head>
<body>
<div class="container">
    <h1>Admin Registration</h1>

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

    <form action="admin_register_servlet" method="post">
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

        <button type="submit">Register Admin</button>
        <div class="links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
            <p><a href="register.jsp">User Registration</a></p>
        </div>
    </form>
</div>
</body>
</html>