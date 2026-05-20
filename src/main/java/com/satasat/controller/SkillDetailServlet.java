package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

@WebServlet("/skill/view")
public class SkillDetailServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) { res.sendRedirect(req.getContextPath() + "/browse"); return; }
        int skillId;
        try { skillId = Integer.parseInt(idParam); }
        catch (NumberFormatException e) { res.sendRedirect(req.getContextPath() + "/browse"); return; }

        Skill skill = skillDAO.findById(skillId);
        if (skill == null) { res.sendRedirect(req.getContextPath() + "/browse"); return; }
        skillDAO.incrementViews(skillId);

        HttpSession sess = req.getSession(false);
        User loggedIn = (sess != null) ? (User) sess.getAttribute("loggedInUser") : null;

        req.setAttribute("skill", skill);
        req.setAttribute("inWishlist", loggedIn != null && wishlistDAO.exists(loggedIn.getId(), skillId));
        if (loggedIn != null) {
            req.setAttribute("mySkills", new SkillDAO().findByUser(loggedIn.getId()));
        }
        req.getRequestDispatcher("/views/pages/skill-detail.jsp").forward(req, res);
    }
}
