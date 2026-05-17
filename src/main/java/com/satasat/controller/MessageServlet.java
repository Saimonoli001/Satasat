package com.satasat.controller;

import com.satasat.dao.*;
import com.satasat.model.*;
import com.satasat.utils.ValidationUtils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Handles private messaging between users in an accepted barter request.
 * GET  /user/messages?requestId=X       → show chat page
 * GET  /user/messages?requestId=X&poll=1&afterId=Y → return JSON for AJAX polling
 * POST /user/messages (action=send)    → save a new message
 */
@WebServlet("/user/messages")
public class MessageServlet extends HttpServlet {

    private final MessageDAO messageDAO = new MessageDAO();
    private final BarterRequestDAO requestDAO = new BarterRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("loggedInUser");
        String requestIdParam = req.getParameter("requestId");

        if (requestIdParam == null) {
            res.sendRedirect(req.getContextPath() + "/user/requests");
            return;
        }

        int requestId = Integer.parseInt(requestIdParam);
        BarterRequest br = requestDAO.findById(requestId);

        // Security: only participants can chat
        if (br == null || (br.getRequesterId() != user.getId() && br.getReceiverId() != user.getId())) {
            res.sendRedirect(req.getContextPath() + "/user/requests");
            return;
        }

        // AJAX poll for new messages only
        String poll = req.getParameter("poll");
        if ("1".equals(poll)) {
            int afterId = 0;
            try { afterId = Integer.parseInt(req.getParameter("afterId")); } catch (Exception ignored) {}
            List<Message> newMsgs = messageDAO.findAfter(requestId, afterId);

            res.setContentType("application/json;charset=UTF-8");
            PrintWriter out = res.getWriter();
            out.print("[");
            for (int i = 0; i < newMsgs.size(); i++) {
                Message m = newMsgs.get(i);
                String image = m.getSenderImage() != null && !m.getSenderImage().isEmpty()
                        ? m.getSenderImage() : "default.png";
                out.print("{");
                out.print("\"id\":" + m.getId() + ",");
                out.print("\"senderId\":" + m.getSenderId() + ",");
                out.print("\"senderName\":\"" + escapeJson(m.getSenderName()) + "\",");
                out.print("\"senderImage\":\"" + escapeJson(image) + "\",");
                out.print("\"content\":\"" + escapeJson(m.getContent()) + "\",");
                out.print("\"sentAt\":\"" + m.getSentAt() + "\"");
                out.print("}");
                if (i < newMsgs.size() - 1) out.print(",");
            }
            out.print("]");
            return;
        }

        // Full page load
        req.setAttribute("barterRequest", br);
        req.setAttribute("messages", messageDAO.findByRequest(requestId));
        req.setAttribute("requestId", requestId);
        req.getRequestDispatcher("/views/user/messages.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");
        int requestId = Integer.parseInt(req.getParameter("requestId"));

        if ("send".equals(action)) {
            String content = req.getParameter("content");
            if (ValidationUtils.notEmpty(content)) {
                BarterRequest br = requestDAO.findById(requestId);
                if (br != null && (br.getRequesterId() == user.getId() || br.getReceiverId() == user.getId())) {
                    Message msg = new Message();
                    msg.setRequestId(requestId);
                    msg.setSenderId(user.getId());
                    msg.setContent(content.trim());
                    messageDAO.create(msg);
                }
            }
        }
        res.sendRedirect(req.getContextPath() + "/user/messages?requestId=" + requestId);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
