package com.satasat.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * SHA-256 one-way password hashing utility.
 * Produces a 64-character lowercase hex digest.
 */
public class PasswordHasher {

    private PasswordHasher() {}   // utility class – no instances

    /**
     * Returns the SHA-256 hex digest of the given plain-text password.
     */
    public static String hash(String plainText) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(plainText.getBytes());
            StringBuilder sb = new StringBuilder(64);
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available on this JVM", e);
        }
    }

    /**
     * Compares a plain-text password against a stored hash.
     */
    public static boolean verify(String plainText, String storedHash) {
        if (plainText == null || storedHash == null) return false;
        return hash(plainText).equals(storedHash);
    }
}
