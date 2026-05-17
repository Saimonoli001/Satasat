package com.satasat.controller;

import com.satasat.dao.WishlistDAO;
import com.satasat.model.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

@WebServlet("/user/wishlist")
public class WishlistServlet extends HttpServlet {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("wishlist", wishlistDAO.findByUser(user.getId()));
        req.getRequestDispatcher("/views/user/wishlist.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user  = (User) req.getSession().getAttribute("loggedInUser");
        String act = req.getParameter("action");
        int skillId = Integer.parseInt(req.getParameter("skillId"));
        if ("add".equals(act))    wishlistDAO.add(user.getId(), skillId);
        else if ("remove".equals(act)) wishlistDAO.remove(user.getId(), skillId);
        String back = req.getParameter("redirect");
        res.sendRedirect(back != null && !back.isEmpty() ? back :
                req.getContextPath() + "/user/wishlist");
    }
}
