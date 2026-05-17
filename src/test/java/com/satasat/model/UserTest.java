package com.satasat.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class UserTest {

    @Test
    public void testUserGettersAndSetters() {
        User user = new User();
        user.setId(1);
        user.setFullName("John Doe");
        user.setEmail("john@example.com");
        user.setRole("ADMIN");
        user.setStatus("ACTIVE");
        user.setAvgRating(4.5);
        
        assertEquals(1, user.getId());
        assertEquals("John Doe", user.getFullName());
        assertEquals("john@example.com", user.getEmail());
        assertEquals("ADMIN", user.getRole());
        assertEquals("ACTIVE", user.getStatus());
        assertEquals(4.5, user.getAvgRating());
    }

    @Test
    public void testIsAdminAndIsActive() {
        User user = new User();
        
        user.setRole("USER");
        assertFalse(user.isAdmin());
        
        user.setRole("ADMIN");
        assertTrue(user.isAdmin());
        
        user.setStatus("PENDING");
        assertFalse(user.isActive());
        
        user.setStatus("ACTIVE");
        assertTrue(user.isActive());
    }

    @Test
    public void testGetFirstName() {
        User user = new User();
        
        user.setFullName("John Doe Smith");
        assertEquals("John", user.getFirstName());
        
        user.setFullName("Alice");
        assertEquals("Alice", user.getFirstName());
        
        user.setFullName(null);
        assertEquals("", user.getFirstName());
    }
    
    @Test
    public void testProfileImageDefault() {
        User user = new User();
        assertEquals("default.png", user.getProfileImage());
        
        user.setProfileImage("");
        assertEquals("default.png", user.getProfileImage());
        
        user.setProfileImage("my_pic.jpg");
        assertEquals("my_pic.jpg", user.getProfileImage());
    }
}
