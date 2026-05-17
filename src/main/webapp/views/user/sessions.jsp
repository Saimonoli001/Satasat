<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="My Sessions"/>
<c:set var="activePage" value="sessions"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar"><h1><i class="fas fa-calendar-alt"></i> My Sessions</h1></div>

        <c:choose>
            <c:when test="${empty sessions}">
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h3>No sessions yet</h3>
                    <p>Accept an exchange request and schedule your first learning session.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="session-list">
                    <c:forEach var="s" items="${sessions}">
                        <div class="session-card st-${fn:toLowerCase(s.status)}">
                            <div class="session-hdr">
                                <div class="session-parties">
                                    <strong><c:out value="${s.requesterName}"/></strong>
                                    <i class="fas fa-exchange-alt"></i>
                                    <strong><c:out value="${s.receiverName}"/></strong>
                                </div>
                                <span class="status-tag st-${fn:toLowerCase(s.status)}">${s.status}</span>
                            </div>
                            <div class="session-skills">
                                <span class="pill-skill"><c:out value="${s.offeredSkillTitle}"/></span>
                                <i class="fas fa-arrows-alt-h"></i>
                                <span class="pill-skill"><c:out value="${s.requestedSkillTitle}"/></span>
                            </div>
                            <c:choose>
                                <c:when test="${s.status eq 'PENDING'}">
                                    <p class="session-dt" style="color: var(--warn); font-weight: 600;">
                                        <i class="fas fa-exclamation-circle"></i> Waiting to be scheduled
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="session-dt"><i class="fas fa-calendar"></i> ${s.scheduledDate}</p>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty s.notes}">
                                <p class="session-notes"><i class="fas fa-sticky-note"></i> <c:out value="${s.notes}"/></p>
                            </c:if>

                            <c:if test="${s.status eq 'PENDING' or s.status eq 'SCHEDULED'}">
                                <a href="${pageContext.request.contextPath}/user/messages?requestId=${s.requestId}" class="btn-sm btn-success mt-8">
                                    <i class="fas fa-comments"></i> Chat & Video Call
                                </a>
                            </c:if>

                                <%-- Mark complete --%>
                            <c:if test="${s.status eq 'SCHEDULED'}">
                                <form method="post" action="${pageContext.request.contextPath}/user/sessions"
                                      onsubmit="return confirm('Mark this session as completed?')">
                                    <input type="hidden" name="action"    value="complete">
                                    <input type="hidden" name="sessionId" value="${s.id}">
                                    <button class="btn-sm btn-success mt-8">
                                        <i class="fas fa-check-circle"></i> Mark Complete
                                    </button>
                                </form>
                            </c:if>

                                <%-- Leave Review --%>
                            <c:if test="${s.status eq 'COMPLETED'}">
                                <c:set var="uid"  value="${sessionScope.loggedInUser.id}"/>
                                <c:set var="isRq" value="${s.requesterId eq uid}"/>
                                <c:set var="alreadyReviewed" value="${isRq ? s.reviewedByRequester : s.reviewedByReceiver}"/>
                                <c:set var="revieweeId"      value="${isRq ? s.receiverId : s.requesterId}"/>
                                <c:choose>
                                    <c:when test="${not alreadyReviewed}">
                                        <button class="btn-sm btn-primary-sm mt-8"
                                                onclick="openReview(${s.id}, ${revieweeId})">
                                            <i class="fas fa-star"></i> Leave Review
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                  <span class="reviewed-badge mt-8">
                    <i class="fas fa-check"></i> Review submitted
                  </span>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>

<!-- Review Modal -->
<div class="modal-overlay" id="reviewModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-star"></i> Leave a Review</h3>
            <button class="modal-close" onclick="closeModal('reviewModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/sessions">
            <input type="hidden" name="action"     value="review">
            <input type="hidden" name="sessionId"  id="rvSessionId">
            <input type="hidden" name="revieweeId" id="rvRevieweeId">
            <div class="form-group">
                <label>Rating</label>
                <div class="star-picker" id="starPicker">
                    <i class="fas fa-star sp-star" data-v="1" onclick="setRating(1)"></i>
                    <i class="fas fa-star sp-star" data-v="2" onclick="setRating(2)"></i>
                    <i class="fas fa-star sp-star" data-v="3" onclick="setRating(3)"></i>
                    <i class="fas fa-star sp-star" data-v="4" onclick="setRating(4)"></i>
                    <i class="fas fa-star sp-star" data-v="5" onclick="setRating(5)"></i>
                </div>
                <input type="hidden" name="rating" id="ratingVal" value="5">
            </div>
            <div class="form-group">
                <label>Comment</label>
                <textarea name="comment" class="form-control" rows="3"
                          placeholder="Share your experience…"></textarea>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('reviewModal')">Cancel</button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-paper-plane"></i> Submit Review
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
