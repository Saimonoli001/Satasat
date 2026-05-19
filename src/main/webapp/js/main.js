

'use strict';


function toggleDropdown(e) {
    e.stopPropagation();
    const dd = document.getElementById('userDropdown');
    if (dd) dd.classList.toggle('open');
}
document.addEventListener('click', () => {
    const dd = document.getElementById('userDropdown');
    if (dd) dd.classList.remove('open');
});


function toggleNav() {
    const nl = document.getElementById('navLinks');
    if (nl) nl.classList.toggle('open');
}


function openModal(id) {
    const m = document.getElementById(id);
    if (!m) return;
    m.classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeModal(id) {
    const m = document.getElementById(id);
    if (!m) return;
    m.classList.remove('open');
    document.body.style.overflow = '';
}

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', e => {
            if (e.target === overlay) closeModal(overlay.id);
        });
    });
    
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.open')
                .forEach(m => closeModal(m.id));
        }
    });
});


function togglePw(fieldId, btn) {
    const f = document.getElementById(fieldId);
    if (!f) return;
    const icon = btn ? btn.querySelector('i') : null;
    if (f.type === 'password') {
        f.type = 'text';
        if (icon) { icon.classList.replace('fa-eye', 'fa-eye-slash'); }
    } else {
        f.type = 'password';
        if (icon) { icon.classList.replace('fa-eye-slash', 'fa-eye'); }
    }
}


function checkStrength(pw) {
    let score = 0;
    if (pw.length >= 8)  score++;
    if (pw.length >= 12) score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;
    return score;
}
document.addEventListener('DOMContentLoaded', () => {
    const pwField = document.getElementById('regPwd');
    const meter   = document.getElementById('pwStrength');
    const fill    = document.getElementById('strengthFill');
    const label   = document.getElementById('strengthLabel');
    if (!pwField || !meter) return;

    pwField.addEventListener('input', () => {
        const val   = pwField.value;
        meter.style.display = val.length > 0 ? 'block' : 'none';
        const score = checkStrength(val);
        const pct   = (score / 5) * 100;
        const colors = ['#fa5252','#ff8c00','#ffa94d','#69db7c','#40c057'];
        const labels = ['Very Weak','Weak','Fair','Strong','Very Strong'];
        fill.style.width      = pct + '%';
        fill.style.background = colors[Math.min(score - 1, 4)] || '#fa5252';
        label.textContent     = labels[Math.min(score - 1, 4)] || '';
        label.style.color     = colors[Math.min(score - 1, 4)] || '#fa5252';
    });
});


document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('registerForm');
    if (!form) return;

    form.addEventListener('submit', e => {
        let ok = true;

        const name = form.querySelector('[name="fullName"]');
        const nameErr = document.getElementById('nameErr');
        if (name && name.value.trim().length < 2) {
            if (nameErr) nameErr.textContent = 'Full name must be at least 2 characters.';
            name.classList.add('is-error'); ok = false;
        } else {
            if (nameErr) nameErr.textContent = '';
            if (name) name.classList.remove('is-error');
        }

        const email    = form.querySelector('[name="email"]');
        const emailErr = document.getElementById('regEmailErr');
        const emailRx  = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
        if (email && !emailRx.test(email.value.trim())) {
            if (emailErr) emailErr.textContent = 'Please enter a valid email address.';
            email.classList.add('is-error'); ok = false;
        } else {
            if (emailErr) emailErr.textContent = '';
            if (email) email.classList.remove('is-error');
        }

        const pwd    = document.getElementById('regPwd');
        const pwdErr = document.getElementById('pwErr');
        if (pwd && pwd.value.length < 8) {
            if (pwdErr) pwdErr.textContent = 'Password must be at least 8 characters.';
            pwd.classList.add('is-error'); ok = false;
        } else if (pwd && !/[0-9]/.test(pwd.value)) {
            if (pwdErr) pwdErr.textContent = 'Password must contain at least one number.';
            pwd.classList.add('is-error'); ok = false;
        } else {
            if (pwdErr) pwdErr.textContent = '';
            if (pwd) pwd.classList.remove('is-error');
        }

        const confirm    = document.getElementById('confirmPwd');
        const confirmErr = document.getElementById('confirmErr');
        if (confirm && pwd && confirm.value !== pwd.value) {
            if (confirmErr) confirmErr.textContent = 'Passwords do not match.';
            confirm.classList.add('is-error'); ok = false;
        } else {
            if (confirmErr) confirmErr.textContent = '';
            if (confirm) confirm.classList.remove('is-error');
        }

        if (!ok) e.preventDefault();
    });
});


