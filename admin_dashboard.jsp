<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<%@include file="admin_side.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        session.setAttribute("redirectUrl", request.getRequestURI());
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    int totalUsers = 0;
    int totalPets = 0;
    int pendingAdoptions = 0;

    try {
        String userQuery = "SELECT COUNT(*) FROM Users";
        Statement userStmt = conn.createStatement();
        ResultSet userRs = userStmt.executeQuery(userQuery);
        if (userRs.next()) {
            totalUsers = userRs.getInt(1);
        }
        userRs.close();
        userStmt.close();

        String petQuery = "SELECT COUNT(*) FROM Pets";
        Statement petStmt = conn.createStatement();
        ResultSet petRs = petStmt.executeQuery(petQuery);
        if (petRs.next()) {
            totalPets = petRs.getInt(1);
        }
        petRs.close();
        petStmt.close();

        String adoptionQuery = "SELECT COUNT(*) FROM AdoptionRequests where status='Pending'";
        Statement adoptionStmt = conn.createStatement();
        ResultSet adoptionRs = adoptionStmt.executeQuery(adoptionQuery);
        if (adoptionRs.next()) {
            pendingAdoptions = adoptionRs.getInt(1);
        }
        adoptionRs.close();
        adoptionStmt.close();

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close connection in finally block (already done in db_conn.jsp but good to have here too)
        //if (conn != null) {
        //    try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        //}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
/*        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5ff;
            color: #333;
            padding-top: 80px;  Space for fixed navbar 
        }

         Navbar Styles 
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #2c3e50;
            color: white;
            padding: 15px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .navbar img {
            height: 50px;
            filter: brightness(0) invert(1);
        }

        .navbar nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar a {
            text-decoration: none;
            color: white;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .navbar a:hover {
            background-color: #1abc9c;
        }

        .logout-btn {
            background-color: #e74c3c;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }*/

        h1 {
            text-align: center;
            color: #2c3e50;
        }
        
        .header {
            color: black;
            padding: 20px;
            text-align: center;
        }
/*        .sidebar {
            width: 200px;
            background: #2c3e50;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            padding-top: 100px;
        }
        .sidebar a {
            display: block;
            color: white;
            padding: 12px;
            text-decoration: none;
        }
        .sidebar a:hover {
            background: #1abc9c;
        }*/
        .main {
            /*margin-left: 100px;*/
            /*margin-right: 100px;*/
            padding: 20px;
        }
        .card {
            background: white;
            align-content:center;
            padding: 20px 60px;
            margin-bottom: 20px ;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        h2 {
            color: #2c3e50;
        }
    </style>
</head>
<body>

<!---->
<!--    <div class="navbar">
        <img src="pet_image/logo_white.png" alt="Admin Logo">
        <nav>
            <a href="admin_dashboard.jsp" style="background-color: #1abc9c;">Dashboard</a>
            <a href="manage_users.jsp">Users</a>
            <a href="admin_view_page.jsp">Pets</a>
            <a href="view_adaption_request.jsp">Adoption Requests</a>
            <a href="donation.html">Donations</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </nav>
    </div>-->
<div class="header">
    <h1>Pet To Home - Admin Dashboard</h1>
</div>

<!--<div class="sidebar">
    <a href="manage_users.jsp">Manage Users</a>
    <a href="admin_view_page.jsp">Manage Pets</a>
    <a href="view_adaption_request.jsp">Adoption Requests</a>
    <a href="donation.html">Donations</a>
    <a href="feedback.html">Feedback</a>
    <a href="logout.jsp">Logout</a>
</div>-->

<div class="main">
    <div class="card">
        <h2>Welcome, Admin!</h2>
        <p>Select a section from the sidebar to manage the system.</p>
    </div>

    <div class="card">
        <h2>Quick Stats</h2>
        <ul>
            <li>Total Users       : <%= totalUsers %></li>
            <li>Total Pets        : <%= totalPets %></li>
            <li>Pending Adoptions : <%= pendingAdoptions %></li>
            <li>Total Donations   : 0</li>
        </ul>
    </div>
</div>

</body>
</html>
