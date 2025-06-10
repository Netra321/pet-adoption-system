<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings</title>
    <style>
        :root {
            --primary-color: #1a4c96;
            --primary-hover: #2a5ca8;
            --primary-gradient: linear-gradient(135deg, #1a4c96 0%, #2a5ca8 100%);
            --success-color: #4CAF50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --some-color: #1a4c96;
            --light-bg: #f0f5ff;
            --white: #ffffff;
            --text-primary: #333;
            --text-secondary: #666;
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
            display: flex;
            margin: 2rem auto;
            max-width: 1400px;
            gap: 2rem;
        }

        .sidebar {
            width: 300px;
            background-color: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            position: sticky;
            top: 120px;
            height: fit-content;
            transition: var(--transition);
        }

        .sidebar h4 {
            margin: 1.5rem 0 0.5rem;
            color: #2c3e50;
            font-size: 1.2rem;
            font-weight: 600;
            border-bottom: 2px solid var(--some-color);
            padding-bottom: 0.5rem;
        }

        .sidebar a {
            color: #3498db;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
            transition: var(--transition);
        }

        .sidebar a:hover {
            color: #2c3e50;
            transform: translateX(5px);
        }

        .main-content {
            flex: 1;
            padding: 1rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3.5rem;
            padding: 2rem;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
        }

        .header h1 {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section {
            margin-bottom: 3.5rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            padding: 1rem 0;
            border-bottom: 3px solid var(--some-color);
        }

        .section-header h2 {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .user-card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            padding: 2rem;
/*            border-top: 4px solid var(--some-color);*/
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .user-content {
            display: flex;
            flex-direction: column;
        }

        .card-header {
            position: relative;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .role-badge {
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: rgba(171, 71, 188, 0.1);
            color: var(--some-color);
            border: 1px solid rgba(171, 71, 188, 0.2);
        }

        .user-info h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
            text-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }

        .user-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            font-size: 1rem;
        }

        .detail-item i {
            width: 20px;
            color: var(--primary-color);
            flex-shrink: 0;
            margin-top: 0.2rem;
        }

        .detail-item .label {
            font-weight: 600;
            color: var(--text-primary);
            min-width: 140px;
            text-align: right;
        }

        .detail-item .value {
            color: var(--text-secondary);
            flex: 1;
            word-break: break-word;
        }

        .card-image-container {
            display: flex;
            justify-content: center;
            margin: 1.5rem 0;
        }

        .card-image {
            width: 100%;
            max-width: 350px;
            height: auto;
            object-fit: cover;
            border: 3px solid var(--some-color);
            border-radius: 10px;
            transition: var(--transition);
        }

        .card-image:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-sm);
        }

        .card-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .action-btn {
            height: 50px;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            transition: var(--transition);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            background-color: #3498db;
            color: var(--white);
            font-size: 1rem;
        }

        .action-btn:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            box-shadow: var(--shadow-sm);
        }

        .empty-state {
            text-align: center;
            padding: 4rem;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            color: var(--some-color);
        }

        .empty-state h3 {
            font-size: 1.8rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
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

        @media (max-width: 1024px) {
            .user-details {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 1.5rem;
            }

            .container {
                flex-direction: column;
                margin: 1rem;
            }

            .sidebar {
                width: 100%;
                position: static;
                top: 0;
            }

            .header h1 {
                font-size: 2.2rem;
            }

            .user-card {
                padding: 1.5rem;
            }

            .detail-item .label {
                min-width: 120px;
                text-align: left;
            }
        }

        @media (max-width: 480px) {
            .user-info h2 {
                font-size: 1.5rem;
            }

            .detail-item {
                font-size: 0.95rem;
            }

            .action-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Navigation -->
        <div class="sidebar" aria-label="Admin settings navigation">
            <h4>Settings</h4>
            <a href="admin_register.jsp" aria-label="Add admin">
                <i class="fas fa-user-plus"></i> Add Admin
            </a>
            <a href="edit_admin.jsp" aria-label="Edit profile">
                <i class="fas fa-edit"></i> Edit Profile
            </a>
            <a href="logout.jsp" aria-label="Log out">
                <i class="fas fa-sign-out-alt"></i> Log Out
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <%
                // Assume user_id is stored in session after login
                Integer userId = (Integer) session.getAttribute("user_id");
                if (userId == null) {
                    out.println("<div class='alert' role='alert'>");
                    out.println("<i class='fas fa-exclamation-circle'></i>");
                    out.println("Please log in to view your profile.");
                    out.println("</div>");
                } else {
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

                    try {
                        String query = "SELECT user_id, username, fullname, email, password, phone, " +
                                       "address, city, pincode, photo, role, created_at, updated_at " +
                                       "FROM Users WHERE user_id = ? AND role = 'Admin'";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
            %>
            <div class="section" id="user-section">
                <div class="section-header">
                    <div>
                        <i class="fas fa-user-shield"></i>
                        <h2>Profile Details</h2>
                    </div>
                </div>
                <div class="user-card" role="article" aria-label="Admin profile details">
                    <div class="user-content">
                        <div class="card-header">
                            <div class="user-info">
                                <h2><%= rs.getString("fullname") != null ? rs.getString("fullname") : "N/A" %></h2>
                            </div>
                            <div class="role-badge">
                                <i class="fas fa-user-shield"></i> <%= rs.getString("role") %>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="card-image-container">
                                <img src='<%= rs.getString("photo") != null ? "user_image/" + rs.getString("photo") : "user_image/default.jpg" %>' alt="Admin <%= rs.getString("fullname") != null ? rs.getString("fullname") : "Profile" %>" class="card-image">
                            </div>
                            <div class="user-details">
                                <div class="detail-item">
                                    <i class="fas fa-id-badge" aria-hidden="true"></i>
                                    <span class="label">User ID:</span>
                                    <span class="value"><%= rs.getInt("user_id") %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-user" aria-hidden="true"></i>
                                    <span class="label">Username:</span>
                                    <span class="value"><%= rs.getString("username") != null ? rs.getString("username") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-user-circle" aria-hidden="true"></i>
                                    <span class="label">Full Name:</span>
                                    <span class="value"><%= rs.getString("fullname") != null ? rs.getString("fullname") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-envelope" aria-hidden="true"></i>
                                    <span class="label">Email:</span>
                                    <span class="value"><%= rs.getString("email") != null ? rs.getString("email") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-lock" aria-hidden="true"></i>
                                    <span class="label">Password:</span>
                                    <span class="value">********</span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-phone" aria-hidden="true"></i>
                                    <span class="label">Phone:</span>
                                    <span class="value"><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-map-marker-alt" aria-hidden="true"></i>
                                    <span class="label">Address:</span>
                                    <span class="value"><%= rs.getString("address") != null ? rs.getString("address") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-city" aria-hidden="true"></i>
                                    <span class="label">City:</span>
                                    <span class="value"><%= rs.getString("city") != null ? rs.getString("city") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-mail-bulk" aria-hidden="true"></i>
                                    <span class="label">Pincode:</span>
                                    <span class="value"><%= rs.getString("pincode") != null ? rs.getString("pincode") : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-user-tag" aria-hidden="true"></i>
                                    <span class="label">Role:</span>
                                    <span class="value"><%= rs.getString("role") != null ? rs.getString("role") : "N/A" %></span>
                                </div>
                                <!-- <div class="detail-item">
                                    <i class="fas fa-calendar-plus" aria-hidden="true"></i>
                                    <span class="label">Created At:</span>
                                    <span class="value"><%= rs.getTimestamp("created_at") != null ? sdf.format(rs.getTimestamp("created_at")) : "N/A" %></span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-calendar-check" aria-hidden="true"></i>
                                    <span class="label">Updated At:</span>
                                    <span class="value"><%= rs.getTimestamp("updated_at") != null ? sdf.format(rs.getTimestamp("updated_at")) : "N/A" %></span>
                                </div> -->
                            </div>
                            <!-- <div class="card-actions">
                                <a href="edit_admin.jsp?id=<%= rs.getInt("user_id") %>" class="action-btn" aria-label="Edit profile">
                                    <i class="fas fa-edit"></i> Edit Profile
                                </a>
                            </div> -->
                        </div>
                    </div>
                </div>
            </div>
            <%
                        } else {
                            out.println("<div class='empty-state' role='alert'>");
                            out.println("<i class='fas fa-user-shield'></i>");
                            out.println("<h3>No Admin Profile Found</h3>");
                            out.println("<p>Your admin profile could not be found or you do not have admin privileges. Please contact support.</p>");
                            out.println("</div>");
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert' role='alert'>");
                        out.println("<i class='fas fa-exclamation-circle'></i>");
                        out.println("Error fetching profile data: " + e.getMessage());
                        out.println("</div>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    }
                }
            %>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Admin Settings Page loaded successfully');
        });
    </script>
</body>
</html>