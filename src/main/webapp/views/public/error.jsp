<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Error"/>
<%@ include file="../includes/header.jsp" %>
<div style="text-align:center;padding:100px 24px">
    <h1 style="font-size:5rem;font-weight:900;color:var(--primary)">Oops!</h1>
    <h2 style="margin-bottom:12px">Something went wrong</h2>
    <p style="color:var(--text-mid);margin-bottom:32px">The page you're looking for doesn't exist or an error occurred.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn-primary">Go Home</a>
</div>
<%@ include file="../includes/footer.jsp" %>
