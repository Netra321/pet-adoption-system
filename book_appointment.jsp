<%-- 
    Document   : book_appointment
    Created on : May 31, 2025, 7:34:12 PM
    Author     : admin
--%>

<%@ page import="java.sql.*, java.time.*, java.time.format.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@ include file="navigation_page.html" %>

<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%
    String petIdParam = request.getParameter("pet_id");
    if (petIdParam == null || petIdParam.trim().isEmpty()) {
        response.sendRedirect("adoption_status.jsp");
        return;
    }
    
    int petId = Integer.parseInt(petIdParam);
    int userId = 0;
    String msg = "";
    String msgType = "error"; // success or error
    String petName = "";

    // Get user ID and pet name
    try {
        // Get user ID
        String userSql = "SELECT user_id FROM Users WHERE username = ?";
        try (PreparedStatement ps = conn.prepareStatement(userSql)) {
            ps.setString(1, sessionUser); // Fixed: was 'username', should be 'sessionUser'
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("user_id");
            }
            rs.close();
        }
        
        // Get pet name
        String petSql = "SELECT name FROM Pets WHERE pet_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(petSql)) {
            ps.setInt(1, petId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                petName = rs.getString("name");
            }
            rs.close();
        }
    } catch (SQLException e) {
        msg = "Error retrieving information: " + e.getMessage();
        e.printStackTrace();
    }

    boolean submitted = "POST".equalsIgnoreCase(request.getMethod());
    boolean valid = true;

    if (submitted && userId > 0) {
        String appointmentDate = request.getParameter("appointment_date");
        String appointmentTime = request.getParameter("appointment_time");
        String meetingNumberParam = request.getParameter("meeting_number");
        String remarks = request.getParameter("remarks");

        if (appointmentDate != null && appointmentTime != null && meetingNumberParam != null) {
            try {
                int meetingNumber = Integer.parseInt(meetingNumberParam);
                LocalDate today = LocalDate.now();
                LocalDate selectedDate = LocalDate.parse(appointmentDate);
                LocalTime selectedTime = LocalTime.parse(appointmentTime);
                LocalTime start = LocalTime.of(9, 0);
                LocalTime end = LocalTime.of(17, 0);

                // Validation
                if (selectedDate.isBefore(today)) {
                    msg = "Appointment date must be today or in the future.";
                    valid = false;
                } else if (selectedTime.isBefore(start) || selectedTime.isAfter(end)) {
                    msg = "Appointment time must be between 09:00 and 17:00.";
                    valid = false;
                } else {
                    // Check if user already has appointment for this meeting number with this pet
                    String checkSql = "SELECT COUNT(*) as count FROM Appointments WHERE user_id = ? AND pet_id = ? AND meeting_number = ?";
                    boolean appointmentExists = false;
                    
                    try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                        checkPs.setInt(1, userId);
                        checkPs.setInt(2, petId);
                        checkPs.setInt(3, meetingNumber);
                        ResultSet checkRs = checkPs.executeQuery();
                        if (checkRs.next() && checkRs.getInt("count") > 0) {
                            appointmentExists = true;
                        }
                        checkRs.close();
                    }
                    
                    if (appointmentExists) {
                        msg = "You already have an appointment scheduled for meeting " + meetingNumber + " with this pet.";
                        valid = false;
                    } else {
                        // Check if time slot is available
                        String slotCheckSql = "SELECT COUNT(*) as count FROM Appointments WHERE appointment_date = ? AND appointment_time = ? AND status NOT IN ('Cancelled', 'Rejected')";
                        boolean slotAvailable = true;
                        
                        try (PreparedStatement slotPs = conn.prepareStatement(slotCheckSql)) {
                            slotPs.setString(1, appointmentDate);
                            slotPs.setString(2, appointmentTime);
                            ResultSet slotRs = slotPs.executeQuery();
                            if (slotRs.next() && slotRs.getInt("count") > 0) {
                                slotAvailable = false;
                            }
                            slotRs.close();
                        }
                        
                        if (!slotAvailable) {
                            msg = "This time slot is already booked. Please choose a different time.";
                            valid = false;
                        } else {
                            // Insert appointment
                            String insertSql = "INSERT INTO Appointments (user_id, pet_id, appointment_date, appointment_time, meeting_number, status, remarks) VALUES (?, ?, ?, ?, ?, 'Pending', ?)";
                            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                                insertPs.setInt(1, userId);
                                insertPs.setInt(2, petId);
                                insertPs.setString(3, appointmentDate);
                                insertPs.setString(4, appointmentTime);
                                insertPs.setInt(5, meetingNumber);
                                insertPs.setString(6, (remarks != null && !remarks.trim().isEmpty()) ? remarks : null);
                                
                                int rows = insertPs.executeUpdate();
                                if (rows > 0) {
                                    msg = "Appointment booked successfully! Your appointment is pending approval.";
                                    msgType = "success";
                                } else {
                                    msg = "Failed to book appointment. Please try again.";
                                    valid = false;
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                msg = "Error processing appointment: " + e.getMessage();
                valid = false;
                e.printStackTrace();
            }
        } else {
            msg = "Please fill in all required fields.";
            valid = false;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Pet Adoption</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /*background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);*/
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            padding: 30px;
            text-align: center;
            color: white;
        }

        .header h2 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .header .pet-info {
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 25px;
            display: inline-block;
            font-size: 16px;
        }

        .content {
            padding: 40px;
        }

        .message {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 500;
            text-align: center;
            animation: fadeIn 0.5s ease-in;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-control:focus {
            outline: none;
            border-color: #4facfe;
            background: white;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }

        .btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .back-link a:hover {
            color: #764ba2;
            transform: translateX(-5px);
        }

        .success-container {
            text-align: center;
            padding: 40px 20px;
        }

        .success-icon {
            font-size: 60px;
            color: #28a745;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .success-text {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }

        .time-slot {
            padding: 10px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .time-slot:hover {
            border-color: #4facfe;
            background: #e3f2fd;
        }

        .time-slot.selected {
            border-color: #4facfe;
            background: #4facfe;
            color: white;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .header {
                padding: 20px;
            }
            
            .content {
                padding: 25px;
            }
            
            .header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📅 Book Appointment</h2>
            <% if (!petName.isEmpty()) { %>
                <div class="pet-info"> Meeting with <%= petName %></div>
            <% } %>
        </div>

        <div class="content">
            <% if (!msg.isEmpty()) { %>
                <div class="message <%= msgType %>">
                    <%= msg %>
                </div>
            <% } %>

            <% if (submitted && valid && "success".equals(msgType)) { %>
                <div class="success-container">
                    <div class="success-icon">✅</div>
                    <div class="success-title">Appointment Requested!</div>
                    <div class="success-text">
                        Your appointment has been submitted successfully. You will receive a confirmation 
                        once our team reviews and approves your request.
                    </div>
                    <div class="back-link">
                        <a href="adoption_status.jsp">← Back to Adoption Status</a>
                    </div>
                </div>
            <% } else { %>
                <form method="post" id="appointmentForm">
                    <input type="hidden" name="pet_id" value="<%= petId %>">

                    <div class="form-group">
                        <label for="appointment_date">📅 Select Date</label>
                        <input type="date" 
                               id="appointment_date"
                               name="appointment_date" 
                               class="form-control" 
                               required 
                               min="<%= LocalDate.now() %>">
                    </div>

                    <div class="form-group">
                        <label for="appointment_time">🕐 Select Time (9:00 AM - 5:00 PM)</label>
                        <select name="appointment_time" id="appointment_time" class="form-control" required>
                            <option value="">Choose a time slot</option>
                            <option value="09:00:00">9:00 AM</option>
                            <option value="10:00:00">10:00 AM</option>
                            <option value="11:00:00">11:00 AM</option>
                            <option value="12:00:00">12:00 PM</option>
                            <option value="13:00:00">1:00 PM</option>
                            <option value="14:00:00">2:00 PM</option>
                            <option value="15:00:00">3:00 PM</option>
                            <option value="16:00:00">4:00 PM</option>
                            <option value="17:00:00">5:00 PM</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="meeting_number"> Meeting Number</label>
                        <select name="meeting_number" id="meeting_number" class="form-control" required>
                            <option value="">Select meeting number</option>
                            <option value="1">1st Meeting - Initial Introduction</option>
                            <option value="2">2nd Meeting - Final Decision</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="remarks">Additional Notes (Optional)</label>
                        <textarea name="remarks" 
                                  id="remarks" 
                                  class="form-control" 
                                  rows="4" 
                                  maxlength="255" 
                                  placeholder="Any special requests, questions, or information you'd like to share..."></textarea>
                    </div>

                    <button type="submit" class="btn">
                         Submit Appointment Request
                    </button>
                </form>

                <div class="back-link">
                    <a href="adoption_status.jsp">← Back to Adoption Status</a>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        // Set minimum date to today
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('appointment_date');
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            // Set minimum date to tomorrow to give shelter time to prepare
            const minDate = tomorrow.toISOString().split('T')[0];
            dateInput.setAttribute('min', minDate);
            
            // Disable weekends (optional)
            dateInput.addEventListener('input', function() {
                const selectedDate = new Date(this.value);
                const dayOfWeek = selectedDate.getDay();
                
                // 0 = Sunday, 6 = Saturday
                if (dayOfWeek === 0 || dayOfWeek === 6) {
                    alert('Please select a weekday (Monday - Friday) for appointments.');
                    this.value = '';
                }
            });
        });

        // Form validation
        document.getElementById('appointmentForm').addEventListener('submit', function(e) {
            const date = document.getElementById('appointment_date').value;
            const time = document.getElementById('appointment_time').value;
            const meeting = document.getElementById('meeting_number').value;
            
            if (!date || !time || !meeting) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
        });
    </script>
</body>
</html>