import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class view_pet_servlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder petHTML = new StringBuilder();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pet_adoption", "root", "Netra@432");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM pets");

            while(rs.next()) {
                petHTML.append("<div class='card'>")
                       .append("<img src='").append(rs.getString("imageUrl")).append("' alt='Pet Image'>")
                       .append("<h3>").append(rs.getString("name")).append("</h3>")
                       .append("<p>Breed: ").append(rs.getString("breed")).append("</p>")
                       .append("<p>Age: ").append(rs.getInt("age")).append(" years</p>")
                       .append("</div>");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch(Exception e) {
            petHTML.append("Error: ").append(e.getMessage());
        }

        request.setAttribute("petHTML", petHTML.toString());
        RequestDispatcher dispatcher = request.getRequestDispatcher("view_pet.jsp");
        dispatcher.forward(request, response);
    }
}
