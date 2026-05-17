package com.satasat.utils;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordHasherTest {

    @Test
    public void testHash() {
        String plain = "mySecretPassword1";
        String hash1 = PasswordHasher.hash(plain);
        String hash2 = PasswordHasher.hash(plain);
        
        assertNotNull(hash1);
        assertEquals(64, hash1.length()); // SHA-256 hex string should be 64 characters
        assertEquals(hash1, hash2); // Deterministic hashing
        assertNotEquals(plain, hash1); // Ensure it's actually hashed
    }

    @Test
    public void testVerify() {
        String plain = "anotherPassword!";
        String hashed = PasswordHasher.hash(plain);
        
        assertTrue(PasswordHasher.verify(plain, hashed));
        assertFalse(PasswordHasher.verify("wrongPassword", hashed));
        assertFalse(PasswordHasher.verify(plain, "wrongHashStr"));
        assertFalse(PasswordHasher.verify(null, hashed));
        assertFalse(PasswordHasher.verify(plain, null));
    }
}
