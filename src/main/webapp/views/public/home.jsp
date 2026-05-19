<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Home"/>
<%@ include file="../includes/header.jsp" %>


<section class="hero">
    <div class="hero-content">
        <div class="hero-pill animate-fade-up"><i class="fas fa-exchange-alt"></i> Free Skill Exchange Platform</div>
        <h1 class="animate-fade-up delay-1">Teach What You Know.<br><span class="gradient-text">Learn What You Don't.</span></h1>
        <p class="hero-sub animate-fade-up delay-2">Nepal's peer-to-peer skill barter community. Exchange guitar lessons for Nepali lessons, Python for yoga — no money, just knowledge.</p>
        <div class="hero-btns animate-fade-up delay-3">
            <a href="${pageContext.request.contextPath}/register" class="btn-primary btn-lg"><i class="fas fa-rocket"></i> Get Started Free</a>
            <a href="${pageContext.request.contextPath}/browse"   class="btn-outline btn-lg"><i class="fas fa-search"></i> Browse Skills</a>
        </div>
        <div class="hero-stats">
            <div class="hstat"><strong>${totalUsers}+</strong><span>Learners</span></div>
            <div class="hstat-div"></div>
            <div class="hstat"><strong>${totalSkills}+</strong><span>Skills Listed</span></div>
            <div class="hstat-div"></div>
            <div class="hstat"><strong>100%</strong><span>Free Forever</span></div>
        </div>
    </div>
    <div class="hero-visual">
        <div class="exchange-demo">
            <div class="demo-card card-left">
                <i class="fas fa-guitar"></i>
                <span>Guitar Lessons</span>
            </div>
            <div class="demo-arrow"><i class="fas fa-exchange-alt"></i></div>
            <div class="demo-card card-right">
                <i class="fas fa-language"></i>
                <span>Nepali Language</span>
            </div>
        </div>
        <p class="demo-caption">Real exchange happening on Satasat</p>
    </div>
</section>


<section class="section-categories">
    <div class="container">
        <h2 class="section-title" style="color:white">Explore by Category</h2>
        <div class="cat-grid">
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/browse?category=${cat.id}" class="cat-pill">
                    <i class="${cat.icon}"></i> ${cat.name}
                </a>
            </c:forEach>
        </div>
    </div>
</section>


<section class="section-white">
    <div class="container">
        <div class="section-hdr">
            <h2 class="section-title">Featured Skills</h2>
            <a href="${pageContext.request.contextPath}/browse" class="link-more">View all <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="skills-grid">
            <c:forEach var="skill" items="${featuredSkills}">
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
                    <a href="${pageContext.request.contextPath}/skill/view?id=${skill.id}" class="btn-card-link">View Skill <i class="fas fa-arrow-right"></i></a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>


<section class="section-gray">
    <div class="container">
        <h2 class="section-title tc">How Satasat Works</h2>
        <div class="steps-grid">
            <div class="step-card">
                <div class="step-num">1</div>
                <i class="fas fa-user-plus step-ico"></i>
                <h3>Create Profile</h3>
                <p>Sign up free and list the skills you can teach others in your community.</p>
            </div>
            <div class="step-card">
                <div class="step-num">2</div>
                <i class="fas fa-search step-ico"></i>
                <h3>Find a Match</h3>
                <p>Browse skills and find someone whose teaching matches what you want to learn.</p>
            </div>
            <div class="step-card">
                <div class="step-num">3</div>
                <i class="fas fa-handshake step-ico"></i>
                <h3>Propose Exchange</h3>
                <p>"My guitar lessons for your Nepali lessons" — send your barter request.</p>
            </div>
            <div class="step-card">
                <div class="step-num">4</div>
                <i class="fas fa-star step-ico"></i>
                <h3>Learn & Review</h3>
                <p>Complete your sessions and leave mutual star ratings to build reputation.</p>
            </div>
        </div>
    </div>
</section>


<section class="section-cta">
    <h2>Ready to Start Learning?</h2>
    <p>Join a growing community of learners sharing skills across Nepal — completely free.</p>
    <a href="${pageContext.request.contextPath}/register" class="btn-primary btn-lg">
        Join Satasat Now <i class="fas fa-arrow-right"></i>
    </a>
</section>

<%@ include file="../includes/footer.jsp" %>
