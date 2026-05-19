package com.satasat.dao;

import com.satasat.model.User;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserDAOTest {

    private static UserDAO userDAO;
    private static int testUserId;
    private static final String TEST_EMAIL = "daotest@satasat.com";

    @BeforeAll
    public static void setUp() {
        userDAO = new UserDAO();
        
        User existing = userDAO.findByEmail(TEST_EMAIL);
        if (existing != null) {
            userDAO.delete(existing.getId());
        }
    }

    @Test
    @Order(1)
    public void testCreateUser() {
        User u = new User();
        u.setFullName("DAO Test User");
        u.setEmail(TEST_EMAIL);
        u.setPasswordHash("testhash123");
        u.setRole("USER");
        u.setStatus("ACTIVE");
        
        testUserId = userDAO.create(u);
        assertTrue(testUserId > 0, "User ID should be generated and > 0");
    }

    @Test
    @Order(2)
    public void testFindByEmailAndId() {
        User byEmail = userDAO.findByEmail(TEST_EMAIL);
        assertNotNull(byEmail);
        assertEquals("DAO Test User", byEmail.getFullName());
        
        User byId = userDAO.findById(testUserId);
        assertNotNull(byId);
        assertEquals(TEST_EMAIL, byId.getEmail());
    }

    @Test
    @Order(3)
    public void testEmailExists() {
        assertTrue(userDAO.emailExists(TEST_EMAIL));
        assertFalse(userDAO.emailExists("nonexistent@domain.com"));
    }

    @Test
    @Order(4)
    public void testUpdateUser() {
        User u = userDAO.findById(testUserId);
        u.setFullName("Updated Name");
        u.setBio("A bio");
        u.setLocation("KTM");
        
        boolean updated = userDAO.update(u);
        assertTrue(updated);
        
        User updatedUser = userDAO.findById(testUserId);
        assertEquals("Updated Name", updatedUser.getFullName());
        assertEquals("A bio", updatedUser.getBio());
    }

    @Test
    @Order(5)
    public void testUpdateStatus() {
        boolean updated = userDAO.updateStatus(testUserId, "SUSPENDED");
        assertTrue(updated);
        
        User u = userDAO.findById(testUserId);
        assertEquals("SUSPENDED", u.getStatus());
    }

    @Test
    @Order(6)
    public void testFindAllAndByStatus() {
        List<User> all = userDAO.findAll();
        assertFalse(all.isEmpty());
        
        List<User> suspended = userDAO.findByStatus("SUSPENDED");
        assertTrue(suspended.stream().anyMatch(u -> u.getId() == testUserId));
    }

    @Test
    @Order(7)
    public void testDeleteUser() {
        boolean deleted = userDAO.delete(testUserId);
        assertTrue(deleted);
        
        User u = userDAO.findById(testUserId);
        assertNull(u, "User should be null after deletion");
    }
}