document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('loginForm');
    if (!form) return;
    form.addEventListener('submit', e => {
        let ok = true;
        const email    = form.querySelector('[name="email"]');
        const emailErr = document.getElementById('emailErr');
        if (email && !email.value.trim()) {
            if (emailErr) emailErr.textContent = 'Email is required.';
            ok = false;
        } else { if (emailErr) emailErr.textContent = ''; }

        const pwd    = form.querySelector('[name="password"]');
        const pwdErr = document.getElementById('passwordErr');
        if (pwd && !pwd.value) {
            if (pwdErr) pwdErr.textContent = 'Password is required.';
            ok = false;
        } else { if (pwdErr) pwdErr.textContent = ''; }

        if (!ok) e.preventDefault();
    });
});


document.addEventListener('DOMContentLoaded', () => {
    const style = document.createElement('style');
    style.textContent = '.is-error { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(250,82,82,.12) !important; }';
    document.head.appendChild(style);
});


function fillEdit(id, title, desc, level, avail, catId) {
    document.getElementById('editSkillId').value  = id;
    document.getElementById('editTitle').value    = title;
    document.getElementById('editDesc').value     = desc;
    document.getElementById('editAvail').value    = avail;
    setSelectVal('editLevel',  level);
    setSelectVal('editCatId',  catId);
    openModal('editSkillModal');
}


function fillEditCat(id, name, desc, icon, active) {
    document.getElementById('ecId').value    = id;
    document.getElementById('ecName').value  = name;
    document.getElementById('ecDesc').value  = desc;
    document.getElementById('ecIcon').value  = icon;
    setSelectVal('ecActive', active ? 'true' : 'false');
    openModal('editCatModal');
}

function setSelectVal(selectId, val) {
    const sel = document.getElementById(selectId);
    if (!sel) return;
    for (let opt of sel.options) {
        opt.selected = (opt.value == val);
    }
}


function openCounter(requestId) {
    document.getElementById('counterReqId').value = requestId;
    openModal('counterModal');
}
function openSchedule(requestId) {
    document.getElementById('schedReqId').value = requestId;
    
    const dt = document.querySelector('#scheduleModal input[type="datetime-local"]');
    if (dt) {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        dt.min = now.toISOString().slice(0, 16);
    }
    openModal('scheduleModal');
}


function openReview(sessionId, revieweeId) {
    document.getElementById('rvSessionId').value  = sessionId;
    document.getElementById('rvRevieweeId').value = revieweeId;
    setRating(5);
    openModal('reviewModal');
}


function setRating(val) {
    document.getElementById('ratingVal').value = val;
    document.querySelectorAll('.sp-star').forEach((s, i) => {
        s.classList.toggle('on', i < val);
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const stars = document.querySelectorAll('.sp-star');
    stars.forEach((s, i) => {
        s.addEventListener('mouseenter', () => {
            stars.forEach((st, j) => st.classList.toggle('on', j <= i));
        });
        s.addEventListener('mouseleave', () => {
            const cur = parseInt(document.getElementById('ratingVal')?.value || 5);
            stars.forEach((st, j) => st.classList.toggle('on', j < cur));
        });
    });
    
    setRating(5);
});


function showToast(msg, type = 'default') {
    const box = document.getElementById('toastBox');
    if (!box) return;
    const t = document.createElement('div');
    t.className = 'toast ' + type;
    const icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', default: 'fa-info-circle' };
    t.innerHTML = `<i class="fas ${icons[type] || icons.default}"></i> ${msg}`;
    box.appendChild(t);
    setTimeout(() => {
        t.style.opacity = '0'; t.style.transition = 'opacity .3s';
        setTimeout(() => t.remove(), 300);
    }, 3500);
}


document.addEventListener('DOMContentLoaded', () => {
    const p = new URLSearchParams(window.location.search);
    if (p.get('success') === 'saved')     showToast('Profile updated successfully!', 'success');
    if (p.get('success') === '1')         showToast('Action completed successfully.', 'success');
    if (p.get('msg')     === 'registered') showToast('Account created! Awaiting admin approval.', 'success');
    if (p.get('msg')     === 'loggedout')  showToast('Logged out successfully.', 'default');
});
