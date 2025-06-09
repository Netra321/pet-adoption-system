import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin_register_servlet")
public class admin_register_servlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin_register.jsp");

        if(password.length()<8){
            request.setAttribute("error","Password should be at least 8 characters long");
            dispatcher.forward(request, response);
            return;
        }
        
        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$";
        if (!password.matches(passwordPattern)) {
            request.setAttribute("error", "Password must include one uppercase letter, one lowercase letter and one number.");
            dispatcher.forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            dispatcher.forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pet_adoption_system", "root", "gj@riya01");

            PreparedStatement checkStmt = conn.prepareStatement("SELECT username FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            PreparedStatement checkStmt1 = conn.prepareStatement("SELECT email FROM users WHERE email = ?");
            checkStmt1.setString(1, email);
            ResultSet rs1 = checkStmt1.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("error", "Username already exists.");
                dispatcher.forward(request, response);
                conn.close();
                return;
            }

            if (rs1.next()) {
                request.setAttribute("error", "Email already exists.");
                dispatcher.forward(request, response);
                conn.close();
                return;
            }
            
            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO users(fullname, username, email, password, role) VALUES(?,?,?,?,?)");

            insertStmt.setString(1, fullname);
            insertStmt.setString(2, username);
            insertStmt.setString(3, email);
            
            //hash pwd
            String hashedPassword = hashPassword(password);
            insertStmt.setString(4, hashedPassword);
            insertStmt.setString(5, "Admin");
            
            int rows = insertStmt.executeUpdate();

            if (rows > 0) {
                request.setAttribute("success", "Admin added successfully! Username: " + username);
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                dispatcher.forward(request, response);
            }

            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            dispatcher.forward(request, response);
        }
    }

    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }
}