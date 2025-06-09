<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@include file = "admin_side.html" %>
<%@include file="db_conn.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Admin Profile</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5ff;
            color: #333;
            padding-top: 80px;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            padding: 30px;
        }

        .page-title {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
            font-size: 28px;
            position: relative;
        }

        .page-title:after {
            content: "";
            position: absolute;
            width: 80px;
            height: 3px;
            background-color: #3498db;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            color: #333;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #3498db;
            outline: none;
        }

        .required {
            color: #e74c3c;
        }

        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
        }

        .save-btn, .cancel-btn {
            padding: 12px 25px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .save-btn {
            background-color: #27ae60;
            color: white;
        }

        .save-btn:hover {
            background-color: #219653;
        }

        .cancel-btn {
            background-color: #7f8c8d;
            color: white;
        }

        .cancel-btn:hover {
            background-color: #636e72;
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .readonly {
            background-color: #f8f9fa;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h1 class="page-title">Edit Admin Profile</h1>

<%
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        session.setAttribute("redirectUrl", request.getRequestURI());
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        try {
            String updateSql = "UPDATE Users SET fullname = ?, email = ?, phone = ? WHERE user_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, fullname);
            updateStmt.setString(2, email);
            updateStmt.setString(3, phone);
            updateStmt.setInt(4, userId);
            
            int result = updateStmt.executeUpdate();
            if (result > 0) {
                request.setAttribute("message", "Profile updated successfully!");
                request.setAttribute("messageType", "alert-success");
            } else {
                request.setAttribute("message", "Failed to update profile.");
                request.setAttribute("messageType", "alert-error");
            }
            updateStmt.close();
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "alert-error");
        }
    }

    // Get current user data
    String currentUsername = "";
    String currentFullname = "";
    String currentEmail = "";
    String currentPhone = "";

    try {
        String sql = "SELECT username, fullname, email, phone FROM Users WHERE user_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            currentUsername = rs.getString("username");
            currentFullname = rs.getString("fullname");
            currentEmail = rs.getString("email");
            currentPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        request.setAttribute("message", "Error loading data: " + e.getMessage());
        request.setAttribute("messageType", "alert-error");
    }
    conn.close();
%>

            <%
                String message = (String) request.getAttribute("message");
                String messageType = (String) request.getAttribute("messageType");
                if (message != null) {
            %>
                <div class="alert <%= messageType %>">
                    <%= message %>
                </div>
            <%
                }
            %>

            <form method="POST">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" value="<%= currentUsername %>" readonly class="readonly">
                    </div>

                    <div class="form-group">
                        <label>Full Name <span class="required">*</span></label>
                        <input type="text" name="fullname" value="<%= currentFullname %>" required>
                    </div>

                    <div class="form-group">
                        <label>Email <span class="required">*</span></label>
                        <input type="email" name="email" value="<%= currentEmail %>" required>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone" value="<%= currentPhone %>">
                    </div>
                </div>
                
                <div class="form-buttons">
                    <button type="button" class="cancel-btn" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="save-btn">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>