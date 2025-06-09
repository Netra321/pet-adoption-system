<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@ include file="navigation_page.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Adoption Request Status</title>
    <style>
        .container {
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        form {
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Adoption Request Status</h1>

        <%
            String sql = "SELECT ar.request_date, ar.status, p.name AS name, p.breed, p.species, ar.reason_for_adoption AS message, ar.pet_id " +
                         "FROM AdoptionRequests ar " +
                         "JOIN Pets p ON ar.pet_id = p.pet_id " +
                         "JOIN Users u ON ar.user_id = u.user_id " +
                         "WHERE u.username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, sessionUser);
                ResultSet rs = pstmt.executeQuery();
        %>

        <table>
            <thead>
            <tr>
                <th>Request Date</th>
                <th>Pet Name</th>
                <th>Species</th>
                <th>Breed</th>
                <th>Reason</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("request_date") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("species") %></td>
                <td><%= rs.getString("breed") %></td>
                <td><%= rs.getString("message") %></td>
                <td>
                    <%= rs.getString("status") %>
                    <%
                        if ("Accepted".equals(rs.getString("status"))) {
                    %>
                        <form action="book_appointment.jsp" method="get">
                            <input type="hidden" name="pet_id" value="<%= rs.getInt("pet_id") %>">
                            <button type="submit">Book Appointment</button>
                        </form>
                    <%
                        }
                    %>
                </td>
            </tr>
            <%
                }
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
