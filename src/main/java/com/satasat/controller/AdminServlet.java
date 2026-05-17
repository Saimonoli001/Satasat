package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import com.satasat.utils.ValidationUtils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.util.stream.Collectors;

/**
 * Part 4: Admin Dashboard – full CRUD for users and categories,
 * analytics, with proper validation and audit logging.
 * Also handles user reports management.
 */
@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/categories",
        "/admin/analytics",
        "/admin/reports"
})
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO         = new UserDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SkillDAO skillDAO       = new SkillDAO();
    private final BarterRequestDAO reqDAO = new BarterRequestDAO();
    private final SessionDAO sessionDAO   = new SessionDAO();
    private final AdminLogDAO logDAO      = new AdminLogDAO();
    private final ReportDAO reportDAO     = new ReportDAO();

    // ---------------------------------------------------------------- GET
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        switch (req.getServletPath()) {

            case "/admin/dashboard":
                req.setAttribute("totalUsers",    userDAO.countByRole("USER"));
                req.setAttribute("totalSkills",   skillDAO.countActive());
                req.setAttribute("totalRequests", reqDAO.countAll());
                req.setAttribute("completedSessions", sessionDAO.countCompleted());
                req.setAttribute("pendingUsers",  userDAO.findByStatus("PENDING"));
                req.setAttribute("recentUsers",
                        userDAO.findAll().stream().limit(5).collect(Collectors.toList()));
                req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, res);
                break;

            case "/admin/users":
                req.setAttribute("users", userDAO.findAll());
                req.getRequestDispatcher("/views/admin/users.jsp").forward(req, res);
                break;

            case "/admin/categories":
                req.setAttribute("categories", categoryDAO.findAll());
                req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, res);
                break;

            case "/admin/analytics":
                req.setAttribute("topSkills",     skillDAO.getTopDemanded(10));
                req.setAttribute("activeUsers",   userDAO.getMostActive(10));
                req.setAttribute("totalUsers",    userDAO.countByRole("USER"));
                req.setAttribute("totalSkills",   skillDAO.countActive());
                req.setAttribute("totalRequests", reqDAO.countAll());
                req.setAttribute("completedCount",reqDAO.countCompleted());
                req.setAttribute("sessionsDone",  sessionDAO.countCompleted());
                req.getRequestDispatcher("/views/admin/analytics.jsp").forward(req, res);
                break;

            case "/admin/reports":
                req.setAttribute("reports", reportDAO.findAll());
                req.setAttribute("openCount", reportDAO.countOpen());
                req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, res);
                break;
        }
    }

    // ---------------------------------------------------------------- POST
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User admin  = (User) req.getSession().getAttribute("loggedInUser");
        String path = req.getServletPath();
        String act  = req.getParameter("action");

        // ---- USER MANAGEMENT ----
        if ("/admin/users".equals(path)) {
            int targetId = Integer.parseInt(req.getParameter("userId"));
            switch (act == null ? "" : act) {
                case "approve":
                    userDAO.updateStatus(targetId, "ACTIVE");
                    logDAO.log(admin.getId(), "APPROVE_USER", "USER", targetId, "User approved.");
                    break;
                case "suspend":
                    userDAO.updateStatus(targetId, "SUSPENDED");
                    logDAO.log(admin.getId(), "SUSPEND_USER", "USER", targetId, "User suspended.");
                    break;
                case "activate":
                    userDAO.updateStatus(targetId, "ACTIVE");
                    logDAO.log(admin.getId(), "ACTIVATE_USER", "USER", targetId, "User reactivated.");
                    break;
                case "delete":
                    userDAO.delete(targetId);
                    logDAO.log(admin.getId(), "DELETE_USER", "USER", targetId, "User deleted.");
                    break;
            }
            res.sendRedirect(req.getContextPath() + "/admin/users?success=1");
            return;
        }

        // ---- CATEGORY CRUD ----
        if ("/admin/categories".equals(path)) {
            if ("add".equals(act)) {
                String name = req.getParameter("name");
                if (!ValidationUtils.notEmpty(name)) {
                    req.setAttribute("error", "Category name is required.");
                    req.setAttribute("categories", categoryDAO.findAll());
                    req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, res);
                    return;
                }
                Category cat = new Category();
                cat.setName(name.trim());
                cat.setDescription(req.getParameter("description"));
                cat.setIcon(ValidationUtils.notEmpty(req.getParameter("icon"))
                        ? req.getParameter("icon").trim() : "fas fa-star");
                cat.setActive(true);
                int id = categoryDAO.create(cat);
                logDAO.log(admin.getId(), "CREATE_CATEGORY", "CATEGORY", id, "Created: " + cat.getName());

            } else if ("edit".equals(act)) {
                int id = Integer.parseInt(req.getParameter("categoryId"));
                String name = req.getParameter("name");
                if (!ValidationUtils.notEmpty(name)) {
                    req.setAttribute("error", "Category name cannot be empty.");
                    req.setAttribute("categories", categoryDAO.findAll());
                    req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, res);
                    return;
                }
                Category cat = new Category();
                cat.setId(id);
                cat.setName(name.trim());
                cat.setDescription(req.getParameter("description"));
                cat.setIcon(ValidationUtils.notEmpty(req.getParameter("icon"))
                        ? req.getParameter("icon").trim() : "fas fa-star");
                cat.setActive("true".equals(req.getParameter("isActive")));
                categoryDAO.update(cat);
                logDAO.log(admin.getId(), "EDIT_CATEGORY", "CATEGORY", id, "Updated: " + cat.getName());

            } else if ("delete".equals(act)) {
                int id = Integer.parseInt(req.getParameter("categoryId"));
                categoryDAO.delete(id);
                logDAO.log(admin.getId(), "DELETE_CATEGORY", "CATEGORY", id, "Category deleted.");
            }
            res.sendRedirect(req.getContextPath() + "/admin/categories?success=1");
            return;
        }

        // ---- REPORTS MANAGEMENT ----
        if ("/admin/reports".equals(path)) {
            int reportId = Integer.parseInt(req.getParameter("reportId"));
            if ("reply".equals(act)) {
                String reply = req.getParameter("adminReply");
                if (ValidationUtils.notEmpty(reply)) {
                    reportDAO.reply(reportId, reply);
                    logDAO.log(admin.getId(), "REPLY_REPORT", "REPORT", reportId, "Admin replied to report.");
                }
            } else if ("close".equals(act)) {
                reportDAO.updateStatus(reportId, "CLOSED");
                logDAO.log(admin.getId(), "CLOSE_REPORT", "REPORT", reportId, "Report closed.");
            } else if ("reopen".equals(act)) {
                reportDAO.updateStatus(reportId, "OPEN");
            }
            res.sendRedirect(req.getContextPath() + "/admin/reports?success=1");
        }
    }
}
