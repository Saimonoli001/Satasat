<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Account"/>
<%@ include file="../includes/header.jsp" %>

<div class="auth-page">
    <div class="auth-wrap">

        <div class="auth-left">
            <div class="auth-brand-block">
                <i class="fas fa-exchange-alt auth-brand-icon"></i>
                <h1>Join Satasat</h1>
                <p>Create your free account and start exchanging skills with people across Nepal.</p>
            </div>
            <div class="auth-feature-list">
                <div class="af-item"><i class="fas fa-check-circle"></i> Post unlimited skills</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> Send exchange requests</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> Build your reputation</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> Schedule learning sessions</div>
            </div>
        </div>

        <div class="auth-card">
            <h2>Create Account</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/register"
                  id="registerForm" novalidate>

                <div class="form-group">
                    <label for="fullName"><i class="fas fa-user"></i> Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control"
                           placeholder="Your full name" required minlength="2"
                           value="<c:out value='${fullName}'/>">
                    <span class="field-error" id="nameErr"></span>
                </div>

                <div class="form-group">
                    <label for="regEmail"><i class="fas fa-envelope"></i> Email Address *</label>
                    <input type="email" id="regEmail" name="email" class="form-control"
                           placeholder="you@example.com" required
                           value="<c:out value='${email}'/>">
                    <span class="field-error" id="regEmailErr"></span>
                </div>

                <div class="form-group">
                    <label for="location"><i class="fas fa-map-marker-alt"></i> Location</label>
                    <input type="text" id="location" name="location" class="form-control"
                           placeholder="e.g. Kathmandu, Nepal"
                           value="<c:out value='${location}'/>">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="regPwd"><i class="fas fa-lock"></i> Password *</label>
                        <div class="pw-wrap">
                            <input type="password" id="regPwd" name="password" class="form-control"
                                   placeholder="Min 8 chars + number" required>
                            <button type="button" class="pw-toggle" onclick="togglePw('regPwd', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <span class="field-error" id="pwErr"></span>
                    </div>
                    <div class="form-group">
                        <label for="confirmPwd"><i class="fas fa-lock"></i> Confirm Password *</label>
                        <div class="pw-wrap">
                            <input type="password" id="confirmPwd" name="confirmPassword" class="form-control"
                                   placeholder="Repeat password" required>
                            <button type="button" class="pw-toggle" onclick="togglePw('confirmPwd', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <span class="field-error" id="confirmErr"></span>
                    </div>
                </div>

                <div class="password-strength" id="pwStrength" style="display:none">
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                    <span id="strengthLabel"></span>
                </div>

                <button type="submit" class="btn-primary btn-block mt-16" id="regBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="auth-divider"><span>or</span></div>
            <p class="auth-switch">Already have an account?
                <a href="${pageContext.request.contextPath}/login">Sign in</a>
            </p>
            <p class="auth-note">
                <i class="fas fa-info-circle"></i>
                New accounts require admin approval before you can log in.
            </p>
        </div>

    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
