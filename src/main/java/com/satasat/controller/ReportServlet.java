package com.satasat.controller;

import com.satasat.dao.ReportDAO;
import com.satasat.dao.UserDAO;
import com.satasat.model.Report;
import com.satasat.model.User;
import com.satasat.utils.ValidationUtils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;


@WebServlet("/user/report")
public class ReportServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();
    private final UserDAO userDAO     = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("myReports", reportDAO.findByReporter(user.getId()));
        req.setAttribute("allUsers", userDAO.findAll());
        req.getRequestDispatcher("/views/user/report.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String subject = req.getParameter("subject");
        String description = req.getParameter("description");

        if (!ValidationUtils.notEmpty(subject) || !ValidationUtils.notEmpty(description)) {
            req.setAttribute("error", "Subject and description are required.");
            req.setAttribute("myReports", reportDAO.findByReporter(user.getId()));
            req.setAttribute("allUsers", userDAO.findAll());
            req.getRequestDispatcher("/views/user/report.jsp").forward(req, res);
            return;
        }

        Report report = new Report();
        report.setReporterId(user.getId());
        report.setSubject(subject.trim());
        report.setDescription(description.trim());

        String reportedUserIdStr = req.getParameter("reportedUserId");
        if (ValidationUtils.notEmpty(reportedUserIdStr)) {
            try { report.setReportedUserId(Integer.parseInt(reportedUserIdStr)); }
            catch (NumberFormatException ignored) {}
        }

        int id = reportDAO.create(report);
        if (id > 0) {
            res.sendRedirect(req.getContextPath() + "/user/report?success=1");
        } else {
            req.setAttribute("error", "Failed to submit report. Please try again.");
            req.getRequestDispatcher("/views/user/report.jsp").forward(req, res);
        }
    }
}
