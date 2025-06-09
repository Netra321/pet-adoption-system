<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@include file="navigation_page.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    int petId = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = null;
    ResultSet rs = null;
    String name = "";
    String breed = "";
    
    String query = "SELECT name,breed FROM Pets WHERE pet_id = ?";
    ps = conn.prepareStatement(query);
    ps.setInt(1, petId);
    rs = ps.executeQuery();
    if (rs.next()) {
        name = rs.getString("name");
        breed = rs.getString("breed");
    }
    
    String fullname = "";
    String email = "";
    String phone = "";
    
    String query2 = "select fullname, email, phone from Users where username = ?";
    ps = conn.prepareStatement(query2);
    ps.setString(1,sessionUser);
    rs = ps.executeQuery();
    int userId = -1;
    if (rs.next()) {
        fullname = rs.getString("fullname");
        email = rs.getString("email");
        phone = rs.getString("phone");
    }
    
    String query3 = "select user_id from Users where username = ?";
    ps = conn.prepareStatement(query3);
    ps.setString(1,sessionUser);
    rs = ps.executeQuery();
    if (rs.next()) {
        userId = rs.getInt("user_id");
    }
%>
<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String message = request.getParameter("message");
    
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String request_date = now.format(formatter);

        String insertQuery = "INSERT INTO AdoptionRequests (pet_id, adopter_id, request_date, reason_for_adoption) VALUES (?, ?, ?, ?)";
        try (PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
            insertPs.setInt(1, petId);
            insertPs.setInt(2, userId);
            insertPs.setString(3, request_date);
            insertPs.setString(4, message);
        
            insertPs.executeUpdate();
            response.sendRedirect("adoption_status.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Send Adoption Request</title>
    <style>

        :root {
            --primary: #6C63FF;
            --primary-light: #8A84FF;
            --primary-dark: #5A52E0;
            --accent: #FF9A8B;
            --text: #2D3748;
            --text-light: #718096;
            --bg: #F7FAFC;
            --white: #FFFFFF;
            --border-radius: 12px;
            --shadow: 0 10px 30px rgba(108, 99, 255, 0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg);
            background-image: linear-gradient(135deg, #F7FAFC 0%, #E6FFFA 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            color: var(--text);
        }

        .container {
            width: 100%;
            max-width: 550px;
        }

        h2 {
            text-align: center;
            color: var(--primary-dark);
            margin-bottom: 30px;
            font-weight: 600;
            font-size: 32px;
        }

        form {
            background-color: var(--white);
            padding: 35px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        form::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--accent) 100%);
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text);
            font-size: 15px;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #E2E8F0;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 15px;
            color: var(--text);
            transition: all 0.3s ease;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-light);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.2);
        }

        textarea {
            resize: vertical;
            min-height: 120px;
        }

        .button {
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            margin-top: 10px;
            box-shadow: 0 4px 12px rgba(108, 99, 255, 0.25);
        }

        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(108, 99, 255, 0.35);
        }

        .button:active {
            transform: translateY(0);
            box-shadow: 0 4px 8px rgba(108, 99, 255, 0.25);
        }

        .footer-text {
            text-align: center;
            margin-top: 20px;
            color: var(--text-light);
            font-size: 14px;
        }

        /* Required field indicator */
        .required::after {
            content: "*";
            color: #E53E3E;
            margin-left: 4px;
        }

        /* Responsive adjustments */
        @media (max-width: 600px) {
            form {
                padding: 25px;
            }

            h2 {
                font-size: 28px;
            }
        }

    </style>
</head>
<body>
<div class="container">
    <h2>Pet Adoption Request</h2>
    <form action="" method="post">
        <div class="form-group">
            <label for="fullname">Your Name</label>
            <input type="text" id="fullname" value="<%=fullname%>" readonly style="cursor: not-allowed;">
        </div>

        <div class="form-group">
            <label for="email">Your Email</label>
            <input type="email" id="email" value="<%=email%>" readonly style="cursor: not-allowed;">
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" value="<%=phone%>" required>
        </div>


        <div class="form-group">
            <label for="name">Pet Name</label>
            <input type="text" name="name" value="<%=name %>" readonly style="cursor: not-allowed;">
        </div>

        <div class="form-group">
            <label for="breed">Breed</label>
            <input type="text" name="breed" value="<%=breed %>" readonly style="cursor: not-allowed;">
        </div>

        <div class="form-group">
            <label for="message" class="required">Why do you want to adopt this pet?</label>
            <textarea id="message" name="message" placeholder="Tell us about your home, lifestyle, and why you'd be a great pet parent..." required></textarea>
        </div>

        <div class="form-group">
            <label for="ownedPets">Have you owned pets before?</label>
            <select id="ownedPets" name="ownedPets" required="">
                <option value="">Please select</option>
                <option value="yes">Yes</option>
                <option value="no">No</option>
            </select>
        </div>
    
        <button type="submit" class="button">Send Adoption Request</button>
    </form>
    <div class="footer-text">
        Thank you for considering adoption! We'll review your application and contact you soon.
    </div>
</div>
</body>
</html>