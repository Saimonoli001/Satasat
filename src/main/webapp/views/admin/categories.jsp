<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Category Management"/>
<c:set var="activePage" value="categories"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/admin-sidebar.jsp" %>
    <main class="dash-main">

        <div class="dash-topbar">
            <h1><i class="fas fa-tags"></i> Category Management</h1>
            <button class="btn-primary" onclick="openModal('addCatModal')">
                <i class="fas fa-plus"></i> Add Category
            </button>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Category saved successfully.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/></div>
        </c:if>

        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                <tr><th>#</th><th>Icon</th><th>Name</th><th>Description</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <c:forEach var="cat" items="${categories}">
                    <tr>
                        <td>${cat.id}</td>
                        <td><i class="${cat.icon}" style="font-size:1.2rem;color:var(--primary)"></i></td>
                        <td><strong><c:out value="${cat.name}"/></strong></td>
                        <td><c:out value="${cat.description}"/></td>
                        <td>
              <span class="status-tag ${cat.active ? 'st-active' : 'st-suspended'}">
                      ${cat.active ? 'Active' : 'Inactive'}
              </span>
                        </td>
                        <td class="action-cell">
                            <button class="btn-sm btn-edit"
                                    onclick="fillEditCat(${cat.id},'${fn:escapeXml(cat.name)}','${fn:escapeXml(cat.description != null ? cat.description : '')}','${fn:escapeXml(cat.icon)}',${cat.active})">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <form method="post" action="${pageContext.request.contextPath}/admin/categories"
                                  style="display:inline" onsubmit="return confirm('Delete this category? Skills in it may be affected.')">
                                <input type="hidden" name="action"     value="delete">
                                <input type="hidden" name="categoryId" value="${cat.id}">
                                <button class="btn-sm btn-danger"><i class="fas fa-trash"></i> Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </main>
</div>


<div class="modal-overlay" id="addCatModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-plus"></i> Add Category</h3>
            <button class="modal-close" onclick="closeModal('addCatModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/admin/categories">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label>Name *</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Music" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="2"
                          placeholder="Brief description of this category"></textarea>
            </div>
            <div class="form-group">
                <label>Font Awesome Icon Class</label>
                <input type="text" name="icon" class="form-control"
                       placeholder="fas fa-music" value="fas fa-star">
                <small class="hint">Browse icons at <a href="https://fontawesome.com/icons" target="_blank">fontawesome.com/icons</a></small>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('addCatModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Category</button>
            </div>
        </form>
    </div>
</div>


<div class="modal-overlay" id="editCatModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-edit"></i> Edit Category</h3>
            <button class="modal-close" onclick="closeModal('editCatModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/admin/categories">
            <input type="hidden" name="action"     value="edit">
            <input type="hidden" name="categoryId" id="ecId">
            <div class="form-group">
                <label>Name *</label>
                <input type="text" name="name" id="ecName" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="ecDesc" class="form-control" rows="2"></textarea>
            </div>
            <div class="form-group">
                <label>Icon Class</label>
                <input type="text" name="icon" id="ecIcon" class="form-control">
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="isActive" id="ecActive" class="form-control">
                    <option value="true">Active</option>
                    <option value="false">Inactive</option>
                </select>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('editCatModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Update Category</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
