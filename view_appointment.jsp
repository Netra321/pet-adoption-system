<%-- 
    Document   : view_appointment
    Created on : Jun 5, 2025, 10:45:42 AM
    Author     : admin
--%>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<%
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Appointments</title>
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
            padding-top: 80px; /* Space for fixed navbar */
        }

        /* Navbar Styles */
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
        }

        h1 {
            text-align: center;
            color: #2c3e50;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        th {
            background-color: #2c3e50;
            color: white;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        tr:hover {
            background-color: #e8f4fd;
        }
        
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            background: #3498db;
            color: white;
            padding: 12px 20px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .main-content {
            margin-left: 20px;
            padding: 20px;
        }

        .action-btn {
            padding: 8px 12px;
            margin: 0 4px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            transition: all 0.3s ease;
        }

        .confirm-btn {
            background-color: #2ecc71; /* Green */
        }

        .confirm-btn:hover {
            background-color: #27ae60;
        }

        .cancel-btn {
            background-color: #e74c3c; /* Red */
        }

        .cancel-btn:hover {
            background-color: #c0392b;
        }

        .reschedule-btn {
            background-color: #f39c12; /* Orange */
        }

        .reschedule-btn:hover {
            background-color: #e67e22;
        }

        .status-pending {
            background-color: #f39c12;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .status-confirmed {
            background-color: #2ecc71;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .status-cancelled {
            background-color: #e74c3c;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .status-completed {
            background-color: #34495e;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .filter-section select, .filter-section input {
            padding: 8px;
            margin: 0 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .filter-btn {
            background-color: #3498db;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .no-data {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            padding: 40px;
        }
    </style>
</head>
<body>
    
    <div class="navbar">
        <img src="pet_image/logo_white.png" alt="Admin Logo">
        <nav>
            <a href="admin_dashboard.jsp">Dashboard</a>
            <a href="admin_view_page.jsp">Pets</a>
            <a href="view_adaption_request.jsp">Adoption Requests</a>
            <a href="view_appointments.jsp" style="background-color: #1abc9c;">Appointments</a>
            <a href="donation.html">Donations</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </nav>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1>Pet Appointments</h1>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form method="GET" action="">
                <label>Filter by Status:</label>
                <select name="status_filter">
                    <option value="">All Appointments</option>
                    <option value="Pending" <%= "Pending".equals(request.getParameter("status_filter")) ? "selected" : "" %>>Pending</option>
                    <option value="Confirmed" <%= "Confirmed".equals(request.getParameter("status_filter")) ? "selected" : "" %>>Confirmed</option>
                    <option value="Cancelled" <%= "Cancelled".equals(request.getParameter("status_filter")) ? "selected" : "" %>>Cancelled</option>
                    <option value="Completed" <%= "Completed".equals(request.getParameter("status_filter")) ? "selected" : "" %>>Completed</option>
                </select>
                
                <label>Date From:</label>
                <input type="date" name="date_from" value="<%= request.getParameter("date_from") != null ? request.getParameter("date_from") : "" %>">
                
                <label>Date To:</label>
                <input type="date" name="date_to" value="<%= request.getParameter("date_to") != null ? request.getParameter("date_to") : "" %>">
                
                <button type="submit" class="filter-btn">Filter</button>
                <a href="view_appointments.jsp" class="filter-btn" style="text-decoration: none; background-color: #95a5a6;">Clear</a>
            </form>
        </div>

<%
    Statement stmt = null;
    ResultSet rs = null;
    String statusFilter = request.getParameter("status_filter");
    String dateFrom = request.getParameter("date_from");
    String dateTo = request.getParameter("date_to");

    try {
        stmt = conn.createStatement();
        
        // Build SQL query with filters
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT a.appointment_id, a.user_id, a.pet_id, a.appointment_date, a.appointment_time, ");
        sqlBuilder.append("a.purpose, a.status, a.notes, a.created_date, ");
        sqlBuilder.append("u.username, u.email, u.phone, ");
        sqlBuilder.append("p.name as pet_name, p.breed ");
        sqlBuilder.append("FROM Appointments a ");
        sqlBuilder.append("LEFT JOIN Users u ON a.user_id = u.user_id ");
        sqlBuilder.append("LEFT JOIN Pets p ON a.pet_id = p.pet_id ");
        sqlBuilder.append("WHERE 1=1 ");
        
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sqlBuilder.append("AND a.status = '").append(statusFilter).append("' ");
        }
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sqlBuilder.append("AND a.appointment_date >= '").append(dateFrom).append("' ");
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sqlBuilder.append("AND a.appointment_date <= '").append(dateTo).append("' ");
        }
        
        sqlBuilder.append("ORDER BY a.appointment_date DESC, a.appointment_time DESC");
        
        String sql = sqlBuilder.toString();
        rs = stmt.executeQuery(sql);
%>

<table>
    <tr>
        <th>Appointment ID</th>
        <th>User Details</th>
        <th>Pet Details</th>
        <th>Date & Time</th>
        <th>Purpose</th>
        <th>Status</th>
        <th>Notes</th>
        <th>Actions</th>
    </tr>

    <%
        boolean hasAppointments = false;
        while (rs.next()) {
            hasAppointments = true;
            String status = rs.getString("status") == null ? "Pending" : rs.getString("status");
            String statusClass = "status-" + status.toLowerCase();
    %>
    <tr>
        <td><%= rs.getInt("appointment_id") %></td>
        <td>
            <strong><%= rs.getString("username") %></strong><br>
            <small>ID: <%= rs.getInt("user_id") %></small><br>
            <small><%= rs.getString("email") %></small><br>
            <small><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></small>
        </td>
        <td>
            <strong><%= rs.getString("pet_name") %></strong><br>
            <small>ID: <%= rs.getInt("pet_id") %></small><br>
            <small><%= rs.getString("breed") %></small>
        </td>
        <td>
            <strong><%= rs.getDate("appointment_date") %></strong><br>
            <small><%= rs.getTime("appointment_time") %></small>
        </td>
        <td><%= rs.getString("purpose") != null ? rs.getString("purpose") : "General Visit" %></td>
        <td>
            <span class="<%= statusClass %>"><%= status %></span>
        </td>
        <td><%= rs.getString("notes") != null ? rs.getString("notes") : "-" %></td>
        <td>
            <% if ("Pending".equals(status)) { %>
                <a href="confirm_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn confirm-btn">Confirm</a>
                <br><br>
                <a href="cancel_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn cancel-btn">Cancel</a>
            <% } else if ("Confirmed".equals(status)) { %>
                <a href="complete_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn confirm-btn">Complete</a>
                <br><br>
                <a href="reschedule_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn reschedule-btn">Reschedule</a>
                <br><br>
                <a href="cancel_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn cancel-btn">Cancel</a>
            <% } else if ("Cancelled".equals(status)) { %>
                <a href="reactivate_appointment.jsp?id=<%= rs.getInt("appointment_id") %>" class="action-btn confirm-btn">Reactivate</a>
            <% } else { %>
                <span style="color: #7f8c8d; font-style: italic;">No actions</span>
            <% } %>
        </td>
    </tr>
    <%
        }
        
        if (!hasAppointments) {
    %>
    <tr>
        <td colspan="8" class="no-data">No appointments found matching the selected criteria.</td>
    </tr>
    <%
        }
    %>

</table>

<%
    } catch(Exception e) {
        out.println("<div style='color: red; padding: 20px; background: #ffe6e6; border-radius: 4px; margin: 20px 0;'>");
        out.println("Error: " + e.getMessage());
        out.println("</div>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
    }
%>

<a class="back-btn" href="admin_dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>