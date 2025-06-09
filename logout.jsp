<%-- 
    Document   : logout
    Created on : Apr 23, 2025, 6:22:42 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>
