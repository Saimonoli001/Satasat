package com.satasat.controller;

import com.satasat.dao.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

@WebServlet("/browse")
public class BrowseServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String keyword    = req.getParameter("keyword");
        String catParam   = req.getParameter("category");
        String ratingParam= req.getParameter("rating");

        int categoryId = 0;
        double minRating = 0;
        try { if (catParam    != null) categoryId = Integer.parseInt(catParam);    } catch (NumberFormatException ignored) {}
        try { if (ratingParam != null) minRating  = Double.parseDouble(ratingParam);} catch (NumberFormatException ignored) {}

        req.setAttribute("skills",          skillDAO.search(keyword, categoryId, minRating));
        req.setAttribute("categories",      categoryDAO.findActive());
        req.setAttribute("keyword",         keyword);
        req.setAttribute("selectedCat",     categoryId);
        req.setAttribute("selectedRating",  minRating);
        req.getRequestDispatcher("/views/public/browse.jsp").forward(req, res);
    }
}
