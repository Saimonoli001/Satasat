<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Admin Dashboard"/>
<c:set var="activePage" value="dashboard"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/admin-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
            <span class="admin-pill"><i class="fas fa-shield-alt"></i> Admin Panel</span>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card kpi-blue"><i class="fas fa-users"></i><div><strong>${totalUsers}</strong><span>Total Users</span></div></div>
            <div class="kpi-card kpi-green"><i class="fas fa-star"></i><div><strong>${totalSkills}</strong><span>Active Skills</span></div></div>
            <div class="kpi-card kpi-purple"><i class="fas fa-handshake"></i><div><strong>${totalRequests}</strong><span>Total Exchanges</span></div></div>
            <div class="kpi-card kpi-orange"><i class="fas fa-calendar-check"></i><div><strong>${completedSessions}</strong><span>Completed Sessions</span></div></div>
        </div>

        <!-- Pending approvals -->
        <c:if test="${fn:length(pendingUsers) > 0}">
            <div class="dash-section">
                <h2><i class="fas fa-user-clock"></i> Pending Approvals
                    <span class="count-pill red">${fn:length(pendingUsers)}</span>
                </h2>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead><tr><th>Name</th><th>Email</th><th>Location</th><th>Registered</th><th>Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="u" items="${pendingUsers}">
                            <tr>
                                <td><c:out value="${u.fullName}"/></td>
                                <td><c:out value="${u.email}"/></td>
                                <td><c:out value="${u.location}"/></td>
                                <td>${u.createdAt}</td>
                                <td class="action-cell">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button class="btn-sm btn-success"><i class="fas fa-check"></i> Approve</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users"
                                          style="display:inline" onsubmit="return confirm('Reject and delete this user?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button class="btn-sm btn-danger"><i class="fas fa-times"></i> Reject</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Recent users -->
        <div class="dash-section">
            <div class="section-hdr">
                <h2><i class="fas fa-users"></i> Recent Users</h2>
                <a href="${pageContext.request.contextPath}/admin/users" class="link-more">View all <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead><tr><th>Name</th><th>Email</th><th>Status</th><th>Rating</th><th>Joined</th></tr></thead>
                    <tbody>
                    <c:forEach var="u" items="${recentUsers}">
                        <tr>
                            <td><c:out value="${u.fullName}"/></td>
                            <td><c:out value="${u.email}"/></td>
                            <td><span class="status-tag st-${fn:toLowerCase(u.status)}">${u.status}</span></td>
                            <td><i class="fas fa-star star-on"></i> ${String.format("%.1f",u.avgRating)}</td>
                            <td>${u.createdAt}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
