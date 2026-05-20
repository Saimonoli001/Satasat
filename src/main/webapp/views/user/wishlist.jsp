<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="My Wishlist"/>
<c:set var="activePage" value="wishlist"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar"><h1><i class="fas fa-heart"></i> My Wishlist</h1></div>

        <c:choose>
            <c:when test="${empty wishlist}">
                <div class="empty-state">
                    <i class="fas fa-heart-broken"></i>
                    <h3>Your wishlist is empty</h3>
                    <p>Browse skills and save the ones you're interested in.</p>
                    <a href="${pageContext.request.contextPath}/browse" class="btn-primary">Browse Skills</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="skills-grid">
                    <c:forEach var="sk" items="${wishlist}">
                        <div class="skill-card">
                            <div class="skill-card-top">
                                <span class="level-badge level-${fn:toLowerCase(sk.skillLevel)}">${sk.skillLevel}</span>
                                <span class="cat-tag"><i class="${sk.categoryIcon}"></i> ${sk.categoryName}</span>
                            </div>
                            <h3 class="skill-title"><c:out value="${sk.title}"/></h3>
                            <p class="skill-desc"><c:out value="${sk.shortDescription}"/></p>
                            <div class="skill-footer">
                                <div class="skill-user">
                                    <img src="${pageContext.request.contextPath}/images/profiles/${sk.userProfileImage}"
                                         class="user-thumb" alt=""
                                         onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                                    <span><c:out value="${sk.userName}"/></span>
                                </div>
                                <div class="rating-badge"><i class="fas fa-star"></i> <fmt:formatNumber value="${sk.userAvgRating}" minFractionDigits="1" maxFractionDigits="1"/></div>
                            </div>
                            <div style="display:flex;gap:8px;margin-top:12px">
                                <a href="${pageContext.request.contextPath}/skill/view?id=${sk.id}" class="btn-card-link" style="flex:1">View</a>
                                <form method="post" action="${pageContext.request.contextPath}/user/wishlist">
                                    <input type="hidden" name="action"  value="remove">
                                    <input type="hidden" name="skillId" value="${sk.id}">
                                    <button type="submit" class="btn-sm btn-danger" title="Remove from wishlist">
                                        <i class="fas fa-heart-broken"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
