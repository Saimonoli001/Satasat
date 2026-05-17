package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.User;
import com.satasat.utils.ValidationUtils;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.nio.file.*;

@WebServlet("/user/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User viewer  = (User) req.getSession().getAttribute("loggedInUser");
        String idParam = req.getParameter("id");
        User profile = (idParam != null) ? userDAO.findById(Integer.parseInt(idParam)) : viewer;
        if (profile == null) { res.sendRedirect(req.getContextPath() + "/user/dashboard"); return; }
        req.setAttribute("profile",  profile);
        req.setAttribute("reviews",  reviewDAO.findByReviewee(profile.getId()));
        req.setAttribute("skills",   new SkillDAO().findByUser(profile.getId()));
        req.setAttribute("isOwn",    profile.getId() == viewer.getId());
        req.getRequestDispatcher("/views/user/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user   = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = req.getParameter("fullName");
            if (!ValidationUtils.notEmpty(fullName)) {
                req.setAttribute("error", "Full name cannot be empty.");
                doGet(req, res); return;
            }
            user.setFullName(fullName.trim());
            user.setBio(req.getParameter("bio"));
            user.setLocation(req.getParameter("location"));
            userDAO.update(user);
            User updated = userDAO.findById(user.getId());
            req.getSession().setAttribute("loggedInUser", updated);
            res.sendRedirect(req.getContextPath() + "/user/profile?success=saved");

        } else if ("uploadImage".equals(action)) {
            Part filePart = req.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String ext = "jpg";
                String ct  = filePart.getContentType();
                if (ct != null && ct.contains("png")) ext = "png";
                String fileName = "user_" + user.getId() + "_" + System.currentTimeMillis() + "." + ext;
                String uploadDir = getServletContext().getRealPath("/images/profiles/");
                Files.createDirectories(Paths.get(uploadDir));
                filePart.write(uploadDir + fileName);
                userDAO.updateProfileImage(user.getId(), fileName);
                User updated = userDAO.findById(user.getId());
                req.getSession().setAttribute("loggedInUser", updated);
            }
            res.sendRedirect(req.getContextPath() + "/user/profile");
        }
    }
}
