package com.satasat.dao;

import com.satasat.model.BarterRequest;
import com.satasat.utils.DBConnection;
import java.sql.*;
import java.util.*;

/** CRUD for barter_requests table with full JOIN. */
public class BarterRequestDAO {

    private static final String BASE_SQL =
            "SELECT b.*, " +
                    "ru.full_name AS rqname, ru.profile_image AS rqimg, " +
                    "rv.full_name AS rcname, rv.profile_image AS rcimg, " +
                    "os.title AS otitle, rs2.title AS rtitle " +
                    "FROM barter_requests b " +
                    "JOIN users  ru  ON b.requester_id       = ru.id " +
                    "JOIN users  rv  ON b.receiver_id         = rv.id " +
                    "JOIN skills os  ON b.offered_skill_id    = os.id " +
                    "JOIN skills rs2 ON b.requested_skill_id  = rs2.id ";

    public BarterRequest findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE_SQL + "WHERE b.id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<BarterRequest> findByUser(int userId) {
        List<BarterRequest> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     BASE_SQL + "WHERE b.requester_id=? OR b.receiver_id=? ORDER BY b.created_at DESC")) {
            ps.setInt(1, userId); ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<BarterRequest> findIncoming(int userId) {
        List<BarterRequest> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     BASE_SQL + "WHERE b.receiver_id=? AND b.status IN ('PENDING','COUNTERED') ORDER BY b.created_at DESC")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int create(BarterRequest req) {
        String sql = "INSERT INTO barter_requests (requester_id,receiver_id,offered_skill_id,requested_skill_id,message) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, req.getRequesterId()); ps.setInt(2, req.getReceiverId());
            ps.setInt(3, req.getOfferedSkillId()); ps.setInt(4, req.getRequestedSkillId());
            ps.setString(5, req.getMessage());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { if (k.next()) return k.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean updateStatus(int id, String status) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "UPDATE barter_requests SET status=?,updated_at=NOW() WHERE id=?")) {
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean counterOffer(int id, String counterMsg) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "UPDATE barter_requests SET status='COUNTERED',counter_message=?,updated_at=NOW() WHERE id=?")) {
            ps.setString(1, counterMsg); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countAll() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM barter_requests");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countCompleted() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM barter_requests WHERE status='COMPLETED'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private BarterRequest map(ResultSet rs) throws SQLException {
        BarterRequest b = new BarterRequest();
        b.setId(rs.getInt("id"));
        b.setRequesterId(rs.getInt("requester_id"));
        b.setReceiverId(rs.getInt("receiver_id"));
        b.setOfferedSkillId(rs.getInt("offered_skill_id"));
        b.setRequestedSkillId(rs.getInt("requested_skill_id"));
        b.setMessage(rs.getString("message"));
        b.setCounterMessage(rs.getString("counter_message"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        b.setRequesterName(rs.getString("rqname"));
        b.setRequesterImage(rs.getString("rqimg"));
        b.setReceiverName(rs.getString("rcname"));
        b.setReceiverImage(rs.getString("rcimg"));
        b.setOfferedSkillTitle(rs.getString("otitle"));
        b.setRequestedSkillTitle(rs.getString("rtitle"));
        return b;
    }
}
