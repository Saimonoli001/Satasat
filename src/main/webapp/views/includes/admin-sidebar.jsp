<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<aside class="dash-sidebar admin-dark">
    <div class="sidebar-user">
        <img src="${pageContext.request.contextPath}/images/profiles/${sessionScope.loggedInUser.profileImage}"
             class="sidebar-avatar" alt="admin"
             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
        <h3><c:out value="${sessionScope.loggedInUser.fullName}"/></h3>
        <span class="admin-pill"><i class="fas fa-shield-alt"></i> Administrator</span>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="${activePage eq 'dashboard' ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users"
           class="${activePage eq 'users' ? 'active' : ''}">
            <i class="fas fa-users"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories"
           class="${activePage eq 'categories' ? 'active' : ''}">
            <i class="fas fa-tags"></i> Categories
        </a>
        <a href="${pageContext.request.contextPath}/admin/analytics"
           class="${activePage eq 'analytics' ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i> Analytics
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports"
           class="${activePage eq 'reports' ? 'active' : ''}">
            <i class="fas fa-exclamation-triangle"></i> Support Tickets
        </a>
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">
            <i class="fas fa-sign-out-alt"></i> Log Out
        </a>
    </nav>
</aside>
