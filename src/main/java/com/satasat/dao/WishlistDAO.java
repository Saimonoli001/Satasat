package com.satasat.dao;

import com.satasat.model.Skill;
import com.satasat.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class WishlistDAO {

    public List<Skill> findByUser(int userId) {
        List<Skill> list = new ArrayList<>();
        String sql =
                "SELECT s.*, u.full_name AS uname, u.profile_image AS uimg, " +
                        "u.avg_rating AS urate, c.name AS cname, c.icon AS cicon " +
                        "FROM wishlist w " +
                        "JOIN skills s ON w.skill_id = s.id " +
                        "JOIN users u ON s.user_id = u.id " +
                        "JOIN categories c ON s.category_id = c.id " +
                        "WHERE w.user_id=? AND s.is_active=1 ORDER BY w.added_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Skill sk = new Skill();
                    sk.setId(rs.getInt("id")); sk.setUserId(rs.getInt("user_id"));
                    sk.setCategoryId(rs.getInt("category_id"));
                    sk.setTitle(rs.getString("title"));
                    sk.setDescription(rs.getString("description"));
                    sk.setSkillLevel(rs.getString("skill_level"));
                    sk.setAvailability(rs.getString("availability"));
                    sk.setActive(rs.getBoolean("is_active"));
                    sk.setUserName(rs.getString("uname"));
                    sk.setUserProfileImage(rs.getString("uimg"));
                    sk.setUserAvgRating(rs.getDouble("urate"));
                    sk.setCategoryName(rs.getString("cname"));
                    sk.setCategoryIcon(rs.getString("cicon"));
                    list.add(sk);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean add(int userId, int skillId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "INSERT IGNORE INTO wishlist (user_id,skill_id) VALUES (?,?)")) {
            ps.setInt(1, userId); ps.setInt(2, skillId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean remove(int userId, int skillId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "DELETE FROM wishlist WHERE user_id=? AND skill_id=?")) {
            ps.setInt(1, userId); ps.setInt(2, skillId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean exists(int userId, int skillId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT 1 FROM wishlist WHERE user_id=? AND skill_id=?")) {
            ps.setInt(1, userId); ps.setInt(2, skillId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
