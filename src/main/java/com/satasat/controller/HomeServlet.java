package com.satasat.controller;

import com.satasat.dao.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServlet;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("featuredSkills",
                skillDAO.findAll().stream().limit(6).collect(Collectors.toList()));
        req.setAttribute("categories",   categoryDAO.findActive());
        req.setAttribute("totalUsers",   userDAO.countByRole("USER"));
        req.setAttribute("totalSkills",  skillDAO.countActive());
        req.getRequestDispatcher("/views/public/home.jsp").forward(req, res);
    }
}
