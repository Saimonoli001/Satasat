<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Support Tickets"/>
<c:set var="activePage" value="reports"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/admin-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar" style="display:flex; justify-content:space-between; align-items:center;">
            <h1><i class="fas fa-exclamation-triangle"></i> Support Tickets</h1>
            <span class="status-tag st-open" style="font-size:1rem; padding: 6px 16px;">
                <i class="fas fa-exclamation-circle"></i> ${openCount} Pending Tickets
            </span>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success mt-16">
                <i class="fas fa-check-circle"></i> Ticket action performed successfully!
            </div>
        </c:if>

        <div style="margin-top:24px;">
            <c:choose>
                <c:when test="${empty reports}">
                    <div class="empty-state" style="background:white; padding:60px; border-radius:var(--radius); border: 1px solid var(--border);">
                        <i class="fas fa-check-double" style="font-size:4rem; color:var(--success); margin-bottom:16px;"></i>
                        <h3>Inbox Zero!</h3>
                        <p>No user support tickets or abuse reports found.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap:20px;">
                        <c:forEach var="r" items="${reports}">
                            <div class="card" style="padding:24px; background:white; border-radius:var(--radius); border: 1px solid var(--border); box-shadow:var(--card-sh);">
                                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                                    <div>
                                        <h3 style="font-weight:800; color:var(--text);"><c:out value="${r.subject}"/></h3>
                                        <div style="font-size:0.82rem; color:var(--text-lt); margin-top:4px;">
                                            Reporter: <strong><c:out value="${r.reporterName}"/></strong> |
                                            Reported User: <strong><c:out value="${empty r.reportedUserName ? 'N/A' : r.reportedUserName}"/></strong> |
                                            Date: ${r.createdAt}
                                        </div>
                                    </div>
                                    <span class="status-tag st-${fn:toLowerCase(r.status)}">${r.status}</span>
                                </div>

                                <blockquote style="background:var(--bg); border-left:4px solid var(--text-lt); padding:12px 18px; border-radius:var(--radius-sm); margin-bottom:16px; font-style:italic;">
                                    "<c:out value="${r.description}"/>"
                                </blockquote>

                                <c:if test="${not empty r.adminReply}">
                                    <div class="report-reply" style="margin-bottom:16px;">
                                        <div class="report-reply-title"><i class="fas fa-user-shield"></i> Your Response</div>
                                        <div class="report-reply-text"><c:out value="${r.adminReply}"/></div>
                                    </div>
                                </c:if>

                                <div style="display:flex; gap:12px; align-items:center; border-top:1px solid var(--border); padding-top:16px;">
                                    <c:if test="${r.status eq 'OPEN'}">
                                        <!-- Reply Form Trigger -->
                                        <button class="btn-sm btn-edit" onclick="toggleReplyForm(${r.id})">
                                            <i class="fas fa-reply"></i> Reply & Resolve
                                        </button>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reports" style="display:inline">
                                            <input type="hidden" name="action" value="close">
                                            <input type="hidden" name="reportId" value="${r.id}">
                                            <button type="submit" class="btn-sm btn-danger">
                                                <i class="fas fa-times"></i> Close Ticket
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${r.status eq 'CLOSED' or r.status eq 'RESOLVED'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reports" style="display:inline">
                                            <input type="hidden" name="action" value="reopen">
                                            <input type="hidden" name="reportId" value="${r.id}">
                                            <button type="submit" class="btn-sm btn-outline-sm">
                                                <i class="fas fa-history"></i> Reopen Ticket
                                            </button>
                                        </form>
                                    </c:if>
                                </div>

                                <!-- Dynamic Reply Form -->
                                <div id="replyForm-${r.id}" style="display:none; margin-top:16px; border-top:1px dashed var(--border); padding-top:16px;">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/reports">
                                        <input type="hidden" name="action" value="reply">
                                        <input type="hidden" name="reportId" value="${r.id}">
                                        <div class="form-group">
                                            <label>Write Reply to User</label>
                                            <textarea name="adminReply" class="form-control" rows="3" placeholder="Write your resolution reply here... the ticket status will mark as RESOLVED." required></textarea>
                                        </div>
                                        <div style="display:flex; gap:8px;">
                                            <button type="submit" class="btn-sm btn-success">Send Reply</button>
                                            <button type="button" class="btn-sm btn-outline-sm" onclick="toggleReplyForm(${r.id})">Cancel</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<script>
    function toggleReplyForm(id) {
        const form = document.getElementById('replyForm-' + id);
        if(form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
</script>

<%@ include file="../includes/footer.jsp" %>
