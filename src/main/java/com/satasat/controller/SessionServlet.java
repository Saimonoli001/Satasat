package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import javax.servlet.http.HttpServlet;

@WebServlet("/user/sessions")
public class SessionServlet extends HttpServlet {
    private final SessionDAO sessionDAO = new SessionDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("sessions", sessionDAO.findByUser(user.getId()));
        req.getRequestDispatcher("/views/user/sessions.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user   = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        if ("complete".equals(action)) {
            int sid = Integer.parseInt(req.getParameter("sessionId"));
            Session s = sessionDAO.findById(sid);
            if (s != null && (s.getRequesterId() == user.getId() || s.getReceiverId() == user.getId())) {
                sessionDAO.markComplete(sid);
            }
        } else if ("review".equals(action)) {
            int sid        = Integer.parseInt(req.getParameter("sessionId"));
            int revieweeId = Integer.parseInt(req.getParameter("revieweeId"));
            int rating     = Integer.parseInt(req.getParameter("rating"));
            if (!reviewDAO.hasReviewed(sid, user.getId())) {
                Review r = new Review();
                r.setSessionId(sid); r.setReviewerId(user.getId());
                r.setRevieweeId(revieweeId); r.setRating(rating);
                r.setComment(req.getParameter("comment"));
                reviewDAO.create(r);
                userDAO.recalcRating(revieweeId);
                req.getSession().setAttribute("loggedInUser", userDAO.findById(user.getId()));
            }
        }
        res.sendRedirect(req.getContextPath() + "/user/sessions");
    }
}
