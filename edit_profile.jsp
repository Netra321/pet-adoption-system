<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="db_conn.jsp" %>
<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | Pet Adoption System</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            line-height: 1.6;
            color: #333;
            background-color: #f7f7f7;
        }
        
        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #4a6eb5;
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #555;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .btn {
            display: inline-block;
            background-color: #4a6eb5;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #3a5a9f;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            margin-left: 10px;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .form-actions {
            text-align: center;
            margin-top: 2rem;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <%
        String fullname = "";
        String email = "";
        String phone = "";
        String address = "";
     
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        
        try {
            // Fetch user data
            String sql = "SELECT username, fullname, email, phone, address FROM Users WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionUser);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                //username = rs.getString("username");
                fullname = rs.getString("fullname");
                email = rs.getString("email");
                phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                address = rs.getString("address") != null ? rs.getString("address") : "";
            }
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { }
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) { }
            try { if (conn != null) conn.close(); } catch (Exception e) { }
        }
    %>
    
    <div class="container">
        <h1>Edit Profile</h1>
        
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger">
                <%= errorMessage %>
            </div>
        <% } %>
        
        <form action="" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="<%= username %>" readonly>
                <small>Username cannot be changed</small>
            </div>
            
            <div class="form-group">
                <label for="fullname">Full Name</label>
                <input type="text" id="fullname" name="fullname" value="<%= fullname %>" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" value="<%= phone %>">
            </div>
            
            <div class="form-group">
                <label for="address">Address</label>
                <textarea id="address" name="address"><%= address %></textarea>
            </div>
            
            <div class="form-group">
                <label for="current_password">Current Password (required to make changes)</label>
                <input type="password" id="current_password" name="current_password" required>
            </div>
            
            <div class="form-group">
                <label for="new_password">New Password (leave blank if you don't want to change)</label>
                <input type="password" id="new_password" name="new_password">
            </div>
            
            <div class="form-group">
                <label for="confirm_password">Confirm New Password</label>
                <input type="password" id="confirm_password" name="confirm_password">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn">Save Changes</button>
                <a href="profile.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>