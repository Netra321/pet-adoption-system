<%-- 
    Document   : manage_appointment
    Created on : 9 Jun 2025, 4:03:00 pm
    Author     : Ruchita Mahale
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@ include file="admin_side.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        session.setAttribute("redirectUrl", request.getRequestURI());
        response.sendRedirect("login.jsp");
        return;
    }

    // Check if user is admin
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean isAdmin = false;
    try {
        String query = "SELECT role FROM Users WHERE username = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, sessionUser);
        rs = ps.executeQuery();
        if (rs.next() && "Admin".equals(rs.getString("role"))) {
            isAdmin = true;
        }
    } catch (SQLException e) {
        out.println("<div class='alert' role='alert'><i class='fas fa-exclamation-circle'></i> Error checking user role: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
    }

    if (!isAdmin) {
        response.sendRedirect("home_page.html"); // Redirect non-admins to home page
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Appointments</title>
    <style>
        /* Existing CSS styles remain unchanged */
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
            --shadow-lg: 0 8px 16px rgba(0,0,0,0.15);
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
            max-width: 1200px;
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
            font-size: 0.9rem;
            margin-right: 0.5rem;
        }

        .approve-btn {
            background-color: var(--success-color);
            color: var(--white);
        }

        .approve-btn:hover {
            background-color: #43a047;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .reject-btn {
            background-color: var(--danger-color);
            color: var(--white);
        }

        .reject-btn:hover {
            background-color: #d32f2f;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .cancel-btn {
            background-color: var(--warning-color);
            color: var(--white);
        }

        .cancel-btn:hover {
            background-color: #f57c00;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .remarks-input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            display: none;
        }

        .alert {
            padding: 1.25rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border: 1px solid;
        }

        .alert-success {
            background: rgba(76, 175, 80, 0.1);
            color: var(--success-color);
            border-color: rgba(76, 175, 80, 0.2);
        }

        .alert-error {
            background: rgba(244, 67, 54, 0.1);
            color: var(--danger-color);
            border-color: rgba(244, 67, 54, 0.2);
        }

        form {
            display: inline;
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

            .action-btn {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }
        }

        @media (max-width: 480px) {
            table {
                font-size: 0.8rem;
            }

            .action-btn {
                display: block;
                margin-bottom: 0.5rem;
                margin-right: 0;
            }

            .remarks-input {
                font-size: 0.8rem;
            }
        }
    </style>
    <script>
        function toggleRemarks(appointmentId, action) {
            var remarksInput = document.getElementById('remarks-' + appointmentId + '-' + action);
            remarksInput.style.display = remarksInput.style.display === 'none' ? 'block' : 'none';
            // If the remarks input is visible, focus on it
            if (remarksInput.style.display === 'block') {
                remarksInput.focus();
            }
        }

        function submitAction(appointmentId, action, remarks) {
            // Map action to the corresponding JSP file
            var targetPage = '';
            if (action === 'approve') {
                targetPage = 'accept_appointment.jsp';
            } else if (action === 'reject') {
                targetPage = 'reject_appointment.jsp';
            } else if (action === 'cancel') {
                targetPage = 'cancel_appointment.jsp';
            }

            // Create a form dynamically
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = targetPage;

            // Add appointment_id as 'id' to match the parameter expected by the JSP files
            var idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = appointmentId;
            form.appendChild(idInput);

            // Add remarks if provided
            if (remarks !== '') {
                var remarksInput = document.createElement('input');
                remarksInput.type = 'hidden';
                remarksInput.name = 'remarks';
                remarksInput.value = remarks;
                form.appendChild(remarksInput);
            }

            // Append the form to the body and submit it
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Manage Appointments</h1>
        </div>

        <%
            try {
                String sql = "SELECT a.appointment_id, a.user_id, a.pet_id, a.appointment_date, a.appointment_time, a.meeting_number, a.status, a.remarks, u.fullname AS user_name, p.name AS pet_name " +
                             "FROM Appointments a " +
                             "JOIN Users u ON a.user_id = u.user_id " +
                             "JOIN Pets p ON a.pet_id = p.pet_id " +
                             "ORDER BY a.appointment_date DESC";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
        %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Pet</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Meeting No.</th>
                    <th>Status</th>
                    <th>Remarks</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                while (rs.next()) {
                    int appointmentId = rs.getInt("appointment_id");
                    String userName = rs.getString("user_name") != null ? rs.getString("user_name") : "N/A";
                    String petName = rs.getString("pet_name") != null ? rs.getString("pet_name") : "N/A";
                    String appointmentDate = rs.getString("appointment_date") != null ? rs.getString("appointment_date") : "N/A";
                    String appointmentTime = rs.getString("appointment_time") != null ? rs.getString("appointment_time") : "N/A";
                    int meetingNumber = rs.getInt("meeting_number");
                    String status = rs.getString("status") != null ? rs.getString("status") : "N/A";
                    String remarks = rs.getString("remarks") != null ? rs.getString("remarks") : "";
            %>
                <tr>
                    <td><%= appointmentId %></td>
                    <td><%= userName %></td>
                    <td><%= petName %></td>
                    <td><%= appointmentDate %></td>
                    <td><%= appointmentTime %></td>
                    <td><%= meetingNumber %></td>
                    <td><%= status %></td>
                    <td><%= remarks %></td>
                    <td>
                        <% if ("Pending".equals(status)) { %>
                            <button class="action-btn approve-btn" onclick="submitAction('<%= appointmentId %>', 'approve', '')" aria-label="Approve appointment <%= appointmentId %>">
                                <i class="fas fa-check"></i> Approve
                            </button>
                            <button class="action-btn reject-btn" onclick="toggleRemarks('<%= appointmentId %>', 'reject')" aria-label="Reject appointment <%= appointmentId %>">
                                <i class="fas fa-times"></i> Reject
                            </button>
                            <button class="action-btn cancel-btn" onclick="toggleRemarks('<%= appointmentId %>', 'cancel')" aria-label="Cancel appointment <%= appointmentId %>">
                                <i class="fas fa-ban"></i> Cancel
                            </button>
                            <textarea id="remarks-<%= appointmentId %>-reject" class="remarks-input" name="remarks" placeholder="Enter reason for rejection..." onchange="if(this.value.trim() !== '') submitAction('<%= appointmentId %>', 'reject', this.value)"></textarea>
                            <textarea id="remarks-<%= appointmentId %>-cancel" class="remarks-input" name="remarks" placeholder="Enter reason for cancellation..." onchange="if(this.value.trim() !== '') submitAction('<%= appointmentId %>', 'cancel', this.value)"></textarea>
                        <% } %>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <%
            } catch (SQLException e) {
                out.println("<div class='alert alert-error' role='alert'>");
                out.println("<i class='fas fa-exclamation-circle'></i> Error fetching appointments: " + e.getMessage());
                out.println("</div>");
            } catch (Exception e) {
                out.println("<div class='alert alert-error' role='alert'>");
                out.println("<i class='fas fa-exclamation-circle'></i> Error : " + e.getMessage());
                out.println("</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>