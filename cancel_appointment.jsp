<%-- 
    Document   : cancel_appointment
    Created on : 10 Jun 2025, 7:34:39 am
    Author     : RUSHANG MAHALE
--%>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_conn.jsp" %>
<%
    String appointmentId = request.getParameter("id");
    String remarks = request.getParameter("remarks");
    if (appointmentId != null && !appointmentId.isEmpty()) {
        PreparedStatement ps = null;
        try {
            String sql = "UPDATE Appointments SET status = ?, remarks = ? WHERE appointment_id = ? AND status = 'Pending'";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "Cancelled");
            ps.setString(2, remarks != null && !remarks.trim().isEmpty() ? remarks : null);
            ps.setInt(3, Integer.parseInt(appointmentId));
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Appointment Cancelled.'); window.location='manage_appointment.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to cancel appointment. It may no longer be pending.'); window.location='manage_appointment.jsp';</script>");
            }
        } catch (SQLException | NumberFormatException e) {
            out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.location='manage_appointment.jsp';</script>");
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    } else {
        out.println("<script>alert('Invalid Appointment ID.'); window.location='manage_appointment.jsp';</script>");
    }
%>