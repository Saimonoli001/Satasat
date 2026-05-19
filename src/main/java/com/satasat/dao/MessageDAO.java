package com.satasat.dao;

import com.satasat.model.Message;
import com.satasat.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public int create(Message msg) {
        String sql = "INSERT INTO messages (request_id, sender_id, content) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, msg.getRequestId());
            ps.setInt(2, msg.getSenderId());
            ps.setString(3, msg.getContent());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<Message> findByRequest(int requestId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u.full_name AS sender_name, u.profile_image AS sender_image " +
                     "FROM messages m JOIN users u ON m.sender_id = u.id " +
                     "WHERE m.request_id = ? ORDER BY m.sent_at ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public List<Message> findAfter(int requestId, int afterId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u.full_name AS sender_name, u.profile_image AS sender_image " +
                     "FROM messages m JOIN users u ON m.sender_id = u.id " +
                     "WHERE m.request_id = ? AND m.id > ? ORDER BY m.sent_at ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, afterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countByRequest(int requestId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE request_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Message map(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getInt("id"));
        m.setRequestId(rs.getInt("request_id"));
        m.setSenderId(rs.getInt("sender_id"));
        m.setSenderName(rs.getString("sender_name"));
        m.setSenderImage(rs.getString("sender_image"));
        m.setContent(rs.getString("content"));
        m.setSentAt(rs.getTimestamp("sent_at"));
        return m;
    }
}
