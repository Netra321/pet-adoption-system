<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    String url = "jdbc:mysql://localhost:3306/pet_adoption_system"; 
    String username = "root"; 
    String password = "Netra@432";    

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
    } catch (Exception e) {
        out.println("Database connection failed: " + e.getMessage());
    }
%>