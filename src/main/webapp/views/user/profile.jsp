<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="${profile.fullName}"/>
<c:set var="activePage" value="profile"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Profile updated successfully.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/></div>
        </c:if>

        <div class="profile-card">
            <div class="profile-cover"></div>
            <div class="profile-body">
                <div class="profile-avatar-wrap">
                    <img src="${pageContext.request.contextPath}/images/profiles/${profile.profileImage}"
                         class="profile-avatar-lg" alt="avatar"
                         onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                    <c:if test="${isOwn}">
                        <button class="avatar-edit-btn" onclick="openModal('uploadModal')" title="Change photo">
                            <i class="fas fa-camera"></i>
                        </button>
                    </c:if>
                </div>
                <div class="profile-details">
                    <h1><c:out value="${profile.fullName}"/></h1>
                    <c:if test="${not empty profile.location}">
                        <p class="profile-loc"><i class="fas fa-map-marker-alt"></i> <c:out value="${profile.location}"/></p>
                    </c:if>
                    <div class="stars-row rating-lg">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="fas fa-star ${i <= profile.avgRating ? 'star-on' : 'star-off'}"></i>
                        </c:forEach>
                        <span>${String.format("%.1f", profile.avgRating)} (${profile.totalReviews} reviews)</span>
                    </div>
                    <p class="profile-bio"><c:out value="${not empty profile.bio ? profile.bio : 'No bio yet.'}"/></p>
                </div>
                <c:if test="${isOwn}">
                    <button class="btn-outline" onclick="openModal('editProfileModal')">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                </c:if>
            </div>
        </div>

        
        <c:if test="${not empty skills}">
            <div class="dash-section">
                <h2><i class="fas fa-star"></i> Skills Offered</h2>
                <div class="mini-grid">
                    <c:forEach var="sk" items="${skills}">
                        <div class="mini-skill">
                            <span class="level-badge level-${fn:toLowerCase(sk.skillLevel)}">${sk.skillLevel}</span>
                            <h4><c:out value="${sk.title}"/></h4>
                            <p><c:out value="${sk.categoryName}"/></p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        
        <c:if test="${not empty reviews}">
            <div class="dash-section">
                <h2><i class="fas fa-comments"></i> Reviews</h2>
                <div class="review-list">
                    <c:forEach var="rv" items="${reviews}">
                        <div class="review-item">
                            <img src="${pageContext.request.contextPath}/images/profiles/${rv.reviewerImage}"
                                 class="review-avatar" alt="reviewer"
                                 onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                            <div class="review-body">
                                <div class="review-hdr">
                                    <strong><c:out value="${rv.reviewerName}"/></strong>
                                    <div class="stars-row">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= rv.rating ? 'star-on' : 'star-off'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="review-date">${rv.createdAt}</span>
                                </div>
                                <p><c:out value="${rv.comment}"/></p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </main>
</div>


<div class="modal-overlay" id="editProfileModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-edit"></i> Edit Profile</h3>
            <button class="modal-close" onclick="closeModal('editProfileModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/profile">
            <input type="hidden" name="action" value="updateProfile">
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" class="form-control"
                       value="<c:out value='${profile.fullName}'/>" required>
            </div>
            <div class="form-group">
                <label>Location</label>
                <input type="text" name="location" class="form-control"
                       placeholder="e.g. Kathmandu, Nepal"
                       value="<c:out value='${profile.location}'/>">
            </div>
            <div class="form-group">
                <label>Bio</label>
                <textarea name="bio" class="form-control" rows="4"
                          placeholder="Tell others about yourself…"><c:out value="${profile.bio}"/></textarea>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('editProfileModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Changes</button>
            </div>
        </form>
    </div>
</div>


<div class="modal-overlay" id="uploadModal">
    <div class="modal-box">
        <div class="modal-hdr">
            <h3><i class="fas fa-camera"></i> Update Profile Photo</h3>
            <button class="modal-close" onclick="closeModal('uploadModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/user/profile"
              enctype="multipart/form-data">
            <input type="hidden" name="action" value="uploadImage">
            <div class="form-group">
                <label>Choose Image (JPG/PNG, max 5 MB)</label>
                <input type="file" name="profileImage" class="form-control" accept="image/*" required>
            </div>
            <div class="modal-ftr">
                <button type="button" class="btn-outline" onclick="closeModal('uploadModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-upload"></i> Upload Photo</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
