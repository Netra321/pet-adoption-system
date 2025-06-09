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
<%  
    // Get pet ID from request parameter
    String petId = request.getParameter("id");
    if (petId == null || petId.isEmpty()) {
        response.sendRedirect("manage_pets.jsp");
        return;
    }
    
    // Process form submission
    String message = "";
    String messageType = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Get form data
            String name = request.getParameter("name");
            String species = request.getParameter("species");
            String breed = request.getParameter("breed");
            String ageStr = request.getParameter("age");
            String gender = request.getParameter("gender");
            String weightStr = request.getParameter("weight");
            String heightStr = request.getParameter("height");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String color = request.getParameter("color");
            String neutered = request.getParameter("neutered_or_spayed");
            String vaccinated = request.getParameter("vaccinated");
            String goodWithPets = request.getParameter("good_with_pets");
            String goodWithKids = request.getParameter("good_with_kids");
            String goodWithStrangers = request.getParameter("good_with_strangers");
            String behavioralTraits = request.getParameter("behavioral_traits");
            String healthStatus = request.getParameter("health_status");
            String medication = request.getParameter("medication");
            String preferableFood = request.getParameter("preferable_food");
            String specialNeeds = request.getParameter("special_needs");
            String dailyRoutine = request.getParameter("daily_routine");
            String trainedFor = request.getParameter("trained_for");
            String dietaryRestrictions = request.getParameter("dietary_restrictions");
            String previousOwnerName = request.getParameter("previous_owner_name");
            String contactNo = request.getParameter("contact_no");
            String story = request.getParameter("story");
            String reasonForRehoming = request.getParameter("reason_for_rehoming");
            
            // Validate required inputs
            if (name == null || name.trim().isEmpty() || species == null || species.trim().isEmpty() ||
                ageStr == null || ageStr.trim().isEmpty() || gender == null || gender.trim().isEmpty() ||
                weightStr == null || weightStr.trim().isEmpty() || heightStr == null || heightStr.trim().isEmpty()) {
                message = "Required fields (Name, Species, Age, Gender, Weight, Height) cannot be empty!";
                messageType = "error";
            } else {
                int age = Integer.parseInt(ageStr);
                double weight = Double.parseDouble(weightStr);
                double height = Double.parseDouble(heightStr);
                
                // Update pet information in database
                PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE pets SET name=?, species=?, breed=?, age=?, gender=?, weight=?, height=?, description=?, status=?, " +
                    "color=?, neutered_or_spayed=?, vaccinated=?, good_with_pets=?, good_with_kids=?, good_with_strangers=?, " +
                    "behavioral_traits=?, health_status=?, medication=?, preferable_food=?, special_needs=?, daily_routine=?, " +
                    "trained_for=?, dietary_restrictions=?, previous_owner_name=?, contact_no=?, story=?, reason_for_rehoming=? " +
                    "WHERE pet_id=?"
                );
                
                pstmt.setString(1, name);
                pstmt.setString(2, species);
                pstmt.setString(3, breed);
                pstmt.setInt(4, age);
                pstmt.setString(5, gender);
                pstmt.setDouble(6, weight);
                pstmt.setDouble(7, height);
                pstmt.setString(8, description);
                pstmt.setString(9, status);
                pstmt.setString(10, color);
                pstmt.setString(11, neutered);
                pstmt.setString(12, vaccinated);
                pstmt.setString(13, goodWithPets);
                pstmt.setString(14, goodWithKids);
                pstmt.setString(15, goodWithStrangers);
                pstmt.setString(16, behavioralTraits);
                pstmt.setString(17, healthStatus);
                pstmt.setString(18, medication);
                pstmt.setString(19, preferableFood);
                pstmt.setString(20, specialNeeds);
                pstmt.setString(21, dailyRoutine);
                pstmt.setString(22, trainedFor);
                pstmt.setString(23, dietaryRestrictions);
                pstmt.setString(24, previousOwnerName);
                pstmt.setString(25, contactNo);
                pstmt.setString(26, story);
                pstmt.setString(27, reasonForRehoming);
                pstmt.setInt(28, Integer.parseInt(petId));
                
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    message = "Pet information updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update pet information!";
                    messageType = "error";
                }
                pstmt.close();
            }
        } catch (NumberFormatException e) {
            message = "Please enter valid numbers for age, weight, and height!";
            messageType = "error";
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            messageType = "error";
        }
    }
    
    // Get pet information
    Pet pet = new Pet();
    
    try {
        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM pets WHERE pet_id = ?");
        pstmt.setInt(1, Integer.parseInt(petId));
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            pet.id = rs.getInt("pet_id");
            pet.name = rs.getString("name");
            pet.species = rs.getString("species");
            pet.breed = rs.getString("breed");
            pet.age = rs.getInt("age");
            pet.gender = rs.getString("gender");
            pet.weight = rs.getDouble("weight");
            pet.height = rs.getDouble("height");
            pet.description = rs.getString("description");
            pet.status = rs.getString("status");
            pet.image = rs.getString("image");
            pet.color = rs.getString("color");
            pet.neuteredOrSpayed = rs.getString("neutered_or_spayed");
            pet.vaccinated = rs.getString("vaccinated");
            pet.goodWithPets = rs.getString("good_with_pets");
            pet.goodWithKids = rs.getString("good_with_kids");
            pet.goodWithStrangers = rs.getString("good_with_strangers");
            pet.behavioralTraits = rs.getString("behavioral_traits");
            pet.healthStatus = rs.getString("health_status");
            pet.medication = rs.getString("medication");
            pet.preferableFood = rs.getString("preferable_food");
            pet.specialNeeds = rs.getString("special_needs");
            pet.dailyRoutine = rs.getString("daily_routine");
            pet.trainedFor = rs.getString("trained_for");
            pet.dietaryRestrictions = rs.getString("dietary_restrictions");
            pet.previousOwnerName = rs.getString("previous_owner_name");
            pet.contactNo = rs.getString("contact_no");
            pet.story = rs.getString("story");
            pet.reasonForRehoming = rs.getString("reason_for_rehoming");
        } else {
            response.sendRedirect("manage_pets.jsp");
            return;
        }
        
        rs.close();
        pstmt.close();
    } catch (Exception e) {
        message = "Error retrieving pet information: " + e.getMessage();
        messageType = "error";
    }
