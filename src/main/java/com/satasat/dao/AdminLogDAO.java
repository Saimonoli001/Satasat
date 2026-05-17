package com.satasat.dao;

import com.satasat.utils.DBConnection;
import java.sql.*;

/** Writes entries to the admin_logs audit table. */
public class AdminLogDAO {

    public void log(int adminId, String action, String targetType, int targetId, String details) {
        String sql = "INSERT INTO admin_logs (admin_id,action,target_type,target_id,details) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, action);
            ps.setString(3, targetType);
            ps.setInt(4, targetId);
            ps.setString(5, details);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
