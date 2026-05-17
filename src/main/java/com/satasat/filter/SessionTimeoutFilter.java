package com.satasat.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.Filter;

/**
 * Sets the HTTP session timeout to 30 minutes on every request.
 */
@WebFilter("/*")
public class SessionTimeoutFilter implements Filter {

    private static final int TIMEOUT_SECONDS = 30 * 60;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpSession sess = ((HttpServletRequest) request).getSession(false);
        if (sess != null) {
            sess.setMaxInactiveInterval(TIMEOUT_SECONDS);
        }
        chain.doFilter(request, response);
    }
}
