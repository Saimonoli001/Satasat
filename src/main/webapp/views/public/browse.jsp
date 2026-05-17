<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Browse Skills"/>
<%@ include file="../includes/header.jsp" %>

<div class="page-wrap">
    <div class="page-banner">
        <h1><i class="fas fa-search"></i> Browse Skills</h1>
        <p>Discover skills to exchange. Find your perfect learning partner across Nepal.</p>
    </div>

    <div class="browse-layout">
        <!-- Filter Sidebar -->
        <aside class="filter-panel">
            <div class="filter-card">
                <h3><i class="fas fa-filter"></i> Filter Skills</h3>
                <form method="get" action="${pageContext.request.contextPath}/browse" id="filterForm">
                    <div class="form-group">
                        <label>Keyword</label>
                        <input type="text" name="keyword" class="form-control"
                               placeholder="e.g. Guitar, Python..."
                               value="<c:out value='${keyword}'/>">
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" class="form-control">
                            <option value="0">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}"
                                    ${selectedCat == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Minimum Rating</label>
                        <select name="rating" class="form-control">
                            <option value="0">Any Rating</option>
                            <option value="3.0" ${selectedRating == 3.0 ? 'selected' : ''}>3+ Stars</option>
                            <option value="4.0" ${selectedRating == 4.0 ? 'selected' : ''}>4+ Stars</option>
                            <option value="4.5" ${selectedRating == 4.5 ? 'selected' : ''}>4.5+ Stars</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-primary btn-block">
                        <i class="fas fa-search"></i> Search
                    </button>
                    <a href="${pageContext.request.contextPath}/browse" class="btn-outline btn-block mt-8">
                        <i class="fas fa-times"></i> Clear
                    </a>
                </form>
            </div>
        </aside>

        <!-- Results -->
        <main class="browse-results">
            <div class="results-bar">
                <span><strong>${fn:length(skills)}</strong> skill(s) found</span>
                <c:if test="${not empty keyword}">
          <span class="filter-tag">
            <i class="fas fa-search"></i> "<c:out value='${keyword}'/>"
          </span>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${empty skills}">
                    <div class="empty-state">
                        <i class="fas fa-search-minus"></i>
                        <h3>No skills match your search</h3>
                        <p>Try different keywords or remove some filters.</p>
                        <a href="${pageContext.request.contextPath}/browse" class="btn-outline">Browse All Skills</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="skills-grid">
                        <c:forEach var="skill" items="${skills}">
                            <div class="skill-card">
                                <div class="skill-card-top">
                                    <span class="level-badge level-${fn:toLowerCase(skill.skillLevel)}">${skill.skillLevel}</span>
                                    <span class="cat-tag"><i class="${skill.categoryIcon}"></i> ${skill.categoryName}</span>
                                </div>
                                <h3 class="skill-title"><c:out value="${skill.title}"/></h3>
                                <p class="skill-desc"><c:out value="${skill.shortDescription}"/></p>
                                <div class="skill-meta"><i class="fas fa-clock"></i> <c:out value="${skill.availability}"/></div>
                                <div class="skill-footer">
                                    <div class="skill-user">
                                        <img src="${pageContext.request.contextPath}/images/profiles/${skill.userProfileImage}"
                                             class="user-thumb" alt="user"
                                             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                                        <span><c:out value="${skill.userName}"/></span>
                                    </div>
                                    <div class="rating-badge"><i class="fas fa-star"></i> ${String.format("%.1f", skill.userAvgRating)}</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/skill/view?id=${skill.id}" class="btn-card-link">
                                    View & Exchange <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
