<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@ include file="navigation_page.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        session.setAttribute("redirectUrl", request.getRequestURI());
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adoption Request Status</title>
    <style>
        :root {
            --primary-color: #1a4c96;
            --primary-hover: #2a5ca8;
            --primary-gradient: linear-gradient(135deg, #1a4c96 0%, #2a5ca8 100%);
            --success-color: #4CAF50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --vet-color: #ab47bc;
            --light-bg: #f0f5ff;
            --white: #ffffff;
            --text-primary: #333;
            --text-secondary: #666;
            --border-color: #e2e8f0;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 8px rgba(0,0,0,0.12);
            --border-radius: 12px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            color: var(--text-primary);
            line-height: 1.7;
            padding: 2.5rem;
            min-height: 100vh;
            font-size: 16px;
        }

        .container {
            max-width: 900px;
            margin: 2rem auto;
            background-color: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        h1 {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.2rem;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }

        th, td {
            padding: 1rem 1.25rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background-color: #f8fafc;
            color: var(--text-primary);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        td {
            color: var(--text-secondary);
        }

        tr:hover {
            background-color: rgba(26, 76, 150, 0.05);
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            transition: var(--transition);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            background-color: var(--primary-color);
            color: var(--white);
            font-size: 0.9rem;
        }

        .action-btn:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        form {
            display: inline;
        }

        .alert {
            padding: 1.25rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: rgba(244, 67, 54, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(244, 67, 54, 0.2);
        }

        @media (max-width: 768px) {
            body {
                padding: 1.5rem;
            }

            .container {
                margin: 1rem;
                padding: 1.5rem;
            }

            th, td {
                padding: 0.75rem;
                font-size: 0.85rem;
            }

            h1 {
                font-size: 1.8rem;
            }
        }

        @media (max-width: 480px) {
            table {
                font-size: 0.8rem;
            }

            .action-btn {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Adoption Request Status</h1>
        </div>

        <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                String sql = "SELECT ar.request_date, ar.status, p.name AS name, p.breed, p.species, ar.reason_for_adoption AS message, ar.pet_id " +
                             "FROM AdoptionRequests ar " +
                             "JOIN Pets p ON ar.pet_id = p.pet_id " +
                             "JOIN Users u ON ar.user_id = u.user_id " +
                             "WHERE u.username = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, sessionUser);
                rs = pstmt.executeQuery();
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
                    String requestDate = rs.getString("request_date") != null ? rs.getString("request_date") : "N/A";
                    String petName = rs.getString("name") != null ? rs.getString("name") : "N/A";
                    String species = rs.getString("species") != null ? rs.getString("species") : "N/A";
                    String breed = rs.getString("breed") != null ? rs.getString("breed") : "N/A";
                    String message = rs.getString("message") != null ? rs.getString("message") : "N/A";
                    String status = rs.getString("status") != null ? rs.getString("status") : "N/A";
            %>
                <tr>
                    <td><%= requestDate %></td>
                    <td><%= petName %></td>
                    <td><%= species %></td>
                    <td><%= breed %></td>
                    <td><%= message %></td>
                    <td>
                        <%= status %>
                        <%
                            if ("Accepted".equalsIgnoreCase(status)) {
                        %>
                            <form action="book_appointment.jsp" method="get">
                                <input type="hidden" name="pet_id" value="<%= rs.getInt("pet_id") %>">
                                <button type="submit" class="action-btn" aria-label="Book appointment for pet <%= petName %>">
                                    <i class="fas fa-calendar-plus"></i> Book Appointment
                                </button>
                            </form>
                        <%
                            }
                        %>
                        <form action="appointments.jsp" method="get">
                            <input type="hidden" name="pet_id" value="<%= rs.getInt("pet_id") %>">
                            <button type="submit" class="action-btn" aria-label="View appointments for pet <%= petName %>">
                                <i class="fas fa-calendar-check"></i> View Appointments
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <%
            } catch (SQLException e) {
                out.println("<div class='alert' role='alert'>");
                out.println("<i class='fas fa-exclamation-circle'></i> Error fetching adoption requests: " + e.getMessage());
                out.println("</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>