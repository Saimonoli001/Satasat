<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"  value="Chat & Messaging"/>
<c:set var="activePage" value="requests"/>
<%@ include file="../includes/header.jsp" %>
<div class="dash-layout">
    <%@ include file="../includes/user-sidebar.jsp" %>
    <main class="dash-main">

        <%-- Check partner details --%>
        <c:set var="isRequester" value="${barterRequest.requesterId eq sessionScope.loggedInUser.id}"/>
        <c:set var="partnerId" value="${isRequester ? barterRequest.receiverId : barterRequest.requesterId}"/>
        <c:set var="partnerName" value="${isRequester ? barterRequest.receiverName : barterRequest.requesterName}"/>
        <c:set var="partnerImage" value="${isRequester ? barterRequest.receiverImage : barterRequest.requesterImage}"/>

        <div class="dash-topbar" style="display:flex; justify-content:space-between; align-items:center;">
            <h1><i class="fas fa-comments"></i> Chat with ${partnerName}</h1>
            <a href="${pageContext.request.contextPath}/user/requests" class="btn-outline">
                <i class="fas fa-arrow-left"></i> Back to Requests
            </a>
        </div>

        <div class="chat-container">
            <!-- Left Info Panel -->
            <div class="chat-thread-sidebar">
                <div class="chat-partner-card">
                    <img src="${pageContext.request.contextPath}/images/profiles/${partnerImage}"
                         class="chat-partner-avatar" alt="${partnerName}"
                         onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                    <h3 class="chat-partner-name"><c:out value="${partnerName}"/></h3>
                    <span class="text-muted">Barter Exchange Partner</span>
                </div>

                <div class="card" style="padding:16px; font-size:.9rem; border: 1px solid var(--border); border-radius: var(--radius-sm); background:white;">
                    <h4 style="margin-bottom:8px;"><i class="fas fa-info-circle"></i> Exchange Details</h4>
                    <p style="margin-bottom:6px;"><strong>Offered:</strong> <c:out value="${barterRequest.offeredSkillTitle}"/></p>
                    <p style="margin-bottom:12px;"><strong>Requested:</strong> <c:out value="${barterRequest.requestedSkillTitle}"/></p>
                    <a href="https://meet.jit.si/satasat-session-${barterRequest.id}" target="_blank" class="btn-primary btn-block" style="justify-content:center;">
                        <i class="fas fa-video"></i> Start Jitsi Video Call
                    </a>
                </div>
            </div>

            <!-- Chat Area -->
            <div class="chat-area">
                <div class="chat-header">
                    <div class="chat-header-user">
                        <img src="${pageContext.request.contextPath}/images/profiles/${partnerImage}"
                             class="chat-header-avatar" alt=""
                             onerror="this.src='${pageContext.request.contextPath}/images/profiles/default.png'">
                        <div>
                            <strong><c:out value="${partnerName}"/></strong>
                            <div style="font-size:0.75rem; color:var(--success);"><i class="fas fa-circle"></i> Active Barter Thread</div>
                        </div>
                    </div>
                </div>

                <!-- Scrollable Messages -->
                <div class="chat-messages" id="chatMessages">
                    <c:forEach var="m" items="${messages}">
                        <c:set var="isMe" value="${m.senderId eq sessionScope.loggedInUser.id}"/>
                        <div class="msg-wrapper ${isMe ? 'msg-sent' : 'msg-received'}" data-msg-id="${m.id}">
                            <div class="msg-bubble">
                                <c:out value="${m.content}"/>
                            </div>
                            <span class="msg-meta">${m.sentAt}</span>
                        </div>
                    </c:forEach>
                </div>

                <!-- Input area -->
                <div class="chat-input-container">
                    <form class="chat-input-form" id="chatForm" method="post" action="${pageContext.request.contextPath}/user/messages">
                        <input type="hidden" name="action" value="send">
                        <input type="hidden" name="requestId" value="${requestId}">
                        <input type="text" name="content" id="messageInput" class="chat-input-field" placeholder="Type your message here..." autocomplete="off" required>
                        <button type="submit" class="btn-chat-send">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    // Scroll chat to bottom initially
    const chatMsgs = document.getElementById('chatMessages');
    chatMsgs.scrollTop = chatMsgs.scrollHeight;

    // AJAX Polling for new messages
    let lastMsgId = 0;
    const msgWrappers = document.querySelectorAll('.msg-wrapper');
    if(msgWrappers.length > 0) {
        lastMsgId = parseInt(msgWrappers[msgWrappers.length - 1].getAttribute('data-msg-id'));
    }

    const currentUserId = ${sessionScope.loggedInUser.id};

    // HTML Escaping Helper for security
    function escapeHTML(str) {
        if (!str) return '';
        return str.replace(/[&<>'"]/g, 
            tag => ({
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                "'": '&#39;',
                '"': '&quot;'
            }[tag] || tag)
        );
    }

    setInterval(() => {
        // Added t= Date.now() cache buster to completely override browser GET response caching
        fetch(`${pageContext.request.contextPath}/user/messages?requestId=${requestId}&poll=1&afterId=` + lastMsgId + `&_t=` + Date.now())
            .then(res => res.json())
            .then(data => {
                if(data && data.length > 0) {
                    data.forEach(msg => {
                        // Prevent duplicates if already rendered
                        if(document.querySelector(`[data-msg-id="${msg.id}"]`)) return;

                        const isMe = msg.senderId === currentUserId;
                        const msgHtml = `
                            <div class="msg-wrapper ${isMe ? 'msg-sent' : 'msg-received'}" data-msg-id="${msg.id}">
                                <div class="msg-bubble">
                                    ${escapeHTML(msg.content)}
                                </div>
                                <span class="msg-meta">${msg.sentAt}</span>
                            </div>
                        `;
                        chatMsgs.insertAdjacentHTML('beforeend', msgHtml);
                        lastMsgId = msg.id;
                    });
                    chatMsgs.scrollTop = chatMsgs.scrollHeight;
                }
            })
            .catch(err => console.error("Error polling messages:", err));
    }, 2000);

    // AJAX submission to prevent full page reload
    const chatForm = document.getElementById('chatForm');
    chatForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const input = document.getElementById('messageInput');
        const text = input.value.trim();
        if(!text) return;

        const formData = new FormData(chatForm);
        fetch(chatForm.action, {
            method: 'POST',
            body: new URLSearchParams(formData)
        }).then(res => {
            input.value = '';
            // Trigger poll immediately
            pollImmediately();
        });
    });

    function pollImmediately() {
        // Added t= Date.now() cache buster to completely override browser GET response caching
        fetch(`${pageContext.request.contextPath}/user/messages?requestId=${requestId}&poll=1&afterId=` + lastMsgId + `&_t=` + Date.now())
            .then(res => res.json())
            .then(data => {
                if(data && data.length > 0) {
                    data.forEach(msg => {
                        // Prevent duplicates if already rendered
                        if(document.querySelector(`[data-msg-id="${msg.id}"]`)) return;

                        const isMe = msg.senderId === currentUserId;
                        const msgHtml = `
                            <div class="msg-wrapper ${isMe ? 'msg-sent' : 'msg-received'}" data-msg-id="${msg.id}">
                                <div class="msg-bubble">
                                    ${escapeHTML(msg.content)}
                                </div>
                                <span class="msg-meta">${msg.sentAt}</span>
                            </div>
                        `;
                        chatMsgs.insertAdjacentHTML('beforeend', msgHtml);
                        lastMsgId = msg.id;
                    });
                    chatMsgs.scrollTop = chatMsgs.scrollHeight;
                }
            });
    }
</script>

<%@ include file="../includes/footer.jsp" %>
