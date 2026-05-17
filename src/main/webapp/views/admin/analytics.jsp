<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"  value="Analytics"/>
<c:set var="activePage" value="analytics"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/admin-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar"><h1><i class="fas fa-chart-bar"></i> Platform Analytics</h1></div>

        <div class="kpi-grid">
            <div class="kpi-card kpi-blue"><i class="fas fa-users"></i><div><strong>${totalUsers}</strong><span>Users</span></div></div>
            <div class="kpi-card kpi-green"><i class="fas fa-star"></i><div><strong>${totalSkills}</strong><span>Skills</span></div></div>
            <div class="kpi-card kpi-purple"><i class="fas fa-handshake"></i><div><strong>${totalRequests}</strong><span>Exchanges</span></div></div>
            <div class="kpi-card kpi-orange"><i class="fas fa-calendar-check"></i><div><strong>${sessionsDone}</strong><span>Sessions Done</span></div></div>
        </div>

        <!-- Completion Rate -->
        <div class="analytics-card">
            <h2><i class="fas fa-percentage"></i> Exchange Completion Rate</h2>
            <c:set var="rate" value="${totalRequests > 0 ? completedCount * 100 / totalRequests : 0}"/>
            <div class="compl-label">
                <span>${completedCount} of ${totalRequests} exchanges completed</span>
                <strong>${rate}%</strong>
            </div>
            <div class="prog-track">
                <div class="prog-fill" style="width:${rate}%"></div>
            </div>
        </div>

        <!-- Top 10 Demanded Skills Bar Chart -->
        <div class="analytics-card">
            <h2><i class="fas fa-fire"></i> Top 10 Most Demanded Skills</h2>
            <div class="bar-chart">
                <c:choose>
                    <c:when test="${empty topSkills}">
                        <p class="text-muted">No exchange data yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:set var="maxVal" value="1"/>
                        <c:forEach var="s" items="${topSkills}">
                            <c:if test="${s.count > maxVal}"><c:set var="maxVal" value="${s.count}"/></c:if>
                        </c:forEach>
                        <c:forEach var="s" items="${topSkills}">
                            <c:set var="pct" value="${maxVal > 0 ? s.count * 100 / maxVal : 5}"/>
                            <div class="bar-row">
                                <div class="bar-label"><c:out value="${s.title}"/></div>
                                <div class="bar-track">
                                    <div class="bar-fill bar-blue" style="width:${pct < 5 ? 5 : pct}%">
                                        <span>${s.count}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Most Active Users -->
        <div class="analytics-card">
            <h2><i class="fas fa-trophy"></i> Most Active Users</h2>
            <div class="bar-chart">
                <c:choose>
                    <c:when test="${empty activeUsers}">
                        <p class="text-muted">No activity data yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="u" items="${activeUsers}" varStatus="vs">
                            <c:set var="pct" value="${100 - vs.index * 9}"/>
                            <div class="bar-row">
                                <div class="bar-label"><c:out value="${u.fullName}"/></div>
                                <div class="bar-track">
                                    <div class="bar-fill bar-green" style="width:${pct < 8 ? 8 : pct}%">
                                        <span>${String.format("%.1f", u.avgRating)} ★</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </main>
</div>
<%@ include file="../includes/footer.jsp" %>
