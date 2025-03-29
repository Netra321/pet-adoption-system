/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class login_servlet extends HttpServlet {
        String url = "jdbc:mysql://localhost:3306/db1";
        String usernamee = "root";
        String passwordd = "Netra@432";
        String query = "select * from users where username =? and password=?";
        boolean isValid = false;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet login_servlet</title>");
            out.println("</head>");
            out.println("<body>");
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url,usernamee,passwordd);
            
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1,username);
            ps.setString(2,password);
           
            out.println("<body>");
            try(ResultSet rs = ps.executeQuery()){
            /* TODO output your page here. You may use following sample code. */
            isValid = rs.next();
            if(isValid){
            out.println("<h1>Servlet NewServlet at " + request.getContextPath() + "</h1>");
            out.println("welcome "+username+" password "+password);
            }
            else{
            out.println("username and password doesnot match");
            response.sendRedirect("index.jsp?error=Incorrect Username or Password");
            }
            }
            }catch(Exception e){
                out.println("error : "+e);
            }
            out.println("</html>");
        }
    }
}