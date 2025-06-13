<%-- 
    Document   : pet_info
    Created on : 8 Jun 2025, 7:39:00 pm
    Author     : RUSHANG MAHALE
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@include file="admin_side.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        session.setAttribute("redirectUrl", request.getRequestURI() + "?" + request.getQueryString());
        response.sendRedirect("login.jsp");
        return;
    }

    String petIdParam = request.getParameter("id");
    if (petIdParam == null || petIdParam.trim().isEmpty()) {
        out.println("<p>Error: No pet ID provided.</p>");
        return;
    }

    int petId;
    try {
        petId = Integer.parseInt(petIdParam);
    } catch (NumberFormatException e) {
        out.println("<p>Error: Invalid pet ID format.</p>");
        return;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        String query = "SELECT pet_id, name, image, species, breed, age, gender, status, description, " +
                       "weight, height, color, neutered_or_spayed, vaccinated, good_with_pets, good_with_kids, " +
                       "good_with_strangers, behavioral_traits, health_status, medication, preferable_food, " +
                       "special_needs, daily_routine, trained_for, dietary_restrictions, previous_owner_name, " +
                       "contact_no, story, reason_for_rehoming " +
                       "FROM pets WHERE pet_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, petId);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            out.println("<p>Error: Pet not found.</p>");
            return;
        }

        // Extract pet details
        String petName = rs.getString("name");
        String image = rs.getString("image");
        String species = rs.getString("species");
        String breed = rs.getString("breed");
        int age = rs.getInt("age");
        String gender = rs.getString("gender");
        String status = rs.getString("status");
        String description = rs.getString("description");
        double weight = rs.getDouble("weight");
        double height = rs.getDouble("height");
        String color = rs.getString("color");
        String neuteredOrSpayed = rs.getString("neutered_or_spayed");
        String vaccinated = rs.getString("vaccinated");
        String goodWithPets = rs.getString("good_with_pets");
        String goodWithKids = rs.getString("good_with_kids");
        String goodWithStrangers = rs.getString("good_with_strangers");
        String behavioralTraits = rs.getString("behavioral_traits");
        String healthStatus = rs.getString("health_status");
        String medication = rs.getString("medication");
        String preferableFood = rs.getString("preferable_food");
        String specialNeeds = rs.getString("special_needs");
        String dailyRoutine = rs.getString("daily_routine");
        String trainedFor = rs.getString("trained_for");
        String dietaryRestrictions = rs.getString("dietary_restrictions");
        String previousOwnerName = rs.getString("previous_owner_name");
        String contactNo = rs.getString("contact_no");
        String story = rs.getString("story");
        String reasonForRehoming = rs.getString("reason_for_rehoming");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Pet Details</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5ff;
            margin: 0;
            padding-top: 80px;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .pet-image {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }

        .pet-image-placeholder {
            width: 100%;
            max-height: 400px;
            border-radius: 10px;
            background-color: #e0e7ff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 16px;
            font-weight: bold;
        }

        h1, h2 {
            color: #42a5f5; /* Match --pet-color from admin_view_page.jsp */
            margin-bottom: 20px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px 30px;
        }

        .info-grid p {
            margin: 5px 0;
            font-size: 16px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4285f4;
            color: white;
            text-decoration: none;
            font-weight: bold;
            border-radius: 6px;
            text-align: center;
        }

        .btn:hover {
            background-color: #1a4c96;
        }
    </style>
