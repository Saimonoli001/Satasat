package com.satasat.dao;

import com.satasat.model.Session;
import com.satasat.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class SessionDAO {

    private static final String BASE_SQL =
            "SELECT s.*, b.requester_id, b.receiver_id, " +
                    "ru.full_name AS rqname, rv.full_name AS rcname, " +
                    "os.title AS otitle, rs2.title AS rtitle, " +
                    "(SELECT COUNT(*) FROM reviews r WHERE r.session_id=s.id AND r.reviewer_id=b.requester_id)>0 AS rev_rq, " +
                    "(SELECT COUNT(*) FROM reviews r WHERE r.session_id=s.id AND r.reviewer_id=b.receiver_id)>0  AS rev_rc " +
                    "FROM sessions s " +
                    "JOIN barter_requests b  ON s.request_id = b.id " +
                    "JOIN users ru ON b.requester_id = ru.id " +
                    "JOIN users rv ON b.receiver_id  = rv.id " +
                    "JOIN skills os  ON b.offered_skill_id   = os.id " +
                    "JOIN skills rs2 ON b.requested_skill_id = rs2.id ";

    public Session findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE_SQL + "WHERE s.id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Session findByRequestId(int requestId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE_SQL + "WHERE s.request_id=?")) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Session> findByUser(int userId) {
        List<Session> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     BASE_SQL + "WHERE b.requester_id=? OR b.receiver_id=? ORDER BY s.scheduled_date DESC")) {
            ps.setInt(1, userId); ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int create(Session session) {
        String sql = "INSERT INTO sessions (request_id,scheduled_date,notes,status) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, session.getRequestId());
            ps.setTimestamp(2, session.getScheduledDate());
            ps.setString(3, session.getNotes());
            ps.setString(4, session.getStatus() != null ? session.getStatus() : "PENDING");
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { if (k.next()) return k.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean schedule(int requestId, Timestamp scheduledDate, String notes) {
        String sql = "UPDATE sessions SET scheduled_date=?, notes=?, status='SCHEDULED' WHERE request_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, scheduledDate);
            ps.setString(2, notes);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean markComplete(int sessionId) {
        String sql = "UPDATE sessions SET status='COMPLETED',completed_at=NOW() WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            if (ps.executeUpdate() > 0) {
                try (PreparedStatement ps2 = c.prepareStatement(
                        "UPDATE barter_requests SET status='COMPLETED',updated_at=NOW() " +
                                "WHERE id=(SELECT request_id FROM sessions WHERE id=?)")) {
                    ps2.setInt(1, sessionId); ps2.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countCompleted() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM sessions WHERE status='COMPLETED'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Session map(ResultSet rs) throws SQLException {
        Session s = new Session();
        s.setId(rs.getInt("id"));
        s.setRequestId(rs.getInt("request_id"));
        s.setRequesterId(rs.getInt("requester_id"));
        s.setReceiverId(rs.getInt("receiver_id"));
        s.setScheduledDate(rs.getTimestamp("scheduled_date"));
        s.setCompletedAt(rs.getTimestamp("completed_at"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setNotes(rs.getString("notes"));
        s.setStatus(rs.getString("status"));
        s.setRequesterName(rs.getString("rqname"));
        s.setReceiverName(rs.getString("rcname"));
        s.setOfferedSkillTitle(rs.getString("otitle"));
        s.setRequestedSkillTitle(rs.getString("rtitle"));
        s.setReviewedByRequester(rs.getBoolean("rev_rq"));
        s.setReviewedByReceiver(rs.getBoolean("rev_rc"));
        return s;
    }
}
