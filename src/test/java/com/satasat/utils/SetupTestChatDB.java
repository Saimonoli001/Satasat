package com.satasat.utils;

import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SetupTestChatDB {
    @Test
    public void setupData() throws Exception {
        System.out.println("--- Seeding Saimon and Rahul Chat Data ---");
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                
                int rahulId = -1;
                try (PreparedStatement pstmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?")) {
                    pstmt.setString(1, "rahul@satasat.com");
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            rahulId = rs.getInt(1);
                        }
                    }
                }

                if (rahulId == -1) {
                    
                    String insertUser = "INSERT INTO users (full_name, email, password_hash, role, status, created_at, updated_at) " +
                                        "VALUES ('Rahul Tamang', 'rahul@satasat.com', ?, 'USER', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                    try (PreparedStatement pstmt = conn.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {
                        pstmt.setString(1, PasswordHasher.hash("Test@1234"));
                        pstmt.executeUpdate();
                        try (ResultSet rs = pstmt.getGeneratedKeys()) {
                            if (rs.next()) {
                                rahulId = rs.getInt(1);
                            }
                        }
                    }
                }
                System.out.println("Rahul User ID: " + rahulId);

                
                int rahulSkillId = -1;
                String insertSkill = "INSERT INTO skills (user_id, category_id, title, description, skill_level, availability, is_active, view_count, created_at, updated_at) " +
                                     "VALUES (?, 2, 'Language Tutoring', 'I can teach English fluently.', 'EXPERT', 'Weekdays', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSkill, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, rahulId);
                    pstmt.executeUpdate();
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            rahulSkillId = rs.getInt(1);
                        }
                    }
                }
                System.out.println("Rahul Skill ID: " + rahulSkillId);

                
                int saimonSkillId = -1;
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT id FROM skills WHERE user_id = 2")) {
                    if (rs.next()) {
                        saimonSkillId = rs.getInt(1);
                    }
                }
                System.out.println("Saimon Skill ID: " + saimonSkillId);

                
                int requestId = -1;
                String insertRequest = "INSERT INTO barter_requests (requester_id, receiver_id, offered_skill_id, requested_skill_id, message, counter_message, status, created_at, updated_at) " +
                                       "VALUES (?, 2, ?, ?, 'Hi Saimon, lets exchange skills!', '', 'ACCEPTED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertRequest, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, rahulId);
                    pstmt.setInt(2, rahulSkillId);
                    pstmt.setInt(3, saimonSkillId);
                    pstmt.executeUpdate();
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            requestId = rs.getInt(1);
                        }
                    }
                }
                System.out.println("Barter Request ID generated: " + requestId);

                
                int sessionId = -1;
                String insertSession = "INSERT INTO sessions (request_id, scheduled_date, status, created_at) " +
                                       "VALUES (?, CURRENT_TIMESTAMP, 'SCHEDULED', CURRENT_TIMESTAMP)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSession, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, requestId);
                    pstmt.executeUpdate();
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            sessionId = rs.getInt(1);
                        }
                    }
                }
                System.out.println("Session ID generated: " + sessionId);

                
                String jitsiLink = "https://meet.jit.si/satasat-session-" + requestId;
                String insertMessage = "INSERT INTO messages (request_id, sender_id, content, sent_at) " +
                                       "VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertMessage)) {
                    pstmt.setInt(1, requestId);
                    pstmt.setInt(2, rahulId);
                    pstmt.setString(3, "Hello Saimon! Here is our Jitsi link: " + jitsiLink);
                    pstmt.executeUpdate();
                }
                System.out.println("Message inserted with Jitsi link: " + jitsiLink);

                conn.commit();
                System.out.println("--- Seeding Completed Successfully ---");
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
}