</head>
<body>
<div class="container">
<%
        if (image != null && !image.trim().isEmpty()) {
%>
    <img src="<%= request.getContextPath() %>/pet_image/<%= image %>" alt="<%= petName %>'s Photo" class="pet-image">
<%      } else { %>
    <div class="pet-image-placeholder">No Photo Available</div>
<%      } %>
    <h1><%= petName %> - <%= species != null ? species : "Pet" %></h1>
    <div class="info-grid">
        <p><strong>Breed:</strong> <%= breed != null ? breed : "Not specified" %></p>
        <p><strong>Age:</strong> <%= age %> years</p>
        <p><strong>Gender:</strong> <%= gender != null ? gender : "Not specified" %></p>
        <p><strong>Color:</strong> <%= color != null ? color : "Not specified" %></p>
        <p><strong>Weight:</strong> <%= weight %> kg</p>
        <p><strong>Height:</strong> <%= height %> cm</p>
        <p><strong>Status:</strong> <%= status != null ? status : "Not specified" %></p>
        <p><strong>Description:</strong> <%= description != null && !description.trim().isEmpty() ? description : "Not provided" %></p>
    </div>
    <br>

    <h2>Health & Medical Information</h2>
    <div class="info-grid">
        <p><strong>Vaccinated:</strong> <%= vaccinated != null ? vaccinated : "Not specified" %></p>
        <p><strong>Neutered/Spayed:</strong> <%= neuteredOrSpayed != null ? neuteredOrSpayed : "Not specified" %></p>
        <p><strong>Health Status:</strong> <%= healthStatus != null && !healthStatus.trim().isEmpty() ? healthStatus : "Not provided" %></p>
        <p><strong>Medications needed (if any):</strong> <%= medication != null && !medication.trim().isEmpty() ? medication : "None" %></p>
        <p><strong>Special Needs:</strong> <%= specialNeeds != null && !specialNeeds.trim().isEmpty() ? specialNeeds : "None" %></p>
    </div>
    <br>

    <h2>Behavior & Compatibility</h2>
    <div class="info-grid">
        <p><strong>Good with Pets:</strong> <%= goodWithPets != null ? goodWithPets : "Unknown" %></p>
        <p><strong>Good with Kids:</strong> <%= goodWithKids != null ? goodWithKids : "Unknown" %></p>
        <p><strong>Good with Strangers:</strong> <%= goodWithStrangers != null ? goodWithStrangers : "Unknown" %></p>
        <p><strong>Behavioral Traits:</strong> <%= behavioralTraits != null && !behavioralTraits.trim().isEmpty() ? behavioralTraits : "Not specified" %></p>
        <p><strong>Trained For:</strong> <%= trainedFor != null && !trainedFor.trim().isEmpty() ? trainedFor : "Not specified" %></p>
    </div>
    <br>

    <h2>Care & Routine</h2>
    <div class="info-grid">
        <p><strong>Preferable Food:</strong> <%= preferableFood != null && !preferableFood.trim().isEmpty() ? preferableFood : "Not specified" %></p>
        <p><strong>Dietary Restrictions:</strong> <%= dietaryRestrictions != null && !dietaryRestrictions.trim().isEmpty() ? dietaryRestrictions : "None" %></p>
        <p><strong>Daily Routine:</strong> <%= dailyRoutine != null && !dailyRoutine.trim().isEmpty() ? dailyRoutine : "Not specified" %></p>
    </div>
    <br>

    <h2>Reason for Rehoming</h2>
    <p><%= reasonForRehoming != null && !reasonForRehoming.trim().isEmpty() ? reasonForRehoming : "Not provided" %></p>
    <br>

    <h2>My Story</h2>
    <p><%= story != null && !story.trim().isEmpty() ? story : "Not provided" %></p>
    <br>

    <h2>Previous Owner Information</h2>
    <div class="info-grid">
        <p><strong>Previous Owner:</strong> <%= previousOwnerName != null && !previousOwnerName.trim().isEmpty() ? previousOwnerName : "Not provided" %></p>
        <p><strong>Contact No:</strong> <%= contactNo != null && !contactNo.trim().isEmpty() ? contactNo : "Not provided" %></p>
    </div>
    <br>

    <div class="button-group">
        <a href="<%= request.getContextPath() %>/admin_view_page.jsp" class="btn">← Back</a>
        <a href="<%= request.getContextPath() %>/edit_pet.jsp?id=<%= petId %>" class="btn">Edit</a>
    </div>
</div>
</body>
</html>
<%
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
    }
%>