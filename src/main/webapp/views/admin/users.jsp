<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="User Management"/>
<c:set var="activePage" value="users"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/admin-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar"><h1><i class="fas fa-users"></i> User Management</h1></div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Action completed successfully.</div>
        </c:if>

        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                <tr><th>#</th><th>Name</th><th>Email</th><th>Location</th><th>Role</th>
                    <th>Status</th><th>Rating</th><th>Joined</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <c:if test="${u.role ne 'ADMIN'}">
                        <tr>
                            <td>${u.id}</td>
                            <td><c:out value="${u.fullName}"/></td>
                            <td><c:out value="${u.email}"/></td>
                            <td><c:out value="${u.location}"/></td>
                            <td><span class="role-pill">${u.role}</span></td>
                            <td><span class="status-tag st-${fn:toLowerCase(u.status)}">${u.status}</span></td>
                            <td><i class="fas fa-star star-on"></i> <fmt:formatNumber value="${u.avgRating}" minFractionDigits="1" maxFractionDigits="1"/></td>
                            <td>${u.createdAt}</td>
                            <td class="action-cell">
                                <c:if test="${u.status eq 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button class="btn-sm btn-success"><i class="fas fa-check"></i> Approve</button>
                                    </form>
                                </c:if>
                                <c:if test="${u.status eq 'ACTIVE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                                        <input type="hidden" name="action" value="suspend">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button class="btn-sm btn-warn"><i class="fas fa-ban"></i> Suspend</button>
                                    </form>
                                </c:if>
                                <c:if test="${u.status eq 'SUSPENDED'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                                        <input type="hidden" name="action" value="activate">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button class="btn-sm btn-success"><i class="fas fa-check-circle"></i> Activate</button>
                                    </form>
                                </c:if>
                                <form method="post" action="${pageContext.request.contextPath}/admin/users"
                                      style="display:inline" onsubmit="return confirm('Permanently delete this user?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button class="btn-sm btn-danger"><i class="fas fa-trash"></i> Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
