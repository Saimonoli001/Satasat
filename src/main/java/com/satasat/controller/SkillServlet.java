package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import com.satasat.utils.ValidationUtils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import javax.servlet.http.HttpServlet;

@WebServlet("/user/skills")
public class SkillServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("mySkills",  skillDAO.findByUser(user.getId()));
        req.setAttribute("categories", categoryDAO.findActive());
        req.getRequestDispatcher("/views/user/skills.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user   = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String title = req.getParameter("title");
            String desc  = req.getParameter("description");
            if (!ValidationUtils.notEmpty(title) || !ValidationUtils.notEmpty(desc)) {
                req.setAttribute("error", "Title and description are required.");
                doGet(req, res); return;
            }
            Skill s = new Skill();
            s.setUserId(user.getId());
            s.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            s.setTitle(title.trim());
            s.setDescription(desc.trim());
            s.setSkillLevel(req.getParameter("skillLevel"));
            s.setAvailability(req.getParameter("availability"));
            skillDAO.create(s);

        } else if ("edit".equals(action)) {
            Skill s = new Skill();
            s.setId(Integer.parseInt(req.getParameter("skillId")));
            s.setUserId(user.getId());
            s.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            s.setTitle(req.getParameter("title").trim());
            s.setDescription(req.getParameter("description").trim());
            s.setSkillLevel(req.getParameter("skillLevel"));
            s.setAvailability(req.getParameter("availability"));
            skillDAO.update(s);

        } else if ("delete".equals(action)) {
            skillDAO.delete(Integer.parseInt(req.getParameter("skillId")), user.getId());
        }
        res.sendRedirect(req.getContextPath() + "/user/skills");
    }
}
