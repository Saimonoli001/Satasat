<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="My Skills"/>
<c:set var="activePage" value="skills"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <h1><i class="fas fa-star"></i> My Skills</h1>
            <button class="btn-primary" onclick="openModal('addSkillModal')">
                <i class="fas fa-plus"></i> Add Skill
            </button>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <c:out value="${param.error}"/></div>
        </c:if>

        <c:choose>
            <c:when test="${empty mySkills}">
                <div class="empty-state">
                    <i class="fas fa-star"></i>
                    <h3>No skills listed yet</h3>
                    <p>Share what you know — add your first skill and start receiving exchange requests.</p>
                    <button class="btn-primary" onclick="openModal('addSkillModal')">Add Your First Skill</button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="manage-grid">
                    <c:forEach var="sk" items="${mySkills}">
                        <div class="manage-card">
                            <div class="manage-card-top">
                                <span class="level-badge level-${fn:toLowerCase(sk.skillLevel)}">${sk.skillLevel}</span>
                                <span class="cat-tag">${sk.categoryName}</span>
                            </div>
                            <h3><c:out value="${sk.title}"/></h3>
                            <p><c:out value="${sk.shortDescription}"/></p>
                            <p class="avail-text"><i class="fas fa-clock"></i> <c:out value="${sk.availability}"/></p>
                            <div class="manage-actions">
                                <button class="btn-sm btn-edit"
                                        onclick="fillEdit(${sk.id},'${fn:escapeXml(sk.title)}','${fn:escapeXml(sk.description)}','${sk.skillLevel}','${fn:escapeXml(sk.availability)}',${sk.categoryId})">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <form method="post" action="${pageContext.request.contextPath}/user/skills"
                                      style="display:inline" onsubmit="return confirm('Delete this skill?')">
                                    <input type="hidden" name="action"  value="delete">
                                    <input type="hidden" name="skillId" value="${sk.id}">
                                    <button type="submit" class="btn-sm btn-danger">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>

<!-- ADD SKILL MODAL -->
<div class="modal-overlay" id="addSkillModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-plus"></i> Add New Skill</h3>
            <button class="modal-close" onclick="closeModal('addSkillModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/skills">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label>Title *</label>
                <input type="text" name="title" class="form-control" placeholder="e.g. Guitar Lessons for Beginners" required>
            </div>
            <div class="form-group">
                <label>Category *</label>
                <select name="categoryId" class="form-control" required>
                    <option value="">Select category…</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}"><c:out value="${cat.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Description *</label>
                <textarea name="description" class="form-control" rows="4"
                          placeholder="Describe what you'll teach, your experience level, what students will gain…" required></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Skill Level</label>
                    <select name="skillLevel" class="form-control">
                        <option value="BEGINNER">Beginner</option>
                        <option value="INTERMEDIATE">Intermediate</option>
                        <option value="ADVANCED">Advanced</option>
                        <option value="EXPERT">Expert</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Availability</label>
                    <input type="text" name="availability" class="form-control" placeholder="e.g. Weekends, Evenings">
                </div>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('addSkillModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Skill</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT SKILL MODAL -->
<div class="modal-overlay" id="editSkillModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-edit"></i> Edit Skill</h3>
            <button class="modal-close" onclick="closeModal('editSkillModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/skills">
            <input type="hidden" name="action"  value="edit">
            <input type="hidden" name="skillId" id="editSkillId">
            <div class="form-group">
                <label>Title *</label>
                <input type="text" name="title" id="editTitle" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Category *</label>
                <select name="categoryId" id="editCatId" class="form-control">
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}"><c:out value="${cat.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Description *</label>
                <textarea name="description" id="editDesc" class="form-control" rows="4" required></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Skill Level</label>
                    <select name="skillLevel" id="editLevel" class="form-control">
                        <option value="BEGINNER">Beginner</option>
                        <option value="INTERMEDIATE">Intermediate</option>
                        <option value="ADVANCED">Advanced</option>
                        <option value="EXPERT">Expert</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Availability</label>
                    <input type="text" name="availability" id="editAvail" class="form-control">
                </div>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('editSkillModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Update Skill</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
