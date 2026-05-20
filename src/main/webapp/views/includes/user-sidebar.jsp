<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<aside class="dash-sidebar">
    <div class="sidebar-user">
        <img src="${pageContext.request.contextPath}/images/profiles/${sessionScope.loggedInUser.profileImage}"
             class="sidebar-avatar" alt="avatar"
             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
        <h3><c:out value="${sessionScope.loggedInUser.fullName}"/></h3>
        <div class="sidebar-rating">
            <i class="fas fa-star"></i>
            <fmt:formatNumber value="${sessionScope.loggedInUser.avgRating}" minFractionDigits="1" maxFractionDigits="1"/>
            (${sessionScope.loggedInUser.totalReviews} reviews)
        </div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/user/dashboard"
           class="${activePage eq 'dashboard' ? 'active' : ''}">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user/profile"
           class="${activePage eq 'profile' ? 'active' : ''}">
            <i class="fas fa-user"></i> My Profile
        </a>
        <a href="${pageContext.request.contextPath}/user/skills"
           class="${activePage eq 'skills' ? 'active' : ''}">
            <i class="fas fa-star"></i> My Skills
        </a>
        <a href="${pageContext.request.contextPath}/user/requests"
           class="${activePage eq 'requests' ? 'active' : ''}">
            <i class="fas fa-handshake"></i> Requests
            <c:if test="${not empty incoming and fn:length(incoming) > 0}">
                <span class="nav-badge">${fn:length(incoming)}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/user/sessions"
           class="${activePage eq 'sessions' ? 'active' : ''}">
            <i class="fas fa-calendar-alt"></i> Sessions
        </a>
        <a href="${pageContext.request.contextPath}/user/wishlist"
           class="${activePage eq 'wishlist' ? 'active' : ''}">
            <i class="fas fa-heart"></i> Wishlist
        </a>
        <a href="${pageContext.request.contextPath}/user/report"
           class="${activePage eq 'reports' ? 'active' : ''}">
            <i class="fas fa-exclamation-triangle"></i> Support & Help
        </a>
        <a href="${pageContext.request.contextPath}/browse">
            <i class="fas fa-search"></i> Browse Skills
        </a>
        <div class="nav-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">
            <i class="fas fa-sign-out-alt"></i> Log Out
        </a>
    </nav>
</aside>
