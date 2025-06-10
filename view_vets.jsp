<%-- 
    Document   : view_vets
    Created on : 9 Jun 2025, 12:15:24 am
    Author     : RUSHANG MAHALE
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@include file="navigation_page.html" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Veterinarian Management Dashboard</title>
    <style>
        :root {
            --primary-color: #1a4c96;
            --primary-hover: #2a5ca8;
            --primary-gradient: linear-gradient(135deg, #1a4c96 0%, #2a5ca8 100%);
            --success-color: #4CAF50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --vet-color: ##1a4c96; /* blue color as theme */
            --light-bg: #f0f5ff;
            --white: #ffffff;
            --text-primary: #333;
            --text-secondary: #666;
            --border-color: #e2e8f0;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 8px rgba(0,0,0,0.12);
            --shadow-lg: 0 8px 16px rgba(0,0,0,0.15);
            --border-radius: 12px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5ff;
            color: #333;
            line-height: 1.6;
            padding: 2rem;
            min-height: 100vh;
        }

        /* Main Container */
        .container {
            display: flex;
            margin: 40px;
            gap: 30px;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            position: sticky;
            top: 100px;
            height: fit-content;
        }

        .sidebar h4 {
            margin-top: 20px;
            color: #2c3e50;
            font-size: 18px;
        }

        .sidebar a {
            color: #3498db;
            text-decoration: none;
            display: block;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .sidebar a:hover {
            color: #2c3e50;
        }

        .sidebar select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 6px;
            color: #555;
            font-size: 15px;
        }

        .sidebar button {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            width: 100%;
            transition: all 0.3s ease;
        }

        .sidebar button:hover {
            background-color: #2c3e50;
            transform: translateY(-2px);
        }

        /* Main Content */
        .main-content {
            flex: 1;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .header h1 {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section {
            margin-bottom: 3rem;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding: 1rem 0;
            border-bottom: 3px solid var(--border-color);
        }

        .section-header.vet-section {
            border-bottom-color: #3498db;
            justify-content: space-between;
        }

        .section-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .vet-count {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--primary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .vet-grid {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .vet-card {
            background: var(--white);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            position: relative;
            width: 100%;
            display: flex;
            flex-direction: row;
            gap: 1.5rem;
            padding: 1.5rem;
        }

        .vet-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .vet-card.vet-card {
            border-top: 4px solid var(--vet-color);
        }

        .vet-content {
            flex: 2;
            display: flex;
            flex-direction: column;
        }

        .card-header {
            position: relative;
            margin-bottom: 1rem;
        }

        .role-badge {
            position: absolute;
            top: 0;
            right: 0;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .role-badge.vet {
            background: rgba(171, 71, 188, 0.1);
            color: var(--vet-color);
            border: 1px solid rgba(171, 71, 188, 0.2);
        }

        .vet-info h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .card-body {
            flex: 1;
        }

        .vet-details {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9rem;
        }

        .detail-item i {
            width: 16px;
            color: var(--primary-color);
            flex-shrink: 0;
        }

        .detail-item .label {
            font-weight: 600;
            color: var(--text-primary);
            min-width: 120px;
        }

        .detail-item .value {
            color: var(--text-secondary);
            flex: 1;
        }

        .card-image-container {
            flex: 1;
            display: flex;
            justify-content: flex-end;
            align-items: flex-start;
        }

        .card-image {
            width: 100%;
            max-width: 300px;
            height: auto;
            object-fit: cover;
            border: 2px solid var(--border-color);
            border-radius: 8px;
        }

        .card-actions {
            display: flex;
            gap: 0.75rem;
        }

        .action-btn {
            flex: 1;
            height: 45px;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            background-color: #3498db;
            color: white;
            font-size: 14px;
        }

        .action-btn:hover {
            background-color: #2980b9;
        }

        .view-details-btn {
            background-color: #3498db;
            color: white;
        }

        .view-details-btn:hover {
            background-color: #2980b9;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: var(--border-color);
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background: rgba(76, 175, 80, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(76, 175, 80, 0.2);
        }

        .alert-error {
            background: rgba(244, 67, 54, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(244, 67, 54, 0.2);
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .container {
                flex-direction: column;
                margin: 20px;
            }

            .sidebar {
                width: 100%;
                position: static;
            }

            .header h1 {
                font-size: 2rem;
            }

            .section-header.vet-section {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-right {
                width: 100%;
                justify-content: space-between;
            }

            .vet-card {
                flex-direction: column;
            }

            .card-image-container {
                justify-content: center;
            }

            .card-image {
                max-width: 100%;
            }
        }

        @media (max-width: 480px) {
            .header-right {
                flex-direction: column;
                gap: 0.5rem;
            }

            .card-actions {
                flex-direction: column;
            }

            .action-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Filters -->
        <div class="sidebar">
            <form method="post" action="view_vets.jsp">
                <a href="view_vets.jsp"><i class="fas fa-filter"></i> <strong>Clear all filters</strong></a>

                <h4>Specialization</h4>
                <select name="specialization">
                    <option value="">All Specializations</option>
                    <option value="General Practice">General Practice</option>
                    <option value="Surgery">Surgery</option>
                    <option value="Dermatology">Dermatology</option>
                    <option value="Dentistry">Dentistry</option>
                    <option value="Cardiology">Cardiology</option>
                </select>

                <h4>Area</h4>
                <select name="area">
                    <option value="">Select area here...</option>
                    <option value="Navrangpura">Navrangpura</option>
                    <option value="Satellite">Satellite</option>
                    <option value="Vastrapur">Vastrapur</option>
                    <option value="Ambawadi">Ambawadi</option>
                    <option value="Thaltej">Thaltej</option>
                    <option value="Paldi">Paldi</option>
                    <option value="Memnagar">Memnagar</option>
                    <option value="Bopal">Bopal</option>
                    <option value="Bodakdev">Bodakdev</option>
                    <option value="Chandkheda">Chandkheda</option>
                    <option value="Ghatlodia">Ghatlodia</option>
                    <option value="Bapunagar">Bapunagar</option>
                    <option value="Shahibaug">Shahibaug</option>
                    <option value="IIM Road">IIM Road</option>
                </select>

                <h4>City</h4>
                <select name="city">
                    <option value="">Any city</option>
                    <option value="Ahmedabad">Ahmedabad</option>
                    <option value="Surat">Surat</option>
                    <option value="Vadodara">Vadodara</option>
                    <option value="Rajkot">Rajkot</option>
                </select>

                <button type="submit">Apply Filter</button>
            </form>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <br>
            <%
                String specialization = request.getParameter("specialization");
                String area = request.getParameter("area");
                String city = request.getParameter("city");

                StringBuilder query = new StringBuilder(
                    "SELECT vet_id, vet_name, photo, email, contact_no, specialization, clinic_name, address, " +
                    "area, city, pincode, available_days, available_time, extra_info " +
                    "FROM Veterinarians WHERE 1=1"
                );

                if (specialization != null && !specialization.isEmpty()) {
                    query.append(" AND specialization = '").append(specialization).append("'");
                }
                if (area != null && !area.isEmpty()) {
                    query.append(" AND area = '").append(area).append("'");
                }
                if (city != null && !city.isEmpty()) {
                    query.append(" AND city = '").append(city).append("'");
                }
                query.append(" ORDER BY vet_name");

                Statement stmt = null;
                ResultSet rs = null;
                int totalVets = 0;

                try {
                    stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs = stmt.executeQuery(query.toString());

                    // Count total veterinarians
                    while (rs.next()) {
                        totalVets++;
                    }
                    rs.beforeFirst();
            %>

            <!-- Veterinarian Section -->
            <% if (totalVets > 0) { %>
            <div class="section" id="vet-section">
                <div class="section-header vet-section">
                    <div>
                        <i class="fas fa-user-md"></i>
                        <h2>Veterinarians</h2>
                    </div>
                </div>
                <div class="vet-grid">
                    <%
                        while (rs.next()) {
                            int vetId = rs.getInt("vet_id");
                            String vetName = rs.getString("vet_name");
                            String photo = rs.getString("photo");
                            String email = rs.getString("email");
                            String contactNo = rs.getString("contact_no");
                            String specializationValue = rs.getString("specialization");
                            String clinicName = rs.getString("clinic_name");
                            String address = rs.getString("address");
                            String vetArea = rs.getString("area");
                            String vetCity = rs.getString("city");
                            String pincode = rs.getString("pincode");
                            String availableDays = rs.getString("available_days");
                            String availableTime = rs.getString("available_time");
                            String extraInfo = rs.getString("extra_info");
                    %>
                    <div class="vet-card vet-card">
                        <div class="vet-content">
                            <div class="card-header">
                                <div class="vet-info">
                                    <h2><%= vetName %></h2>
                                </div>
                                <div class="role-badge vet">
                                    <i class="fas fa-user-md"></i> <%= specializationValue != null ? specializationValue : "Veterinarian" %>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="vet-details">
                                    <div class="card-image-container">
                                        <img src='pet_image/<%= rs.getString("photo") %>' alt="Vet Image" class="card-image">
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-clinic-medical"></i>
                                        <span class="label">Clinic:</span>
                                        <span class="value"><%= clinicName != null ? clinicName : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-envelope"></i>
                                        <span class="label">Email:</span>
                                        <span class="value"><%= email %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-phone"></i>
                                        <span class="label">Contact:</span>
                                        <span class="value"><%= contactNo != null ? contactNo : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span class="label">Address:</span>
                                        <span class="value"><%= address %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-map"></i>
                                        <span class="label">Area:</span>
                                        <span class="value"><%= vetArea %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-city"></i>
                                        <span class="label">City:</span>
                                        <span class="value"><%= vetCity != null ? vetCity : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-mail-bulk"></i>
                                        <span class="label">Pincode:</span>
                                        <span class="value"><%= pincode != null ? pincode : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-calendar-day"></i>
                                        <span class="label">Available Days:</span>
                                        <span class="value"><%= availableDays != null ? availableDays : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-clock"></i>
                                        <span class="label">Available Time:</span>
                                        <span class="value"><%= availableTime != null ? availableTime : "Not specified" %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-info-circle"></i>
                                        <span class="label">Extra Info:</span>
                                        <span class="value"><%= extraInfo != null ? extraInfo : "Not specified" %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            <% } %>

            <% if (totalVets == 0) { %>
            <div class="empty-state">
                <i class="fas fa-user-md"></i>
                <h3>No Veterinarians Found</h3>
                <p>No veterinarians match the selected filters.</p>
            </div>
            <% } %>

            <%
                } catch (SQLException e) {
                    out.println("<div class='alert alert-error'>");
                    out.println("<i class='fas fa-exclamation-circle'></i>");
                    out.println("Error fetching veterinarian data: " + e.getMessage());
                    out.println("</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                }
            %>
        </div>
    </div>

    <script>
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Veterinarian Management Dashboard loaded successfully');
        });
    </script>
</body>
</html>