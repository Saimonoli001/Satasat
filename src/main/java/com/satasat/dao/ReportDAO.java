package com.satasat.dao;

import com.satasat.model.Report;
import com.satasat.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public int create(Report report) {
        String sql = "INSERT INTO reports (reporter_id, reported_user_id, subject, description) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, report.getReporterId());
            if (report.getReportedUserId() > 0) ps.setInt(2, report.getReportedUserId());
            else ps.setNull(2, Types.INTEGER);
            ps.setString(3, report.getSubject());
            ps.setString(4, report.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<Report> findAll() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.id " +
                     "LEFT JOIN users u2 ON r.reported_user_id = u2.id " +
                     "ORDER BY r.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Report findById(int id) {
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.id " +
                     "LEFT JOIN users u2 ON r.reported_user_id = u2.id " +
                     "WHERE r.id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Report> findByReporter(int reporterId) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.id " +
                     "LEFT JOIN users u2 ON r.reported_user_id = u2.id " +
                     "WHERE r.reporter_id = ? ORDER BY r.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reporterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean reply(int id, String reply) {
        String sql = "UPDATE reports SET admin_reply=?, status='RESOLVED', updated_at=NOW() WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE reports SET status=?, updated_at=NOW() WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countOpen() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM reports WHERE status='OPEN'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Report map(ResultSet rs) throws SQLException {
        Report r = new Report();
        r.setId(rs.getInt("id"));
        r.setReporterId(rs.getInt("reporter_id"));
        r.setReporterName(rs.getString("reporter_name"));
        r.setReportedUserId(rs.getInt("reported_user_id"));
        r.setReportedUserName(rs.getString("reported_name"));
        r.setSubject(rs.getString("subject"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setAdminReply(rs.getString("admin_reply"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUpdatedAt(rs.getTimestamp("updated_at"));
        return r;
    }
}
