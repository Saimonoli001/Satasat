package com.satasat.utils;

/**
 * Server-side input validation helpers.
 * All methods are static – no instantiation needed.
 */
public class ValidationUtils {

    private ValidationUtils() {}

    /** True when value is non-null and not blank after trimming. */
    public static boolean notEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /** RFC-5322-lite email regex. */
    public static boolean validEmail(String email) {
        if (!notEmpty(email)) return false;
        return email.trim().matches("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$");
    }

    /**
     * Password rules: min 8 chars, at least one letter, at least one digit.
     */
    public static boolean validPassword(String password) {
        if (password == null || password.length() < 8) return false;
        boolean letter = false, digit = false;
        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) letter = true;
            if (Character.isDigit(c)) digit  = true;
        }
        return letter && digit;
    }

    /** True when 1 <= rating <= 5. */
    public static boolean validRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    /**
     * Basic XSS prevention: escapes HTML special chars.
     * Use in output contexts where JSTL <c:out> is not available.
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
                .replace("&",  "&amp;")
                .replace("<",  "&lt;")
                .replace(">",  "&gt;")
                .replace("\"", "&quot;")
                .replace("'",  "&#x27;");
    }
}
