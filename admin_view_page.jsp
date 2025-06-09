<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Admin - Manage Pets</title>
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

        /* Action Buttons */
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
        }

        .edit-btn, .delete-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            flex: 1;
        }

        .edit-btn {
            background-color: #3498db;
            color: white;
            margin-right: 5px;
        }

        .edit-btn:hover {
            background-color: #2980b9;
        }

        .delete-btn {
            background-color: #e74c3c;
            color: white;
            margin-left: 5px;
        }

        .delete-btn:hover {
            background-color: #c0392b;
        }

        /* Admin Header */
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .add-pet-btn {
            background-color: #27ae60;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .add-pet-btn:hover {
            background-color: #219653;
            transform: translateY(-2px);
        }

        /* Pet Cards Container */
        .main-content {
            flex: 1;
        }

        h1 {
            text-align: center;
            margin-bottom: 40px;
            color: #2c3e50;
            font-size: 32px;
            position: relative;
        }

        h1:after {
            content: "";
            position: absolute;
            width: 100px;
            height: 3px;
            background-color: #3498db;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        .cards {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            gap: 25px;
            justify-content: center;
        }

        .card {
            background-color: white;
            width: 250px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .card-content {
            padding: 15px;
        }

        .card-content h3 {
            margin: 0 0 10px;
            color: #2c3e50;
            font-size: 18px;
        }

        .card-content p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
            line-height: 1.5;
        }

        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .status-available {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-adopted {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .status-pending {
            background-color: #fff8e1;
            color: #f57f17;
        }

        /* Confirmation Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            text-align: center;
        }

        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }

        .modal-confirm, .modal-cancel {
            padding: 10px 25px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }

        .modal-confirm {
            background-color: #e74c3c;
            color: white;
        }

        .modal-cancel {
            background-color: #7f8c8d;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <img src="pet_image/logo_white.png" alt="Admin Logo">
        <nav>
            <a href="admin_dashboard.jsp">Dashboard</a>
            <!--<a href="manage_users.jsp">Users</a>-->
            <a href="admin_view_page.jsp" style="background-color: #1abc9c;">Pets</a>
            <a href="view_adaption_request.jsp">Adoption Requests</a>
            <a href="donation.html">Donations</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="sidebar">
            <form method="post" action="admin_view_page.jsp">
                <a href="admin_view_page.jsp"><i class="fas fa-filter"></i> <strong>Clear all filters</strong></a>

                <h4>Pet type</h4>
                <select name="species">
                    <option value="">All pets</option>
                    <option value="Dog">Dog</option>
                    <option value="Cat">Cat</option>
                </select>

                <h4>Status</h4>
                <select name="status">
                    <option value="">All statuses</option>
                    <option value="Available">Available</option>
                    <option value="Adopted">Adopted</option>
                    <option value="Pending">Pending</option>
                </select>

                <h4>Search by Area</h4>
                <select name="area">
                    <option value="">Select area here...</option>
                    <option value="Navrangpura">Navrangpura</option>
                    <option value="Satellite">Satellite</option>
                    <option value="Vastrapur">Vastrapur</option>
                    <option value="Maninagar">Maninagar</option>
                    <option value="Thaltej">Thaltej</option>
                    <option value="Paldi">Paldi</option>
                    <option value="Bodakdev">Bodakdev</option>
                    <option value="Chandkheda">Chandkheda</option>
                    <option value="Ghatlodia">Ghatlodia</option>
                    <option value="Bapunagar">Bapunagar</option>
                    <option value="Shahibaug">Shahibaug</option>
                </select>

                <h4>Age</h4>
                <select name="age">
                    <option value="">Any age</option>
                    <option value="1">Puppy/Kitten (&lt; 1 year)</option>
                    <option value="3">Young (1-3 years)</option>
                    <option value="7">Adult (4-7 years)</option>
                    <option value="8">Senior (8+ years)</option>
                </select>

                <h4>Gender</h4>
                <select name="gender">
                    <option value="">Any gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>

                <button type="submit">Apply Filter</button>
            </form>
        </div>

        <!-- Pet Cards -->
        <div class="main-content">
            <div class="admin-header">
                <h1>Manage Pets</h1>
                <a href="add_pet.jsp" class="add-pet-btn">+ Add New Pet</a>
            </div>
            
            <div class="cards">
                <%
                String breed = request.getParameter("species");
                String status = request.getParameter("status");
                String area = request.getParameter("area");
                String age = request.getParameter("age");
                String gender = request.getParameter("gender");

                StringBuilder query = new StringBuilder("SELECT * FROM pets WHERE 1=1");

                if (breed != null && !breed.isEmpty()) {
                    query.append(" AND species = '").append(breed).append("'");
                }
                if (status != null && !status.isEmpty()) {
                    query.append(" AND status = '").append(status).append("'");
                }
                if (area != null && !area.isEmpty()) {
                    query.append(" AND area = '").append(area).append("'");
                }
                if (gender != null && !gender.isEmpty()) {
                    query.append(" AND gender = '").append(gender).append("'");
                }
                if (age != null && !age.isEmpty()) {
                    int ageVal = Integer.parseInt(age);
                    if (ageVal == 1) query.append(" AND age < 1");
                    else if (ageVal == 3) query.append(" AND age >= 1 AND age <= 3");
                    else if (ageVal == 7) query.append(" AND age >= 4 AND age <= 7");
                    else if (ageVal == 8) query.append(" AND age >= 8");
                }

                Statement stmt = null;
                ResultSet rs = null;

                try {
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(query.toString());

                    if (!rs.next()) {
                        out.println("<p>No pets found for selected filters.</p>");
                    } else {
                        do {
                            String petStatus = rs.getString("status") != null ? rs.getString("status") : "Available";
                            String statusClass = "";
                            
                            if(petStatus.equals("Available")) {
                                statusClass = "status-available";
                            } else if(petStatus.equals("Adopted")) {
                                statusClass = "status-adopted";
                            } else {
                                statusClass = "status-pending";
                            }
                %>
                    <div class="card">
                        <img src='pet_image/<%= rs.getString("image") %>' alt="Pet Image">
                        <div class="card-content">
                            <span class="status-badge <%= statusClass %>"><%= petStatus %></span>
                            <h3><%= rs.getString("name") %></h3>
                            <p>Breed: <%= rs.getString("breed") %></p>
                            <p>Age: <%= rs.getInt("age") %> years</p>
                            <p>Gender: <%= rs.getString("gender") %></p>
                            
                            <div class="action-buttons">
                                <a href="edit_pet.jsp?id=<%= rs.getInt("pet_id") %>" class="edit-btn">Edit</a>
                                <!--<a href="#" onclick="confirmDelete(<%= rs.getInt("pet_id") %>)" class="delete-btn">Delete</a>-->
                            </div>
                        </div>
                    </div>
                <%
                        } while (rs.next());
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
                %>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Delete</h3>
            <p>Are you sure you want to delete this pet? This action cannot be undone.</p>
            <div class="modal-buttons">
                <button id="confirmDelete" class="modal-confirm">Delete</button>
                <button onclick="closeModal()" class="modal-cancel">Cancel</button>
            </div>
        </div>
    </div>

    <script>
        // Get the modal
        var modal = document.getElementById('deleteModal');
        var confirmBtn = document.getElementById('confirmDelete');
        
        // Function to open modal and set pet ID
        function confirmDelete(petId) {
            modal.style.display = "block";
            confirmBtn.onclick = function() {
                window.location.href = "delete_pet.jsp?id=" + petId;
            };
        }
        
        // Function to close modal
        function closeModal() {
            modal.style.display = "none";
        }
        
        // Close the modal if clicked outside of it
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        };
    </script>
</body>
</html>