%>

<%!
    // Pet class to store pet information
    class Pet {
        int id;
        String name;
        String species;
        String breed;
        int age;
        String gender;
        double weight;
        double height;
        String description;
        String status;
        String image;
        String color;
        String neuteredOrSpayed;
        String vaccinated;
        String goodWithPets;
        String goodWithKids;
        String goodWithStrangers;
        String behavioralTraits;
        String healthStatus;
        String medication;
        String preferableFood;
        String specialNeeds;
        String dailyRoutine;
        String trainedFor;
        String dietaryRestrictions;
        String previousOwnerName;
        String contactNo;
        String story;
        String reasonForRehoming;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Pet Information</title>
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
            max-width: 1200px;
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
            background-color: #3498db;
            color: white;
            padding: 12px 20px;
            margin: 30px 0 20px 0;
            border-radius: 6px;
            font-size: 18px;
            font-weight: bold;
        }

        .section-header:first-of-type {
            margin-top: 0;
        }

        /* Form Layout */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
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

        .required::after {
            content: " *";
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
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .full-width {
            grid-column: span 2;
        }

        .full-width-3 {
            grid-column: span 3;
        }

        /* Pet Image Preview */
        .pet-preview {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 30px;
        }

        .pet-image {
            width: 250px;
            height: 250px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
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
            text-decoration: none;
            display: inline-block;
            text-align: center;
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

        /* Helper text */
        .help-text {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <img src="pet_image/logo.png" alt="Admin Logo">
        <nav>
            <a href="admin_dashboard.jsp">Dashboard</a>
            <a href="manage_users.jsp">Users</a>
            <a href="manage_pets.jsp" style="background-color: #1abc9c;">Pets</a>
            <a href="view_adaption_request.jsp">Adoption Requests</a>
            <a href="manage_donations.jsp">Donations</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="form-container">
            <h1 class="page-title">Edit Pet Information</h1>
            
            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>
            
            <div class="pet-preview">
                <% if (pet.image != null && !pet.image.isEmpty()) { %>
                    <img src="pet_image/<%= pet.image %>" alt="<%= pet.name %>" class="pet-image">
                <% } else { %>
                    <img src="pet_image/default-pet.png" alt="Default Pet" class="pet-image">
                <% } %>
            </div>
            
            <form action="edit_pet.jsp?id=<%= pet.id %>" method="post">
                
                <!-- Basic Information -->
                <div class="section-header">Basic Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name" class="required">Pet Name</label>
                        <input type="text" id="name" name="name" value="<%= pet.name != null ? pet.name : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="species" class="required">Pet Type</label>
                        <select id="species" name="species" required>
                            <option value="Dog" <%= "Dog".equals(pet.species) ? "selected" : "" %>>Dog</option>
                            <option value="Cat" <%= "Cat".equals(pet.species) ? "selected" : "" %>>Cat</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="breed">Breed</label>
                        <input type="text" id="breed" name="breed" value="<%= pet.breed != null ? pet.breed : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="age" class="required">Age (years)</label>
                        <input type="number" id="age" name="age" value="<%= pet.age %>" min="0" step="1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="gender" class="required">Gender</label>
                        <select id="gender" name="gender" required>
                            <option value="Male" <%= "Male".equals(pet.gender) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(pet.gender) ? "selected" : "" %>>Female</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="color">Color</label>
                        <input type="text" id="color" name="color" value="<%= pet.color != null ? pet.color : "" %>">
                    </div>
                </div>

                <!-- Physical Attributes -->
                <div class="section-header">Physical Attributes</div>
                <div class="form-grid-3">
                    <div class="form-group">
                        <label for="weight" class="required">Weight (kg)</label>
                        <input type="number" id="weight" name="weight" value="<%= pet.weight %>" min="0" step="0.1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="height" class="required">Height (cm)</label>
                        <input type="number" id="height" name="height" value="<%= pet.height %>" min="0" step="0.1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="Available" <%= "Available".equals(pet.status) ? "selected" : "" %>>Available</option>
                            <option value="Adopted" <%= "Adopted".equals(pet.status) ? "selected" : "" %>>Adopted</option>
                            <option value="Deceased" <%= "Deceased".equals(pet.status) ? "selected" : "" %>>Deceased</option>
                        </select>
                    </div>
                </div>

                <!-- Health Information -->
                <div class="section-header">Health Information</div>
                <div class="form-grid-3">
                    <div class="form-group">
                        <label for="neutered_or_spayed">Neutered/Spayed</label>
                        <select id="neutered_or_spayed" name="neutered_or_spayed">
                            <option value="Yes" <%= "Yes".equals(pet.neuteredOrSpayed) ? "selected" : "" %>>Yes</option>
                            <option value="No" <%= "No".equals(pet.neuteredOrSpayed) ? "selected" : "" %>>No</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="vaccinated">Vaccinated</label>
                        <select id="vaccinated" name="vaccinated">
                            <option value="Yes" <%= "Yes".equals(pet.vaccinated) ? "selected" : "" %>>Yes</option>
                            <option value="No" <%= "No".equals(pet.vaccinated) ? "selected" : "" %>>No</option>
                            <option value="Partially" <%= "Partially".equals(pet.vaccinated) ? "selected" : "" %>>Partially</option>
                        </select>
                    </div>
                    
                    <div class="form-group full-width-3">
                        <label for="health_status">Health Status</label>
                        <textarea id="health_status" name="health_status"><%= pet.healthStatus != null ? pet.healthStatus : "" %></textarea>
                    </div>
                    
                    <div class="form-group full-width-3">
                        <label for="medication">Current Medication</label>
                        <textarea id="medication" name="medication"><%= pet.medication != null ? pet.medication : "" %></textarea>
                        <div class="help-text">List any medications the pet is currently taking</div>
                    </div>
                    
                    <div class="form-group full-width-3">
                        <label for="special_needs">Special Needs</label>
                        <textarea id="special_needs" name="special_needs"><%= pet.specialNeeds != null ? pet.specialNeeds : "" %></textarea>
                    </div>
                </div>

                <!-- Behavioral Information -->
                <div class="section-header">Behavioral Information</div>
                <div class="form-grid-3">
                    <div class="form-group">
                        <label for="good_with_pets">Good with Pets</label>
                        <select id="good_with_pets" name="good_with_pets">
                            <option value="Yes" <%= "Yes".equals(pet.goodWithPets) ? "selected" : "" %>>Yes</option>
                            <option value="No" <%= "No".equals(pet.goodWithPets) ? "selected" : "" %>>No</option>
                            <option value="Unknown" <%= "Unknown".equals(pet.goodWithPets) ? "selected" : "" %>>Unknown</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="good_with_kids">Good with Kids</label>
                        <select id="good_with_kids" name="good_with_kids">
                            <option value="Yes" <%= "Yes".equals(pet.goodWithKids) ? "selected" : "" %>>Yes</option>
                            <option value="No" <%= "No".equals(pet.goodWithKids) ? "selected" : "" %>>No</option>
                            <option value="Unknown" <%= "Unknown".equals(pet.goodWithKids) ? "selected" : "" %>>Unknown</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="good_with_strangers">Good with Strangers</label>
                        <select id="good_with_strangers" name="good_with_strangers">
                            <option value="Yes" <%= "Yes".equals(pet.goodWithStrangers) ? "selected" : "" %>>Yes</option>
                            <option value="No" <%= "No".equals(pet.goodWithStrangers) ? "selected" : "" %>>No</option>
                            <option value="Unknown" <%= "Unknown".equals(pet.goodWithStrangers) ? "selected" : "" %>>Unknown</option>
                        </select>
                    </div>
                    
                    <div class="form-group full-width-3">
                        <label for="behavioral_traits">Behavioral Traits</label>
                        <textarea id="behavioral_traits" name="behavioral_traits"><%= pet.behavioralTraits != null ? pet.behavioralTraits : "" %></textarea>
                        <div class="help-text">e.g., Playful, Loyal, Energetic, Calm, etc.</div>
                    </div>
                    
                    <div class="form-group full-width-3">
                        <label for="trained_for">Training</label>
                        <textarea id="trained_for" name="trained_for"><%= pet.trainedFor != null ? pet.trainedFor : "" %></textarea>
                        <div class="help-text">What commands or behaviors is the pet trained for?</div>
                    </div>
                </div>

                <!-- Care Information -->
                <div class="section-header">Care Information</div>
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="preferable_food">Preferable Food</label>
                        <textarea id="preferable_food" name="preferable_food"><%= pet.preferableFood != null ? pet.preferableFood : "" %></textarea>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="dietary_restrictions">Dietary Restrictions</label>
                        <textarea id="dietary_restrictions" name="dietary_restrictions"><%= pet.dietaryRestrictions != null ? pet.dietaryRestrictions : "" %></textarea>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="daily_routine">Daily Routine</label>
                        <textarea id="daily_routine" name="daily_routine"><%= pet.dailyRoutine != null ? pet.dailyRoutine : "" %></textarea>
                        <div class="help-text">Describe the pet's typical daily routine</div>
                    </div>
                </div>

                <!-- Previous Owner Information -->
                <div class="section-header">Previous Owner Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="previous_owner_name">Previous Owner Name</label>
                        <input type="text" id="previous_owner_name" name="previous_owner_name" value="<%= pet.previousOwnerName != null ? pet.previousOwnerName : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="contact_no">Contact Number</label>
                        <input type="tel" id="contact_no" name="contact_no" value="<%= pet.contactNo != null ? pet.contactNo : "" %>">
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="reason_for_rehoming">Reason for Rehoming</label>
                        <textarea id="reason_for_rehoming" name="reason_for_rehoming"><%= pet.reasonForRehoming != null ? pet.reasonForRehoming : "" %></textarea>
                    </div>
                </div>

                <!-- Pet Story and Description -->
                <div class="section-header">Pet Story & Description</div>
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="story">Pet's Story</label>
                        <textarea id="story" name="story" style="min-height: 120px;"><%= pet.story != null ? pet.story : "" %></textarea>
                        <div class="help-text">Tell the pet's story in their own "voice" - this helps potential adopters connect</div>
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="description">General Description</label>
                        <textarea id="description" name="description" style="min-height: 120px;"><%= pet.description != null ? pet.description : "" %></textarea>
                    </div>
                </div>
                
                <div class="form-buttons">
                    <a href="manage_pets.jsp" class="cancel-btn">Cancel</a>
                    <button type="submit" class="save-btn">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>