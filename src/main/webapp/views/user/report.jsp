<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Report an Issue"/>
<c:set var="activePage" value="reports"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <h1><i class="fas fa-exclamation-triangle"></i> Help & Support Center</h1>
        </div>

        <div class="grid-2" style="display: grid; grid-template-columns: 1fr 1fr; gap: 32px; margin-top: 24px;">
            <!-- Left Side: Report Form -->
            <div class="card" style="padding: 24px; background: white; border-radius: var(--radius); border: 1px solid var(--border); box-shadow: var(--card-sh);">
                <h3 style="margin-bottom: 20px; font-weight: 800;"><i class="fas fa-paper-plane"></i> Submit a Ticket to Admin</h3>

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> Ticket submitted successfully. An administrator will review your issue soon!
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-times-circle"></i> ${error}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/user/report">
                    <div class="form-group">
                        <label>Report User (Optional)</label>
                        <select name="reportedUserId" class="form-control">
                            <option value="">-- Select a User (if applicable) --</option>
                            <c:forEach var="u" items="${allUsers}">
                                <c:if test="${u.id ne sessionScope.loggedInUser.id}">
                                    <option value="${u.id}"><c:out value="${u.fullName}"/> (${u.email})</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Subject / Issue Category *</label>
                        <input type="text" name="subject" class="form-control" placeholder="e.g. Broken links, abusive behavior, payment queries..." required>
                    </div>

                    <div class="form-group">
                        <label>Description of Issue *</label>
                        <textarea name="description" class="form-control" rows="5" placeholder="Describe your issue in detail so our admins can assist you..." required></textarea>
                    </div>

                    <button type="submit" class="btn-primary btn-block" style="justify-content:center; margin-top: 16px;">
                        <i class="fas fa-paper-plane"></i> Submit Ticket
                    </button>
                </form>
            </div>

            <!-- Right Side: Past Tickets -->
            <div>
                <h3 style="margin-bottom: 20px; font-weight: 800;"><i class="fas fa-history"></i> Ticket History</h3>

                <c:choose>
                    <c:when test="${empty myReports}">
                        <div class="empty-state" style="padding: 40px; background: white; border-radius: var(--radius); border: 1px solid var(--border);">
                            <i class="fas fa-folder-open" style="font-size: 3rem; color: var(--text-lt); margin-bottom: 12px;"></i>
                            <h3>No support tickets yet</h3>
                            <p>All your submitted reports and admin replies will show up here.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="max-height: 500px; overflow-y: auto; padding-right: 8px;">
                            <c:forEach var="r" items="${myReports}">
                                <div class="report-card">
                                    <div class="report-header">
                                        <span class="report-title"><c:out value="${r.subject}"/></span>
                                        <span class="status-tag st-${fn:toLowerCase(r.status)}">${r.status}</span>
                                    </div>
                                    <div style="font-size: 0.8rem; color: var(--text-lt); margin-bottom: 12px;">
                                        <i class="fas fa-clock"></i> Submitted: ${r.createdAt}
                                        <c:if test="${not empty r.reportedUserName}">
                                            | Reported User: <strong><c:out value="${r.reportedUserName}"/></strong>
                                        </c:if>
                                    </div>
                                    <p class="report-desc"><c:out value="${r.description}"/></p>

                                    <c:if test="${not empty r.adminReply}">
                                        <div class="report-reply">
                                            <div class="report-reply-title"><i class="fas fa-user-shield"></i> Admin Response</div>
                                            <div class="report-reply-text"><c:out value="${r.adminReply}"/></div>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
