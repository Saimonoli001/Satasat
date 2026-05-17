package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import javax.servlet.http.HttpServlet;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final BarterRequestDAO requestDAO = new BarterRequestDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("mySkills",   skillDAO.findByUser(user.getId()));
        req.setAttribute("myRequests", requestDAO.findByUser(user.getId()));
        req.setAttribute("mySessions", sessionDAO.findByUser(user.getId()));
        req.setAttribute("myReviews",  reviewDAO.findByReviewee(user.getId()));
        req.setAttribute("incoming",   requestDAO.findIncoming(user.getId()));
        req.getRequestDispatcher("/views/user/dashboard.jsp").forward(req, res);
    }
}
