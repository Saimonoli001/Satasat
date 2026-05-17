package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import javax.servlet.http.HttpServlet;

@WebServlet("/user/requests")
public class BarterRequestServlet extends HttpServlet {
    private final BarterRequestDAO requestDAO = new BarterRequestDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        req.setAttribute("requests", requestDAO.findByUser(user.getId()));
        req.setAttribute("mySkills", skillDAO.findByUser(user.getId()));
        req.getRequestDispatcher("/views/user/requests.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user   = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "send": {
                BarterRequest br = new BarterRequest();
                br.setRequesterId(user.getId());
                br.setReceiverId(Integer.parseInt(req.getParameter("receiverId")));
                br.setOfferedSkillId(Integer.parseInt(req.getParameter("offeredSkillId")));
                br.setRequestedSkillId(Integer.parseInt(req.getParameter("requestedSkillId")));
                br.setMessage(req.getParameter("message"));
                requestDAO.create(br);
                break;
            }
            case "accept": case "reject": case "cancel": {
                int id = Integer.parseInt(req.getParameter("requestId"));
                BarterRequest br = requestDAO.findById(id);
                if (br == null) break;
                boolean allowed = ("accept".equals(action) || "reject".equals(action))
                        ? br.getReceiverId() == user.getId()
                        : br.getRequesterId() == user.getId();
                if (allowed) {
                    requestDAO.updateStatus(id, action.toUpperCase());
                    if ("accept".equals(action)) {
                        Session sess = new Session();
                        sess.setRequestId(id);
                        sess.setStatus("PENDING");
                        sessionDAO.create(sess);
                    }
                }
                break;
            }
            case "counter": {
                int id = Integer.parseInt(req.getParameter("requestId"));
                BarterRequest br = requestDAO.findById(id);
                if (br != null && br.getReceiverId() == user.getId()) {
                    requestDAO.counterOffer(id, req.getParameter("counterMessage"));
                }
                break;
            }
            case "schedule": {
                int id = Integer.parseInt(req.getParameter("requestId"));
                BarterRequest br = requestDAO.findById(id);
                if (br != null && "ACCEPTED".equals(br.getStatus()) &&
                        (br.getRequesterId() == user.getId() || br.getReceiverId() == user.getId())) {
                    String dt = req.getParameter("scheduledDate").replace("T", " ");
                    java.sql.Timestamp scheduledTime = java.sql.Timestamp.valueOf(dt + ":00");
                    String notes = req.getParameter("notes");
                    sessionDAO.schedule(id, scheduledTime, notes);
                }
                break;
            }
        }
        res.sendRedirect(req.getContextPath() + "/user/requests");
    }
}
