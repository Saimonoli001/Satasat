<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Exchange Requests"/>
<c:set var="activePage" value="requests"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <h1><i class="fas fa-handshake"></i> Exchange Requests</h1>
        </div>

        <c:choose>
            <c:when test="${empty requests}">
                <div class="empty-state">
                    <i class="fas fa-handshake"></i>
                    <h3>No exchange requests yet</h3>
                    <p>Browse skills and propose a barter exchange to get started.</p>
                    <a href="${pageContext.request.contextPath}/browse" class="btn-primary">Browse Skills</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="req-full-list">
                    <c:forEach var="r" items="${requests}">
                        <div class="req-card status-border-${fn:toLowerCase(r.status)}">
                            <div class="req-card-hdr">
                                <div class="req-parties">
                                    <div class="req-party">
                                        <img src="${pageContext.request.contextPath}/images/profiles/${r.requesterImage}"
                                             class="req-avatar" alt=""
                                             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                                        <div>
                                            <small>From</small>
                                            <strong><c:out value="${r.requesterName}"/></strong>
                                        </div>
                                    </div>
                                    <div class="req-arrow"><i class="fas fa-exchange-alt"></i></div>
                                    <div class="req-party">
                                        <img src="${pageContext.request.contextPath}/images/profiles/${r.receiverImage}"
                                             class="req-avatar" alt=""
                                             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                                        <div>
                                            <small>To</small>
                                            <strong><c:out value="${r.receiverName}"/></strong>
                                        </div>
                                    </div>
                                </div>
                                <span class="status-tag st-${fn:toLowerCase(r.status)}">${r.status}</span>
                            </div>

                            <div class="req-skills-row">
                                <span class="req-skill offered"><i class="fas fa-gift"></i> <c:out value="${r.offeredSkillTitle}"/></span>
                                <i class="fas fa-arrows-alt-h"></i>
                                <span class="req-skill wanted"><i class="fas fa-search"></i> <c:out value="${r.requestedSkillTitle}"/></span>
                            </div>

                            <c:if test="${not empty r.message}">
                                <blockquote class="req-msg">"<c:out value="${r.message}"/>"</blockquote>
                            </c:if>
                            <c:if test="${r.status eq 'COUNTERED' and not empty r.counterMessage}">
                                <blockquote class="req-msg counter-msg">
                                    <i class="fas fa-reply"></i> Counter: "<c:out value="${r.counterMessage}"/>"
                                </blockquote>
                            </c:if>

                            <div class="req-actions">

                                <c:if test="${r.receiverId eq sessionScope.loggedInUser.id and
                           (r.status eq 'PENDING' or r.status eq 'COUNTERED')}">
                                    <form method="post" action="${pageContext.request.contextPath}/user/requests" style="display:inline">
                                        <input type="hidden" name="action" value="accept">
                                        <input type="hidden" name="requestId" value="${r.id}">
                                        <button class="btn-sm btn-success"><i class="fas fa-check"></i> Accept</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/user/requests" style="display:inline">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="requestId" value="${r.id}">
                                        <button class="btn-sm btn-danger"><i class="fas fa-times"></i> Reject</button>
                                    </form>
                                    <button class="btn-sm btn-warn" onclick="openCounter('${r.id}')">
                                        <i class="fas fa-reply"></i> Counter
                                    </button>
                                </c:if>


                                <c:if test="${r.requesterId eq sessionScope.loggedInUser.id and r.status eq 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/user/requests"
                                          onsubmit="return confirm('Cancel this request?')" style="display:inline">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="requestId" value="${r.id}">
                                        <button class="btn-sm btn-outline-sm"><i class="fas fa-ban"></i> Cancel</button>
                                    </form>
                                </c:if>


                                <c:if test="${r.status eq 'ACCEPTED'}">
                                    <button class="btn-sm btn-primary-sm" onclick="openSchedule('${r.id}')">
                                        <i class="fas fa-calendar-plus"></i> Schedule Session
                                    </button>
                                    <a href="${pageContext.request.contextPath}/user/messages?requestId=${r.id}" class="btn-sm btn-success">
                                        <i class="fas fa-comments"></i> Chat & Video Call
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>


<div class="modal-overlay" id="counterModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-reply"></i> Counter Offer</h3>
            <button class="modal-close" onclick="closeModal('counterModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/requests">
            <input type="hidden" name="action" value="counter">
            <input type="hidden" name="requestId" id="counterReqId">
            <div class="form-group">
                <label>Your Counter Proposal</label>
                <textarea name="counterMessage" class="form-control" rows="3"
                          placeholder="Suggest an alternative arrangement…" required></textarea>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('counterModal')">Cancel</button>
                <button type="submit" class="btn-primary">Send Counter Offer</button>
            </div>
        </form>
    </div>
</div>


<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<div class="modal-overlay" id="scheduleModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-calendar-plus"></i> Schedule Learning Session</h3>
            <button class="modal-close" onclick="closeModal('scheduleModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/requests">
            <input type="hidden" name="action" value="schedule">
            <input type="hidden" name="requestId" id="schedReqId">
            <div class="form-group">
                <label>Choose Date & Time *</label>
                <input type="text" name="scheduledDate" id="flatpickrDate" class="form-control" placeholder="Select Date and Time..." required readonly>
            </div>
            <div class="form-group">
                <label>Notes (location, platform, preparation…)</label>
                <textarea name="notes" class="form-control" rows="3"
                          placeholder="e.g. Online via Jitsi Meet, bring guitar tabs…"></textarea>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('scheduleModal')">Cancel</button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-calendar-check"></i> Confirm Session
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        flatpickr("#flatpickrDate", {
            enableTime: true,
            dateFormat: "Y-m-d H:i",
            minDate: "today"
        });
    });
</script>

<%@ include file="../includes/footer.jsp" %>
