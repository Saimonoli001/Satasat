package com.satasat.dao;

import com.satasat.model.Skill;
import com.satasat.utils.DBConnection;
import java.sql.*;
import java.util.*;

/** CRUD + search for the skills table. */
public class SkillDAO {

    private static final String BASE_SQL =
            "SELECT s.*, u.full_name AS uname, u.profile_image AS uimg, " +
                    "u.avg_rating AS urate, c.name AS cname, c.icon AS cicon " +
                    "FROM skills s " +
                    "JOIN users u ON s.user_id = u.id " +
                    "JOIN categories c ON s.category_id = c.id ";

    public Skill findById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE_SQL + "WHERE s.id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Skill> findAll() {
        List<Skill> list = new ArrayList<>();
        String sql = BASE_SQL + "WHERE s.is_active=1 AND u.status='ACTIVE' ORDER BY s.created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Skill> findByUser(int userId) {
        List<Skill> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE_SQL + "WHERE s.user_id=? ORDER BY s.created_at DESC")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Smart search: keyword (LIKE), categoryId (0 = any), minRating (0 = any). */
    public List<Skill> search(String keyword, int categoryId, double minRating) {
        List<Skill> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder(BASE_SQL +
                "WHERE s.is_active=1 AND u.status='ACTIVE' ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sb.append("AND (s.title LIKE ? OR s.description LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw);
        }
        if (categoryId > 0) { sb.append("AND s.category_id=? "); params.add(categoryId); }
        if (minRating > 0)  { sb.append("AND u.avg_rating >= ? "); params.add(minRating); }
        sb.append("ORDER BY s.created_at DESC");
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String)  ps.setString(i+1, (String) p);
                else if (p instanceof Integer) ps.setInt(i+1, (Integer) p);
                else if (p instanceof Double)  ps.setDouble(i+1, (Double) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int create(Skill skill) {
        String sql = "INSERT INTO skills (user_id,category_id,title,description,skill_level,availability) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, skill.getUserId());
            ps.setInt(2, skill.getCategoryId());
            ps.setString(3, skill.getTitle());
            ps.setString(4, skill.getDescription());
            ps.setString(5, skill.getSkillLevel());
            ps.setString(6, skill.getAvailability());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) {
                if (k.next()) return k.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Skill skill) {
        String sql = "UPDATE skills SET category_id=?,title=?,description=?,skill_level=?,availability=?,updated_at=NOW() WHERE id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, skill.getCategoryId());
            ps.setString(2, skill.getTitle());
            ps.setString(3, skill.getDescription());
            ps.setString(4, skill.getSkillLevel());
            ps.setString(5, skill.getAvailability());
            ps.setInt(6, skill.getId());
            ps.setInt(7, skill.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int skillId, int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "DELETE FROM skills WHERE id=? AND user_id=?")) {
            ps.setInt(1, skillId); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public void incrementViews(int skillId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "UPDATE skills SET view_count=view_count+1 WHERE id=?")) {
            ps.setInt(1, skillId); ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int countActive() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM skills WHERE is_active=1");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /** Returns top N skills by number of barter requests made for them. */
    public List<Map<String,Object>> getTopDemanded(int limit) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql =
                "SELECT s.title, COUNT(b.id) AS demand " +
                        "FROM skills s LEFT JOIN barter_requests b ON b.requested_skill_id=s.id " +
                        "GROUP BY s.id ORDER BY demand DESC LIMIT ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> row = new LinkedHashMap<>();
                    row.put("title", rs.getString("title"));
                    row.put("count", rs.getInt("demand"));
                    list.add(row);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Skill map(ResultSet rs) throws SQLException {
        Skill s = new Skill();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setTitle(rs.getString("title"));
        s.setDescription(rs.getString("description"));
        s.setSkillLevel(rs.getString("skill_level"));
        s.setAvailability(rs.getString("availability"));
        s.setActive(rs.getBoolean("is_active"));
        s.setViewCount(rs.getInt("view_count"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setUpdatedAt(rs.getTimestamp("updated_at"));
        s.setUserName(rs.getString("uname"));
        s.setUserProfileImage(rs.getString("uimg"));
        s.setUserAvgRating(rs.getDouble("urate"));
        s.setCategoryName(rs.getString("cname"));
        s.setCategoryIcon(rs.getString("cicon"));
        return s;
    }
}
