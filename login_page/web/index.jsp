<%-- 
    Document   : index
    Created on : Mar 29, 2025, 3:48:18 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pet Adoption - Login</title>
    <link rel="stylesheet" type="text/css" href="login_page_style.css">
    </head>
    <body>
         <div class="container">
        <form action="login_servlet" method="post">
            <div class="input_group">
                <input type="text" name="username" placeholder="Username" required>
            </div>
            <div class="input_group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <div class="error">
            <% 
                String errorMsg = request.getParameter("error");
                if(errorMsg != null) { 
                out.println(errorMsg);
                }
               
            %>
        </div>
            <button type="submit" class="btn">Login</button>
        </form>
        <div class="register-link">
            Don't have an account? <a href="register.jsp">Sign Up</a>
        </div>
    </div>
    </body>
</html>
