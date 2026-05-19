<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Dashboard"/>
<c:set var="activePage" value="dashboard"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <div>
                <h1>Welcome back, <c:out value="${sessionScope.loggedInUser.firstName}"/>! </h1>
                <p class="text-muted">Here's what's happening with your skill exchanges.</p>
            </div>
            <a href="${pageContext.request.contextPath}/browse" class="btn-primary">
                <i class="fas fa-plus"></i> Find Skills to Exchange
            </a>
        </div>

        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Changes saved successfully.</div>
        </c:if>

        
        <div class="kpi-grid">
            <div class="kpi-card kpi-blue">
                <i class="fas fa-star"></i>
                <div><strong>${fn:length(mySkills)}</strong><span>My Skills</span></div>
            </div>
            <div class="kpi-card kpi-green">
                <i class="fas fa-handshake"></i>
                <div><strong>${fn:length(myRequests)}</strong><span>Requests</span></div>
            </div>
            <div class="kpi-card kpi-purple">
                <i class="fas fa-calendar-check"></i>
                <div><strong>${fn:length(mySessions)}</strong><span>Sessions</span></div>
            </div>
            <div class="kpi-card kpi-orange">
                <i class="fas fa-comments"></i>
                <div><strong>${fn:length(myReviews)}</strong><span>Reviews</span></div>
            </div>
        </div>

        
        <c:if test="${fn:length(incoming) > 0}">
            <div class="dash-section">
                <h2><i class="fas fa-bell"></i> Pending Requests
                    <span class="count-pill red">${fn:length(incoming)}</span>
                </h2>
                <div class="req-list">
                    <c:forEach var="r" items="${incoming}" end="3">
                        <div class="req-item">
                            <img src="${pageContext.request.contextPath}/images/profiles/${r.requesterImage}"
                                 class="req-avatar" alt="requester"
                                 onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                            <div class="req-text">
                                <strong><c:out value="${r.requesterName}"/></strong> wants to exchange
                                <span class="pill-skill"><c:out value="${r.offeredSkillTitle}"/></span>
                                for your
                                <span class="pill-skill"><c:out value="${r.requestedSkillTitle}"/></span>
                            </div>
                            <a href="${pageContext.request.contextPath}/user/requests" class="btn-sm btn-primary-sm">
                                Respond
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        
        <div class="dash-section">
            <div class="section-hdr">
                <h2><i class="fas fa-star"></i> My Skills</h2>
                <a href="${pageContext.request.contextPath}/user/skills" class="link-more">
                    Manage <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <c:choose>
                <c:when test="${empty mySkills}">
                    <div class="empty-mini">
                        <i class="fas fa-plus-circle"></i>
                        <a href="${pageContext.request.contextPath}/user/skills">Add your first skill</a> to start exchanging.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="mini-grid">
                        <c:forEach var="sk" items="${mySkills}" end="3">
                            <div class="mini-skill">
                                <span class="level-badge level-${fn:toLowerCase(sk.skillLevel)}">${sk.skillLevel}</span>
                                <h4><c:out value="${sk.title}"/></h4>
                                <p><c:out value="${sk.categoryName}"/></p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        
        <c:if test="${fn:length(myReviews) > 0}">
            <div class="dash-section">
                <h2><i class="fas fa-comments"></i> Recent Reviews</h2>
                <div class="review-list">
                    <c:forEach var="rv" items="${myReviews}" end="2">
                        <div class="review-item">
                            <img src="${pageContext.request.contextPath}/images/profiles/${rv.reviewerImage}"
                                 class="review-avatar" alt="reviewer"
                                 onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                            <div class="review-body">
                                <div class="review-hdr">
                                    <strong><c:out value="${rv.reviewerName}"/></strong>
                                    <div class="stars-row">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= rv.rating ? 'star-on' : 'star-off'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                                <p><c:out value="${rv.comment}"/></p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
