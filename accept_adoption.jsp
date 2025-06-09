<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<%
    String requestId = request.getParameter("id");
    if (requestId != null && !requestId.isEmpty()) {
        int id = Integer.parseInt(requestId);
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            String sql = "UPDATE AdoptionRequests SET status = 'Accepted' WHERE request_id = " + id;
//            String query = "select pet_id from AdoptionRequests where request_id=" +id;
//            
//            int row = stmt.executeUpdate(query);
//            if(row>0){
//                
//            
//            String sql1 = "update Pets set status='Adopted' where "
            int rowsAffected = stmt.executeUpdate(sql);
            if (rowsAffected > 0) {
                out.println("<script>alert('Adoption Request Approved.'); window.location='view_adaption_request.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to update Adoption Request.'); window.location='view_adaption_request.jsp';</script>");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    } else {
        out.println("<script>alert('Invalid Request ID.'); window.location='view_adaption_request.jsp';</script>");
    }
%>
