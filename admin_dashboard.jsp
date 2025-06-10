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
    int availablePets = 0;
    int adoptedPets = 0;
    int pendingAdoptions = 0;
    int totalAdopters = 0;
    int totalVets = 0;

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

        String availablePetQuery = "SELECT COUNT(*) FROM Pets WHERE status='Available'";
        Statement availableStmt = conn.createStatement();
        ResultSet availableRs = availableStmt.executeQuery(availablePetQuery);
        if (availableRs.next()) {
            availablePets = availableRs.getInt(1);
        }
        availableRs.close();
        availableStmt.close();

        String adoptedPetQuery = "SELECT COUNT(*) FROM Pets WHERE status='Adopted'";
        Statement adoptedStmt = conn.createStatement();
        ResultSet adoptedRs = adoptedStmt.executeQuery(adoptedPetQuery);
        if (adoptedRs.next()) {
            adoptedPets = adoptedRs.getInt(1);
        }
        adoptedRs.close();
        adoptedStmt.close();

        String adoptionQuery = "SELECT COUNT(*) FROM AdoptionRequests where status='Pending'";
        Statement adoptionStmt = conn.createStatement();
        ResultSet adoptionRs = adoptionStmt.executeQuery(adoptionQuery);
        if (adoptionRs.next()) {
            pendingAdoptions = adoptionRs.getInt(1);
        }
        adoptionRs.close();
        adoptionStmt.close();

        String adopterQuery = "SELECT COUNT(*) FROM Adopters";
        Statement adopterStmt = conn.createStatement();
        ResultSet adopterRs = adopterStmt.executeQuery(adopterQuery);
        if (adopterRs.next()) {
            totalAdopters = adopterRs.getInt(1);
        }
        adopterRs.close();
        adopterStmt.close();

        String vetQuery = "SELECT COUNT(*) FROM Veterinarians";
        Statement vetStmt = conn.createStatement();
        ResultSet vetRs = vetStmt.executeQuery(vetQuery);
        if (vetRs.next()) {
            totalVets = vetRs.getInt(1);
        }
        vetRs.close();
        vetStmt.close();

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
        h1 {
            text-align: center;
            color: #2c3e50;
        }
        
        .header {
            color: black;
            padding: 20px;
            text-align: center;
        }

        .main {
            padding: 20px;
        }

        .card {
            background: white;
            align-content: center;
            padding: 20px 60px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 8px;
        }

        h2 {
            color: #2c3e50;
        }

        /* Stats container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        /* Individual stat boxes */
        .stat-box {
            background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
            color: #2c3e50;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 2px solid #e3f2fd;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-color: #bbdefb;
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
            opacity: 0.8;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin: 10px 0;
            color: #1976d2;
        }

        .stat-label {
            font-size: 1.1em;
            font-weight: 500;
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Pet To Home - Admin Dashboard</h1>
</div>

<div class="main">
    <div class="card">
        <h2>Welcome, Admin!</h2>
        <p>Select a section from the sidebar to manage the system.</p>
    </div>

    <div class="stats-container">
        <div class="stat-box users">
            <div class="stat-icon">👥</div>
            <div class="stat-number"><%= totalUsers %></div>
            <div class="stat-label">Total Users</div>
        </div>

        <div class="stat-box pets">
            <div class="stat-icon">🐾</div>
            <div class="stat-number"><%= availablePets %></div>
            <div class="stat-label">Available Pets</div>
        </div>

        <div class="stat-box adopted-pets">
            <div class="stat-icon">🏡</div>
            <div class="stat-number"><%= adoptedPets %></div>
            <div class="stat-label">Adopted Pets</div>
        </div>

        <div class="stat-box adoptions">
            <div class="stat-icon">❤️</div>
            <div class="stat-number"><%= pendingAdoptions %></div>
            <div class="stat-label">Pending Adoptions</div>
        </div>

        <div class="stat-box adopters">
            <div class="stat-icon">👨‍👩‍👧‍👦</div>
            <div class="stat-number"><%= totalAdopters %></div>
            <div class="stat-label">Total Adopters</div>
        </div>

        <div class="stat-box vets">
            <div class="stat-icon">🩺</div>
            <div class="stat-number"><%= totalVets %></div>
            <div class="stat-label">Total Vets</div>
        </div>
    </div>
</div>

</body>
</html>