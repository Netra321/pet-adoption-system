<%-- 
    Document   : appointments
    Created on : 10 Jun 2025, 1:08:37 pm
    Author     : RUSHANG MAHALE
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%--<%@ include file="navigation_page.html" %>--%>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String petIdParam = request.getParameter("pet_id");
    int petId = petIdParam != null ? Integer.parseInt(petIdParam) : 0;
%>

<html>
<head>
    <title>Appointment Details</title>
    <style>
        body { font-family: sans-serif; background: #f0f5ff; padding: 2rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 2rem; background: white; }
        th, td { padding: 1rem; border: 1px solid #ccc; text-align: left; }
        th { background: #1a4c96; color: white; }
        tr:hover { background: #f2f2f2; }
        h1 { color: #1a4c96; }
    </style>
</head>
<body>
    <h1>Appointment Details</h1>
<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        String sql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, a.meeting_number, a.status, a.remarks, p.name AS pet_name " +
                     "FROM Appointments a " +
                     "JOIN Pets p ON a.pet_id = p.pet_id " +
                     "JOIN Users u ON a.user_id = u.user_id " +
                     "WHERE a.pet_id = ? AND u.username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, petId);
        pstmt.setString(2, sessionUser);
        rs = pstmt.executeQuery();

        if (!rs.isBeforeFirst()) {
            out.println("<p>No appointments found for this pet.</p>");
        } else {
%>
    <table>
        <thead>
            <tr>
                <th>Appointment ID</th>
                <th>Pet Name</th>
                <th>Date</th>
                <th>Time</th>
                <th>Meeting #</th>
                <th>Status</th>
                <th>Remarks</th>
            </tr>
        </thead>
        <tbody>
        <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getInt("appointment_id") %></td>
                <td><%= rs.getString("pet_name") %></td>
                <td><%= rs.getDate("appointment_date") %></td>
                <td><%= rs.getTime("appointment_time") %></td>
                <td><%= rs.getInt("meeting_number") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getString("remarks") != null ? rs.getString("remarks") : "N/A" %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
    }
%>
</body>
</html>