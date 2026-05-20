<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${not empty pageTitle ? pageTitle.concat(' – Satasat') : 'Satasat – Teach What You Know'}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,800;1,400;1,600&display=swap" rel="stylesheet">
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">
            <div class="brand-icon"><i class="fas fa-exchange-alt"></i></div>
            <span class="brand-name">Satasat</span>
        </a>

        <div class="nav-links" id="navLinks">
            <a href="${pageContext.request.contextPath}/browse" class="nav-link">
                <i class="fas fa-search"></i> Browse Skills
            </a>
            <a href="${pageContext.request.contextPath}/about" class="nav-link">About</a>

            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <c:choose>
                        <c:when test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                                <i class="fas fa-tachometer-alt"></i> Admin Panel
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/user/wishlist" class="nav-link nav-icon-link" title="Wishlist">
                                <i class="fas fa-heart"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <div class="nav-user-menu">
                        <button class="nav-avatar-btn" onclick="toggleDropdown(event)">
                            <img src="${pageContext.request.contextPath}/images/profiles/${sessionScope.loggedInUser.profileImage}"
                                 alt="Profile" class="nav-avatar"
                                 onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                            <span><c:out value="${sessionScope.loggedInUser.firstName}"/></span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="user-dropdown" id="userDropdown">
                            <a href="${pageContext.request.contextPath}/user/profile">
                                <i class="fas fa-user"></i> My Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/user/skills">
                                <i class="fas fa-star"></i> My Skills
                            </a>
                            <a href="${pageContext.request.contextPath}/user/requests">
                                <i class="fas fa-handshake"></i> Requests
                            </a>
                            <a href="${pageContext.request.contextPath}/user/sessions">
                                <i class="fas fa-calendar-alt"></i> Sessions
                            </a>
                            <div class="dd-divider"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="dd-logout">
                                <i class="fas fa-sign-out-alt"></i> Log Out
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"    class="btn-outline-sm">Log In</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-primary-sm">Sign Up Free</a>
                </c:otherwise>
            </c:choose>
        </div>

        <button class="hamburger" onclick="toggleNav()" aria-label="Menu">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>

<div id="toastBox" class="toast-box"></div>
