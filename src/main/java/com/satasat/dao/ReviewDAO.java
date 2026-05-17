package com.satasat.dao;

import com.satasat.model.Review;
import com.satasat.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class ReviewDAO {

    public List<Review> findByReviewee(int userId) {
        List<Review> list = new ArrayList<>();
        String sql =
                "SELECT r.*, u.full_name AS rname, u.profile_image AS rimg " +
                        "FROM reviews r JOIN users u ON r.reviewer_id=u.id " +
                        "WHERE r.reviewee_id=? ORDER BY r.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(map(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean hasReviewed(int sessionId, int reviewerId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM reviews WHERE session_id=? AND reviewer_id=?")) {
            ps.setInt(1, sessionId); ps.setInt(2, reviewerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int create(Review review) {
        String sql = "INSERT INTO reviews (session_id,reviewer_id,reviewee_id,rating,comment) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, review.getSessionId());
            ps.setInt(2, review.getReviewerId());
            ps.setInt(3, review.getRevieweeId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { if (k.next()) return k.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    private Review map(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("id"));
        r.setSessionId(rs.getInt("session_id"));
        r.setReviewerId(rs.getInt("reviewer_id"));
        r.setRevieweeId(rs.getInt("reviewee_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setReviewerName(rs.getString("rname"));
        r.setReviewerImage(rs.getString("rimg"));
        return r;
    }
}
