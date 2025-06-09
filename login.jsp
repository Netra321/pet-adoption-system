<%-- 
    Document   : login
    Created on : Apr 18, 2025, 4:14:20 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Paws & Claws - Pet Adoption Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="login_style.css">
</head>
<body>
    <div class="container">
        <div class="logo">
            <img src="pet_image/logo_white.png" alt="Pet To Home Logo">
        </div>
        <h1>Welcome to Pet To Home</h1>
        <form action="login_servlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required placeholder="Enter your username">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>
<!--            <div class="remember-me">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember me</label>
            </div>-->
            <div class="error">
            <%
                String errorMsg = (String) request.getAttribute("error");
                if (errorMsg != null) {
                    out.println(errorMsg);
                }
            %>
            </div>
            
            <button type="submit">Login</button>
            <div class="links">
                <p><a href="/forgot-password">Forgot Password?</a></p>
                <p>Don't have an account? <a href="register.jsp">Sign Up</a></p>
            </div>
        </form>
    </div>
</body>
</html>