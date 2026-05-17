<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Login"/>
<%@ include file="../includes/header.jsp" %>

<div class="auth-page">
    <div class="auth-wrap">

        <div class="auth-left">
            <div class="auth-brand-block">
                <i class="fas fa-exchange-alt auth-brand-icon"></i>
                <h1>Welcome Back!</h1>
                <p>Sign in to continue exchanging skills and growing your knowledge on Satasat.</p>
            </div>
            <div class="auth-feature-list">
                <div class="af-item"><i class="fas fa-check-circle"></i> 100% Free Platform</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> Verified Skill Exchanges</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> Mutual Star Ratings</div>
                <div class="af-item"><i class="fas fa-check-circle"></i> No Subscriptions Ever</div>
            </div>
        </div>

        <div class="auth-card">
            <h2>Sign In</h2>

            <%-- Flash messages --%>
            <c:if test="${param.msg eq 'registered'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    Account created! Please wait for admin approval before signing in.
                </div>
            </c:if>
            <c:if test="${param.msg eq 'loggedout'}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> You have been logged out successfully.
                </div>
            </c:if>
            <c:if test="${param.error eq 'account_inactive'}">
                <div class="alert alert-danger">
                    <i class="fas fa-ban"></i> Your account is inactive. Contact the administrator.
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/login"
                  id="loginForm" novalidate>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                    <input type="email" id="email" name="email" class="form-control"
                           placeholder="your@email.com" required
                           value="<c:out value='${email}'/>">
                    <span class="field-error" id="emailErr"></span>
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Password</label>
                    <div class="pw-wrap">
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Your password" required>
                        <button type="button" class="pw-toggle" onclick="togglePw('password', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <span class="field-error" id="passwordErr"></span>
                </div>

                <div class="form-check-row">
                    <label class="form-check">
                        <input type="checkbox" name="rememberMe"> Remember me for 30 days
                    </label>
                </div>

                <button type="submit" class="btn-primary btn-block mt-16" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>

            <div class="auth-divider"><span>or</span></div>
            <p class="auth-switch">Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Sign up free</a>
            </p>

            <%-- Test credentials helper for demo/grading --%>
            <div class="cred-box">
                <p><strong><i class="fas fa-key"></i> Test Credentials</strong></p>
                <div class="cred-row">
                    <span>Admin:</span>
                    <code>admin@satasat.com</code>
                    <code>Admin@123</code>
                </div>
                <div class="cred-row">
                    <span>User:</span>
                    <code>saimon@satasat.com</code>
                    <code>Test@1234</code>
                </div>
            </div>
        </div>

    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
