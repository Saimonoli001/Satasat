<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${skill.title}"/>
<%@ include file="../includes/header.jsp" %>

<div class="page-wrap">
    <div class="skill-detail-layout">

        
        <div class="sd-main">
            <div class="detail-card">
                <div class="detail-badges">
                    <span class="level-badge level-${fn:toLowerCase(skill.skillLevel)}">${skill.skillLevel}</span>
                    <span class="cat-tag"><i class="${skill.categoryIcon}"></i> ${skill.categoryName}</span>
                    <span class="view-count"><i class="fas fa-eye"></i> ${skill.viewCount} views</span>
                </div>
                <h1 class="detail-title"><c:out value="${skill.title}"/></h1>
                <div class="detail-meta">
                    <span><i class="fas fa-clock"></i> <c:out value="${skill.availability}"/></span>
                </div>
                <div class="detail-body">
                    <h3>About This Skill</h3>
                    <p><c:out value="${skill.description}"/></p>
                </div>
            </div>

            
            <c:if test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.id ne skill.userId}">
                <div class="exchange-box">
                    <h3><i class="fas fa-handshake"></i> Propose a Skill Exchange</h3>
                    <p>Offer one of your skills in return for <strong><c:out value="${skill.title}"/></strong></p>

                    <c:choose>
                        <c:when test="${empty mySkills}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i>
                                You need to <a href="${pageContext.request.contextPath}/user/skills">add at least one skill</a> before sending an exchange request.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/user/requests" id="exchangeForm">
                                <input type="hidden" name="action"           value="send">
                                <input type="hidden" name="receiverId"       value="${skill.userId}">
                                <input type="hidden" name="requestedSkillId" value="${skill.id}">
                                <div class="form-group">
                                    <label>I offer this skill in return:</label>
                                    <select name="offeredSkillId" class="form-control" required>
                                        <option value="">-- Select your skill --</option>
                                        <c:forEach var="ms" items="${mySkills}">
                                            <option value="${ms.id}"><c:out value="${ms.title}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Message (optional)</label>
                                    <textarea name="message" class="form-control" rows="3"
                                              placeholder="Introduce yourself and explain your proposal..."></textarea>
                                </div>
                                <button type="submit" class="btn-primary btn-block">
                                    <i class="fas fa-paper-plane"></i> Send Exchange Request
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                        
                    <form method="post" action="${pageContext.request.contextPath}/user/wishlist" class="mt-12">
                        <input type="hidden" name="skillId" value="${skill.id}">
                        <input type="hidden" name="redirect"
                               value="${pageContext.request.contextPath}/skill/view?id=${skill.id}">
                        <c:choose>
                            <c:when test="${inWishlist}">
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="btn-outline btn-block">
                                    <i class="fas fa-heart-broken"></i> Remove from Wishlist
                                </button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="add">
                                <button type="submit" class="btn-outline btn-block">
                                    <i class="fas fa-heart"></i> Save to Wishlist
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </c:if>

            
            <c:if test="${empty sessionScope.loggedInUser}">
                <div class="exchange-box login-prompt">
                    <i class="fas fa-lock"></i>
                    <h3>Want to Exchange?</h3>
                    <p>Sign in to propose a skill exchange with <c:out value="${skill.userName}"/>.</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn-primary">
                        Sign In to Exchange
                    </a>
                </div>
            </c:if>
        </div>

        
        <aside class="sd-sidebar">
            <div class="teacher-card">
                <h4>Offered by</h4>
                <div class="teacher-info">
                    <img src="${pageContext.request.contextPath}/images/profiles/${skill.userProfileImage}"
                         class="teacher-avatar" alt="teacher"
                         onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                    <div>
                        <strong><c:out value="${skill.userName}"/></strong>
                        <div class="stars-row">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= skill.userAvgRating ? 'star-on' : 'star-off'}"></i>
                            </c:forEach>
                            <span>${String.format("%.1f", skill.userAvgRating)}</span>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/user/profile?id=${skill.userId}"
                   class="btn-outline btn-block">View Profile</a>
            </div>
        </aside>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
