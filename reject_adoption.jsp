<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<%
    String sessionUser = (String) session.getAttribute("username");
    String sessionRole = (String) session.getAttribute("role");

    if (sessionUser == null || sessionRole == null || !sessionRole.equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String requestId = request.getParameter("id");
    if (requestId != null && !requestId.isEmpty()) {
        int id = Integer.parseInt(requestId);
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            String sql = "UPDATE AdoptionRequests SET status = 'Rejected' WHERE request_id = " + id;
            int rowsAffected = stmt.executeUpdate(sql);
            if (rowsAffected > 0) {
                out.println("<script>alert('Adoption Request Rejected.'); window.location='view_adaption_request.jsp';</script>");
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
