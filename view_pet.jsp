<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@include file="navigation_page.html" %>

<!DOCTYPE html>
<html>
<head>
    <title>Pets</title>
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
/*        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #1a4c96;
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
            width: 100px;
            filter: brightness(0) invert(1);
        }*/

/*        .navbar nav {
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
            background-color: #2a5ca8;
        }*/

/*        .logout-btn {
            background-color: #4285f4;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #2a75f3;
            transform: translateY(-2px);
        }*/

        /* Main Container */
        .container {
            display: flex;
            margin: 40px;
            gap: 30px;
        }

        /* Sidebar Styles (Unchanged) */
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
            color: #1a4c96;
            font-size: 18px;
        }

        .sidebar a {
            color: #4285f4;
            text-decoration: none;
            display: block;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .sidebar a:hover {
            color: #1a4c96;
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
            background-color: #4285f4;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            width: 100%;
            transition: all 0.3s ease;
        }

        .sidebar button:hover {
            background-color: #1a4c96;
            transform: translateY(-2px);
        }

        /* Pet Cards Container */
        .main-content {
            flex: 1;
        }

        h1 {
            text-align: center;
            margin: 40px 0;
            color: #1a4c96;
            font-size: 32px;
            position: relative;
        }

        h1:after {
            content: "";
            position: absolute;
            width: 100px;
            height: 3px;
            background-color: #4285f4;
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
            width: 250px; /* Smaller width for horizontal layout */
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
            height: 180px; /* Adjusted height */
            object-fit: cover;
        }

        .card-content {
            padding: 15px;
        }

        .card-content h3 {
            margin: 0 0 10px;
            color: #1a4c96;
            font-size: 18px;
        }

        .card-content p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
            line-height: 1.5;
        }

        .adopt-btn {
            display: block;
            background-color: #4285f4;
            color: white;
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            margin-top: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .adopt-btn:hover {
            background-color: #1a4c96;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
<!--    <div class="navbar">
       <img src="pet_image/logo.png" alt="Logo">  Replace with your logo path 
        <nav>
            <a href="#"><i class="fas fa-paw"></i> Home</a>
            <a href="#"><i class="fas fa-home"></i> Services</a>
            <a href="#"><i class="fas fa-shopping-cart"></i> Shop</a>
            <a href="logout.jsp" class="logout-btn"><i class="fas fa-user"></i> Logout</a>
        </nav>
    </div>-->

    <!-- Main Content -->
    <div class="container">
       <div class="sidebar">
    <form method="post" action="view_pet.jsp"> <!-- Form starts -->
        <a href="view_pet.jsp"><i class="fas fa-filter"></i> <strong>Clear all filters</strong></a>

        <h4>Pet type</h4>
        <select name="species">
            <option value="">All pets</option>
            <option value="Dog">Dog</option>
            <option value="Cat">Cat</option>
        </select>

<!--        <h4>Status</h4>
        <select name="status">
            <option value="">All statuses</option>
            <option value="Available">Available</option>
            <option value="Fostered">Fostered</option>
            <option value="Adopted">Adopted</option>
            <option value="Lost & Found">Lost & Found</option>
        </select>-->

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
    </form> <!-- Form ends -->
</div>


        <!-- Pet Cards -->
        <div class="main-content">
            <h1>Available Pets for Adoption</h1>
            <div class="cards">
                <%
    String breed = request.getParameter("species");
    String status = request.getParameter("status");
    String area = request.getParameter("area");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");

    StringBuilder query = new StringBuilder("SELECT * FROM pets WHERE status='Available'");

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
%>
                <div class="card">
                    <img src='pet_image/<%= rs.getString("image") %>' alt="Pet Image">
                    <div class="card-content">
                        <h3><%= rs.getString("name") %></h3>
                        <p>Breed: <%= rs.getString("breed") %></p>
                        <p>Age: <%= rs.getInt("age") %> years</p>
                        <a href="pet_details.jsp?id=<%= rs.getInt("pet_id") %>" class="adopt-btn">View Details</a>
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
</body>
</html>