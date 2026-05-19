package com.satasat.utils;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ValidationUtilsTest {

    @Test
    public void testNotEmpty() {
        assertTrue(ValidationUtils.notEmpty("test"));
        assertTrue(ValidationUtils.notEmpty("  padded  "));
        assertFalse(ValidationUtils.notEmpty(""));
        assertFalse(ValidationUtils.notEmpty("   "));
        assertFalse(ValidationUtils.notEmpty(null));
    }

    @Test
    public void testValidEmail() {
        assertTrue(ValidationUtils.validEmail("user@example.com"));
        assertTrue(ValidationUtils.validEmail("first.last@domain.co.uk"));
        assertFalse(ValidationUtils.validEmail("userexample.com"));
        assertFalse(ValidationUtils.validEmail("user@"));
        assertFalse(ValidationUtils.validEmail(""));
        assertFalse(ValidationUtils.validEmail(null));
    }

    @Test
    public void testValidPassword() {
        assertTrue(ValidationUtils.validPassword("pass1234"));
        assertTrue(ValidationUtils.validPassword("1234abcd!"));
        assertFalse(ValidationUtils.validPassword("short1")); 
        assertFalse(ValidationUtils.validPassword("onlyletters"));
        assertFalse(ValidationUtils.validPassword("1234567890"));
        assertFalse(ValidationUtils.validPassword(null));
    }

    @Test
    public void testValidRating() {
        assertTrue(ValidationUtils.validRating(1));
        assertTrue(ValidationUtils.validRating(5));
        assertFalse(ValidationUtils.validRating(0));
        assertFalse(ValidationUtils.validRating(6));
    }

    @Test
    public void testSanitize() {
        assertEquals("test", ValidationUtils.sanitize("test"));
        assertEquals("&lt;script&gt;alert(&#x27;XSS&#x27;)&lt;/script&gt;", ValidationUtils.sanitize("<script>alert('XSS')</script>"));
        assertEquals("user &amp; admin", ValidationUtils.sanitize("user & admin"));
        assertEquals("&quot;quoted&quot;", ValidationUtils.sanitize("\"quoted\""));
        assertEquals("", ValidationUtils.sanitize(null));
    }
}
