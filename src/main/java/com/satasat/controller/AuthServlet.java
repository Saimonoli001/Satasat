package com.satasat.controller;

import com.satasat.dao.UserDAO;
import com.satasat.model.User;
import com.satasat.utils.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;


@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        
        if ("/logout".equals(path)) {
            HttpSession sess = req.getSession(false);
            if (sess != null) sess.invalidate();
            
            Cookie cookie = new Cookie("satasat_remember", "");
            cookie.setMaxAge(0);
            cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            res.addCookie(cookie);
            res.sendRedirect(req.getContextPath() + "/login?msg=loggedout");
            return;
        }

        
        HttpSession sess = req.getSession(false);
        if (sess != null && sess.getAttribute("loggedInUser") != null) {
            User u = (User) sess.getAttribute("loggedInUser");
            res.sendRedirect(req.getContextPath() +
                    (u.isAdmin() ? "/admin/dashboard" : "/user/dashboard"));
            return;
        }

        
        if ("/login".equals(path)) {
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("satasat_remember".equals(cookie.getName())) {
                        String val = cookie.getValue();
                        if (val != null && val.contains("|")) {
                            String[] parts = val.split("\\|", 2);
                            User u = userDAO.findByEmail(parts[0]);
                            if (u != null && u.getPasswordHash().equals(parts[1]) && u.isActive()) {
                                HttpSession newSess = req.getSession(true);
                                newSess.setAttribute("loggedInUser", u);
                                res.sendRedirect(req.getContextPath() +
                                        (u.isAdmin() ? "/admin/dashboard" : "/user/dashboard"));
                                return;
                            }
                        }
                    }
                }
            }
        }

        String view = "/login".equals(path) ?
                "/views/public/login.jsp" : "/views/public/register.jsp";
        req.getRequestDispatcher(view).forward(req, res);
    }

    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/login".equals(path))    handleLogin(req, res);
        else                          handleRegister(req, res);
    }

    
    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String remember  = req.getParameter("rememberMe");

        
        if (!ValidationUtils.notEmpty(email) || !ValidationUtils.notEmpty(password)) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, res);
            return;
        }
        if (!ValidationUtils.validEmail(email)) {
            req.setAttribute("error", "Please enter a valid email address.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, res);
            return;
        }

        User user = userDAO.findByEmail(email);

        if (user == null || !PasswordHasher.verify(password, user.getPasswordHash())) {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.setAttribute("email", ValidationUtils.sanitize(email));
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, res);
            return;
        }
        if ("PENDING".equals(user.getStatus())) {
            req.setAttribute("error", "Your account is pending admin approval. Please wait.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, res);
            return;
        }
        if ("SUSPENDED".equals(user.getStatus())) {
            req.setAttribute("error", "Your account has been suspended. Contact the administrator.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, res);
            return;
        }

        
        HttpSession sess = req.getSession(true);
        sess.setAttribute("loggedInUser", user);
        sess.setAttribute("userId", user.getId());

        
        if ("on".equals(remember)) {
            Cookie cookie = new Cookie("satasat_remember",
                    user.getEmail() + "|" + user.getPasswordHash());
            cookie.setMaxAge(30 * 24 * 60 * 60);
            cookie.setHttpOnly(true);
            cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            res.addCookie(cookie);
        }

        
        String redirect = req.getParameter("redirect");
        if (ValidationUtils.notEmpty(redirect) && redirect.startsWith("/")) {
            res.sendRedirect(redirect);
            return;
        }
        res.sendRedirect(req.getContextPath() +
                (user.isAdmin() ? "/admin/dashboard" : "/user/dashboard"));
    }

    
    private void handleRegister(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String fullName  = req.getParameter("fullName");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");
        String location  = req.getParameter("location");

        
        if (!ValidationUtils.notEmpty(fullName)) {
            setErrorAndForward(req, res, "Full name is required.", email, null, null, location);
            return;
        }
        if (fullName.trim().length() < 2) {
            setErrorAndForward(req, res, "Full name must be at least 2 characters.", email, null, null, location);
            return;
        }
        if (!ValidationUtils.validEmail(email)) {
            setErrorAndForward(req, res, "Please enter a valid email address.", email, null, null, location);
            return;
        }
        if (!ValidationUtils.validPassword(password)) {
            setErrorAndForward(req, res, "Password must be at least 8 characters and contain letters and numbers.", email, null, null, location);
            return;
        }
        if (!password.equals(confirm)) {
            setErrorAndForward(req, res, "Passwords do not match.", email, null, null, location);
            return;
        }
        if (userDAO.emailExists(email)) {
            setErrorAndForward(req, res, "An account with this email already exists.", email, null, null, location);
            return;
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(PasswordHasher.hash(password));
        user.setLocation(location);
        user.setRole("USER");
        user.setStatus("ACTIVE");   

        int id = userDAO.create(user);
        if (id > 0) {
            res.sendRedirect(req.getContextPath() + "/login?msg=registered");
        } else {
            setErrorAndForward(req, res, "Registration failed. Please try again later.",
                    email, fullName, location, location);
        }
    }

    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse res,
                                    String error, String email, String fullName,
                                    String location, String loc2)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("email", email != null ? ValidationUtils.sanitize(email) : "");
        req.setAttribute("fullName", fullName != null ? ValidationUtils.sanitize(fullName) : "");
        req.setAttribute("location", location != null ? ValidationUtils.sanitize(location) : "");
        req.getRequestDispatcher("/views/public/register.jsp").forward(req, res);
    }
}
