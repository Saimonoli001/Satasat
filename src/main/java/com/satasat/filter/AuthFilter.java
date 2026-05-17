package com.satasat.filter;

import com.satasat.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Role-based authentication filter.
 * /user/*  -> must be logged-in USER or ADMIN
 * /admin/* -> must be logged-in ADMIN
 *
 * Also enforces session timeout and prevents caching of secured pages.
 */
@WebFilter(urlPatterns = {"/user/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse res  = (HttpServletResponse) response;
        HttpSession         sess = req.getSession(false);

        // Prevent browser caching of protected pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma",        "no-cache");
        res.setDateHeader("Expires",   0);

        String requestURI = req.getRequestURI();
        User user = (sess != null) ? (User) sess.getAttribute("loggedInUser") : null;

        // Not logged in → redirect to login
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(requestURI, "UTF-8"));
            return;
        }

        // Account not ACTIVE
        if (!"ACTIVE".equals(user.getStatus())) {
            if (sess != null) sess.invalidate();
            res.sendRedirect(req.getContextPath() + "/login?error=account_inactive");
            return;
        }

        // Admin-only route accessed by non-admin
        if (requestURI.contains("/admin/") && !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/user/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}
