<%@ page import="java.sql.*,java.io.*,java.util.*,javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>

<%
/* ---------- 1. Access Control ---------- */
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

/* ---------- 2. Handle Form Submission ---------- */
String message = "";
String messageType = "";
boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

if (isPost) {
    // Basic fields
    String name = request.getParameter("name");
    String species = request.getParameter("species");
    String breed = request.getParameter("breed");
    String gender = request.getParameter("gender");
    String status = request.getParameter("status");
    String description = request.getParameter("description");
    String color = request.getParameter("color");
    String image = request.getParameter("image");
    
    // Health and behavior fields
    String neutered_or_spayed = request.getParameter("neutered_or_spayed");
    String vaccinated = request.getParameter("vaccinated");
    String good_with_pets = request.getParameter("good_with_pets");
    String good_with_kids = request.getParameter("good_with_kids");
    String good_with_strangers = request.getParameter("good_with_strangers");
    String behavioral_traits = request.getParameter("behavioral_traits");
    String health_status = request.getParameter("health_status");
    String medication = request.getParameter("medication");
    String preferable_food = request.getParameter("preferable_food");
    String special_needs = request.getParameter("special_needs");
    String daily_routine = request.getParameter("daily_routine");
    String trained_for = request.getParameter("trained_for");
    String dietary_restrictions = request.getParameter("dietary_restrictions");
    
    // Previous owner fields
    String previous_owner_name = request.getParameter("previous_owner_name");
    String contact_no = request.getParameter("contact_no");
    String story = request.getParameter("story");
    String reason_for_rehoming = request.getParameter("reason_for_rehoming");
    
    int age = -1;
    double weight = -1;
    double height = -1;

    // Validate numeric fields
    try {
        String ageStr = request.getParameter("age");
        if (ageStr != null && !ageStr.trim().isEmpty()) {
            age = Integer.parseInt(ageStr);
            if (age < 0) {
                throw new NumberFormatException("Age cannot be negative");
            }
        }
        
        String weightStr = request.getParameter("weight");
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            weight = Double.parseDouble(weightStr);
            if (weight <= 0) {
                throw new NumberFormatException("Weight must be positive");
            }
        }
        
        String heightStr = request.getParameter("height");
        if (heightStr != null && !heightStr.trim().isEmpty()) {
            height = Double.parseDouble(heightStr);
            if (height <= 0) {
                throw new NumberFormatException("Height must be positive");
            }
        }
    } catch (NumberFormatException e) {
        message = "Invalid numeric values provided!";
        messageType = "error";
    }

    // Validate required fields
    if (message.isEmpty()) {
        if (name == null || name.trim().isEmpty() ||
            species == null || !Arrays.asList("Dog", "Cat").contains(species) ||
            breed == null || breed.trim().isEmpty() ||
            gender == null || !Arrays.asList("Male", "Female").contains(gender) ||
            status == null || !Arrays.asList("Available", "Adopted", "Deceased").contains(status) ||
            description == null || description.trim().isEmpty() ||
            age < 0 || weight <= 0 || height <= 0) {
            message = "All required fields must be filled with valid values!";
            messageType = "error";
        }
    }

    // Insert into database
    if (message.isEmpty()) {
        PreparedStatement ps = null;
        try {
            if (conn == null) throw new SQLException("Database connection is null");

            String sql = "INSERT INTO pets (name, species, breed, age, gender, weight, height, description, status, " +
                        "image, color, neutered_or_spayed, vaccinated, good_with_pets, good_with_kids, " +
                        "good_with_strangers, behavioral_traits, health_status, medication, preferable_food, " +
                        "special_needs, daily_routine, trained_for, dietary_restrictions, previous_owner_name, " +
                        "contact_no, story, reason_for_rehoming) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, species);
            ps.setString(3, breed);
            ps.setInt(4, age);
            ps.setString(5, gender);
            ps.setDouble(6, weight);
            ps.setDouble(7, height);
            ps.setString(8, description);
            ps.setString(9, status);
            ps.setString(10, image != null && !image.trim().isEmpty() ? image : null);
            ps.setString(11, color != null && !color.trim().isEmpty() ? color : null);
            ps.setString(12, neutered_or_spayed != null ? neutered_or_spayed : "No");
            ps.setString(13, vaccinated != null ? vaccinated : "No");
            ps.setString(14, good_with_pets != null ? good_with_pets : "Unknown");
            ps.setString(15, good_with_kids != null ? good_with_kids : "Unknown");
            ps.setString(16, good_with_strangers != null ? good_with_strangers : "Unknown");
            ps.setString(17, behavioral_traits != null && !behavioral_traits.trim().isEmpty() ? behavioral_traits : null);
            ps.setString(18, health_status != null && !health_status.trim().isEmpty() ? health_status : null);
            ps.setString(19, medication != null && !medication.trim().isEmpty() ? medication : null);
            ps.setString(20, preferable_food != null && !preferable_food.trim().isEmpty() ? preferable_food : null);
            ps.setString(21, special_needs != null && !special_needs.trim().isEmpty() ? special_needs : null);
            ps.setString(22, daily_routine != null && !daily_routine.trim().isEmpty() ? daily_routine : null);
            ps.setString(23, trained_for != null && !trained_for.trim().isEmpty() ? trained_for : null);
            ps.setString(24, dietary_restrictions != null && !dietary_restrictions.trim().isEmpty() ? dietary_restrictions : null);
            ps.setString(25, previous_owner_name != null && !previous_owner_name.trim().isEmpty() ? previous_owner_name : null);
            ps.setString(26, contact_no != null && !contact_no.trim().isEmpty() ? contact_no : null);
            ps.setString(27, story != null && !story.trim().isEmpty() ? story : null);
            ps.setString(28, reason_for_rehoming != null && !reason_for_rehoming.trim().isEmpty() ? reason_for_rehoming : null);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "Pet added successfully!";
                messageType = "success";
            } else {
                message = "Failed to add pet!";
                messageType = "error";
            }
        } catch (SQLException ex) {
            message = "Database error: " + ex.getMessage();
            messageType = "error";
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add New Pet</title>
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
            padding-top: 80px;
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
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* Form Container */
        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            padding: 30px;
        }

        .page-title {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
            font-size: 28px;
            position: relative;
        }

        .page-title:after {
            content: "";
            position: absolute;
            width: 80px;
            height: 3px;
            background-color: #3498db;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        /* Section Headers */
        .section-header {
            font-size: 20px;
            color: #2c3e50;
            margin: 30px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
            font-weight: 600;
        }

        .section-header:first-of-type {
            margin-top: 0;
        }

        /* Form Layout */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }

        .required {
            color: #e74c3c;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            color: #333;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .full-width {
            grid-column: span 3;
        }

        .half-width {
            grid-column: span 2;
        }

        /* Form Buttons */
        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .save-btn, .cancel-btn {
            padding: 12px 25px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .save-btn {
            background-color: #27ae60;
            color: white;
        }

        .save-btn:hover {
            background-color: #219653;
            transform: translateY(-2px);
        }

        .cancel-btn {
            background-color: #7f8c8d;
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .cancel-btn:hover {
            background-color: #636e72;
            transform: translateY(-2px);
        }

        /* Alert Messages */
        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .form-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .full-width {
                grid-column: span 2;
            }
        }

        @media (max-width: 768px) {
            .form-grid, .form-grid-2 {
                grid-template-columns: 1fr;
            }
            .full-width, .half-width {
                grid-column: span 1;
            }
            .navbar {
                padding: 15px 20px;
            }
            .container {
                padding: 0 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <img src="pet_image/logo.png" alt="Admin Logo">
        <nav>
            <a href="admin_dashboard.jsp">Dashboard</a>
            <a href="admin_view_page.jsp" style="background-color: #1abc9c;">Pets</a>
            <a href="view_adaption_request.jsp">Adoption Requests</a>
            <a href="donation.html">Donations</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="form-container">
            <h1 class="page-title">Add New Pet</h1>

            <!-- Display Messages -->
            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <!-- Form to add pet -->
            <form action="add_pet.jsp" method="post">
                
                <!-- Basic Information Section -->
                <div class="section-header">Basic Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Pet Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label for="species">Pet Type <span class="required">*</span></label>
                        <select id="species" name="species" required>
                            <option value="">Select type</option>
                            <option value="Dog">Dog</option>
                            <option value="Cat">Cat</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="breed">Breed <span class="required">*</span></label>
                        <input type="text" id="breed" name="breed" required>
                    </div>

                    <div class="form-group">
                        <label for="age">Age (years) <span class="required">*</span></label>
                        <input type="number" id="age" name="age" min="0" step="1" required>
                    </div>

                    <div class="form-group">
                        <label for="gender">Gender <span class="required">*</span></label>
                        <select id="gender" name="gender" required>
                            <option value="">Select gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="color">Color</label>
                        <input type="text" id="color" name="color" placeholder="e.g., Golden, Black & Tan">
                    </div>

                    <div class="form-group">
                        <label for="weight">Weight (kg) <span class="required">*</span></label>
                        <input type="number" id="weight" name="weight" min="0.1" step="0.1" required>
                    </div>

                    <div class="form-group">
                        <label for="height">Height (cm) <span class="required">*</span></label>
                        <input type="number" id="height" name="height" min="1" step="0.1" required>
                    </div>

                    <div class="form-group">
                        <label for="status">Status <span class="required">*</span></label>
                        <select id="status" name="status" required>
                            <option value="Available" selected>Available</option>
                            <option value="Adopted">Adopted</option>
                            <option value="Deceased">Deceased</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="image">Image Filename</label>
                        <input type="text" id="image" name="image" placeholder="e.g., pet_001.jpg">
                    </div>

                    <div class="form-group full-width">
                        <label for="description">Description <span class="required">*</span></label>
                        <textarea id="description" name="description" required placeholder="Provide a general description of the pet"></textarea>
                    </div>
                </div>

                <!-- Health & Medical Information Section -->
                <div class="section-header">Health & Medical Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="neutered_or_spayed">Neutered/Spayed</label>
                        <select id="neutered_or_spayed" name="neutered_or_spayed">
                            <option value="No" selected>No</option>
                            <option value="Yes">Yes</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="vaccinated">Vaccination Status</label>
                        <select id="vaccinated" name="vaccinated">
                            <option value="No" selected>No</option>
                            <option value="Yes">Yes</option>
                            <option value="Partially">Partially</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="health_status">Health Status</label>
                        <input type="text" id="health_status" name="health_status" placeholder="e.g., Healthy, Minor issues">
                    </div>

                    <div class="form-group full-width">
                        <label for="medication">Current Medications</label>
                        <textarea id="medication" name="medication" placeholder="List any current medications or treatments"></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="special_needs">Special Needs</label>
                        <textarea id="special_needs" name="special_needs" placeholder="Any special care requirements"></textarea>
                    </div>
                </div>

                <!-- Behavior & Compatibility Section -->
                <div class="section-header">Behavior & Compatibility</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="good_with_pets">Good with Other Pets</label>
                        <select id="good_with_pets" name="good_with_pets">
                            <option value="Unknown" selected>Unknown</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="good_with_kids">Good with Kids</label>
                        <select id="good_with_kids" name="good_with_kids">
                            <option value="Unknown" selected>Unknown</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="good_with_strangers">Good with Strangers</label>
                        <select id="good_with_strangers" name="good_with_strangers">
                            <option value="Unknown" selected>Unknown</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label for="behavioral_traits">Behavioral Traits</label>
                        <textarea id="behavioral_traits" name="behavioral_traits" placeholder="e.g., Playful, Loyal, Alert, Calm"></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="trained_for">Training</label>
                        <textarea id="trained_for" name="trained_for" placeholder="Commands or skills the pet knows"></textarea>
                    </div>
                </div>

                <!-- Care & Routine Section -->
                <div class="section-header">Care & Routine</div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="preferable_food">Preferred Food</label>
                        <textarea id="preferable_food" name="preferable_food" placeholder="Types of food the pet prefers"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="dietary_restrictions">Dietary Restrictions</label>
                        <textarea id="dietary_restrictions" name="dietary_restrictions" placeholder="Any food allergies or restrictions"></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="daily_routine">Daily Routine</label>
                        <textarea id="daily_routine" name="daily_routine" placeholder="Describe the pet's typical daily routine"></textarea>
                    </div>
                </div>

                <!-- Previous Owner Information Section -->
                <div class="section-header">Previous Owner Information</div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="previous_owner_name">Previous Owner Name</label>
                        <input type="text" id="previous_owner_name" name="previous_owner_name">
                    </div>

                    <div class="form-group">
                        <label for="contact_no">Contact Number</label>
                        <input type="tel" id="contact_no" name="contact_no" placeholder="+91-XXXXXXXXXX">
                    </div>

                    <div class="form-group full-width">
                        <label for="reason_for_rehoming">Reason for Rehoming</label>
                        <textarea id="reason_for_rehoming" name="reason_for_rehoming" placeholder="Why is the pet being rehomed?"></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="story">Pet's Story</label>
                        <textarea id="story" name="story" placeholder="Tell the pet's story from their perspective"></textarea>
                    </div>
                </div>

                <div class="form-buttons">
                    <a href="admin_view_page.jsp" class="cancel-btn">Cancel</a>
                    <button type="submit" class="save-btn">Add Pet</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>