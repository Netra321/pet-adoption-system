<%-- 
    Document   : feedback.jsp
    Created on : Jun 3, 2025, 5:29:13 PM
    Author     : admin
--%>

<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.sql.*" %>
<%@include file="db_conn.jsp" %>
<%@include file="navigation_page.html" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback - Pet Management System</title>
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

        .navbar .logo {
            font-size: 24px;
            font-weight: bold;
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

        /* Form Layout */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
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
        }

        .form-group textarea {
            resize: vertical;
            min-height: 150px;
        }

        .full-width {
            grid-column: span 2;
        }

        /* Rating Stars */
        .rating-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .star-rating {
            display: flex;
            gap: 5px;
        }

        .star {
            font-size: 24px;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .star.active,
        .star:hover {
            color: #f1c40f;
        }

        .rating-text {
            margin-left: 10px;
            font-weight: 500;
            color: #2c3e50;
        }

        /* Form Buttons */
        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
        }

        .save-btn, .cancel-btn {
            padding: 12px 25px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
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

        /* Feedback Type Description */
        .feedback-description {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }

        .feedback-description h4 {
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .feedback-description p {
            color: #555;
            font-size: 14px;
            line-height: 1.4;
        }
    </style>
</head>
<body>
    <%@include file="navigation_page.html"%>

    <div class="container">
        <div class="form-container">
            <h1 class="page-title">Share Your Feedback</h1>

            <!-- Alert Messages (will be shown after form submission) -->
            <div id="alert-container"></div>

            <!-- Feedback Type Description -->
            <div class="feedback-description">
                <h4>Help Us Improve</h4>
                <p>Your feedback is valuable to us! Share your experience, suggestions, or testimonials to help us serve you better. You can provide general feedback about our services or share a testimonial about your experience with our pet management system.</p>
            </div>

            <form id="feedbackForm" method="POST" action="feedback.jsp">
                <div class="form-grid">
                    <!-- Feedback Type -->
                    <div class="form-group">
                        <label for="feedbackType">Feedback Type:</label>
                        <select id="feedbackType" name="feedback_type" required>
                            <option value="">Select Feedback Type</option>
                            <option value="general">General Feedback</option>
                            <option value="testimonial">Testimonial</option>
                        </select>
                    </div>

                    <!-- Rating -->
                    <div class="form-group">
                        <label>Rating (Optional):</label>
                        <div class="rating-container">
                            <div class="star-rating" id="starRating">
                                <span class="star" data-rating="1">★</span>
                                <span class="star" data-rating="2">★</span>
                                <span class="star" data-rating="3">★</span>
                                <span class="star" data-rating="4">★</span>
                                <span class="star" data-rating="5">★</span>
                            </div>
                            <span class="rating-text" id="ratingText">Click to rate</span>
                        </div>
                        <input type="hidden" id="ratingValue" name="rating" value="">
                    </div>

                    <!-- Feedback Text -->
                    <div class="form-group full-width">
                        <label for="feedbackText">Your Feedback:</label>
                        <textarea id="feedbackText" name="feedback_text" placeholder="Please share your thoughts, suggestions, or experience with our pet management system..." required></textarea>
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="form-buttons">
                    <button type="button" class="cancel-btn" onclick="clearForm()">Clear</button>
                    <button type="submit" class="save-btn">Submit Feedback</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Star Rating Functionality
        const stars = document.querySelectorAll('.star');
        const ratingText = document.getElementById('ratingText');
        const ratingValue = document.getElementById('ratingValue');
        let currentRating = 0;

        const ratingLabels = {
            1: 'Poor',
            2: 'Fair', 
            3: 'Good',
            4: 'Very Good',
            5: 'Excellent'
        };

        stars.forEach(star => {
            star.addEventListener('mouseover', function() {
                const rating = parseInt(this.dataset.rating);
                highlightStars(rating);
                ratingText.textContent = ratingLabels[rating];
            });

            star.addEventListener('mouseout', function() {
                highlightStars(currentRating);
                ratingText.textContent = currentRating ? ratingLabels[currentRating] : 'Click to rate';
            });

            star.addEventListener('click', function() {
                currentRating = parseInt(this.dataset.rating);
                ratingValue.value = currentRating;
                highlightStars(currentRating);
                ratingText.textContent = ratingLabels[currentRating];
            });
        });

        function highlightStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
        }

        // Form Functions
        function clearForm() {
            document.getElementById('feedbackForm').reset();
            currentRating = 0;
            ratingValue.value = '';
            ratingText.textContent = 'Click to rate';
            highlightStars(0);
            document.getElementById('alert-container').innerHTML = '';
        }

        // Form Submission Handler
        document.getElementById('feedbackForm').addEventListener('submit', function(e) {
            // Don't prevent default - let it submit to JSP
            const formData = new FormData(this);
            const feedbackType = formData.get('feedback_type');
            const feedbackText = formData.get('feedback_text');
            
            if (!feedbackType || !feedbackText.trim()) {
                e.preventDefault();
                showAlert('Please fill in all required fields.', 'error');
                return;
            }
        });

        function showAlert(message, type) {
            const alertContainer = document.getElementById('alert-container');
            const alertClass = type === 'success' ? 'alert-success' : 'alert-error';
            
            alertContainer.innerHTML = `
                <div class="alert ${alertClass}">
                    ${message}
                </div>
            `;
            
            // Auto-hide alert after 5 seconds
            setTimeout(() => {
                alertContainer.innerHTML = '';
            }, 5000);
        }

        // Update feedback description based on type selection
        document.getElementById('feedbackType').addEventListener('change', function() {
            const descriptionDiv = document.querySelector('.feedback-description');
            const h4 = descriptionDiv.querySelector('h4');
            const p = descriptionDiv.querySelector('p');
            
            if (this.value === 'testimonial') {
                h4.textContent = 'Share Your Testimonial';
                p.textContent = 'We would love to hear about your positive experience with our pet management system. Your testimonial may be featured on our website to help other pet owners discover our services.';
            } else if (this.value === 'general') {
                h4.textContent = 'General Feedback';
                p.textContent = 'Share your thoughts, suggestions, or concerns about our pet management system. Your feedback helps us improve our services and better serve the pet owner community.';
            } else {
                h4.textContent = 'Help Us Improve';
                p.textContent = 'Your feedback is valuable to us! Share your experience, suggestions, or testimonials to help us serve you better. You can provide general feedback about our services or share a testimonial about your experience with our pet management system.';
            }
        });
    </script>
</body>
</html>
