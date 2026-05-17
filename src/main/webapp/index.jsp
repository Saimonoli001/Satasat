<%-- Redirect root to /home --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<% response.sendRedirect(request.getContextPath() + "/home"); %>
