package com.satasat.filter;

import com.satasat.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;


@WebFilter(urlPatterns = {"/user/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse res  = (HttpServletResponse) response;
        HttpSession         sess = req.getSession(false);

        
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma",        "no-cache");
        res.setDateHeader("Expires",   0);

        String requestURI = req.getRequestURI();
        User user = (sess != null) ? (User) sess.getAttribute("loggedInUser") : null;

        
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(requestURI, "UTF-8"));
            return;
        }

        
        if (!"ACTIVE".equals(user.getStatus())) {
            if (sess != null) sess.invalidate();
            res.sendRedirect(req.getContextPath() + "/login?error=account_inactive");
            return;
        }

        
        if (requestURI.contains("/admin/") && !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/user/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}
