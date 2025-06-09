<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Adopter Profile</title>
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

        /* Navigation Bar */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background-color: #2c3e50;
            padding: 15px 20px;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            color: white;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .nav-links a:hover {
            background-color: #34495e;
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
            min-height: 100px;
        }

        .full-width {
            grid-column: span 2;
        }

        .required {
            color: #e74c3c;
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
            display: none;
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

        /* Section Headers */
        .section-header {
            grid-column: span 2;
            margin-top: 20px;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
        }

        .section-header:first-child {
            margin-top: 0;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: span 1;
            }

            .section-header {
                grid-column: span 1;
            }

            .form-buttons {
                flex-direction: column;
            }

            .nav-links {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-content">
            <a href="#" class="nav-brand">Pet Adoption</a>
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Pets</a>
                <a href="#">Profile</a>
                <a href="#">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <h1 class="page-title">Edit Adopter Profile</h1>

            <!-- Alert Messages -->
            <div id="alert-message" class="alert">
                <span id="alert-text"></span>
            </div>

            <form id="adopter-form">
                <div class="form-grid">
                    <!-- Personal Information Section -->
                    <div class="section-header">Personal Information</div>
                    
                    <!-- Username -->
                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text" id="username" name="username" required>
                    </div>

                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullname">Full Name <span class="required">*</span></label>
                        <input type="text" id="fullname" name="fullname" required>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone">
                    </div>

                    <!-- City -->
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city">
                    </div>

                    <!-- Pincode -->
                    <div class="form-group">
                        <label for="pincode">Pincode</label>
                        <input type="text" id="pincode" name="pincode" maxlength="6">
                    </div>

                    <!-- Address -->
                    <div class="form-group full-width">
                        <label for="address">Address</label>
                        <textarea id="address" name="address"></textarea>
                    </div>

                    <!-- Adoption Information Section -->
                    <div class="section-header">Adoption Information</div>

                    <!-- Has Pets -->
                    <div class="form-group">
                        <label for="has_pets">Do you currently have pets? <span class="required">*</span></label>
                        <select id="has_pets" name="has_pets" required>
                            <option value="">Select an option</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <!-- Number of Pets -->
                    <div class="form-group">
                        <label for="no_of_pets">Number of Pets (if yes)</label>
                        <input type="number" id="no_of_pets" name="no_of_pets" min="0" max="50">
                    </div>

                    <!-- Family Members -->
                    <div class="form-group">
                        <label for="no_of_family_members">Number of Family Members <span class="required">*</span></label>
                        <input type="number" id="no_of_family_members" name="no_of_family_members" min="1" max="20" required>
                    </div>

                    <!-- Has Allergy -->
                    <div class="form-group">
                        <label for="has_any_allergy">Do you have any allergies? <span class="required">*</span></label>
                        <select id="has_any_allergy" name="has_any_allergy" required>
                            <option value="">Select an option</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <!-- Allergy Details -->
                    <div class="form-group full-width">
                        <label for="allergy_details">Allergy Details (if yes)</label>
                        <textarea id="allergy_details" name="allergy_details" placeholder="Please describe your allergies..."></textarea>
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="form-buttons">
                    <button type="button" class="cancel-btn" onclick="window.history.back()">Cancel</button>
                    <button type="submit" class="save-btn">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>