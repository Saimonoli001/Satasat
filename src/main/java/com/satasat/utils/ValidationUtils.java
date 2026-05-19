package com.satasat.utils;


public class ValidationUtils {

    private ValidationUtils() {}

    
    public static boolean notEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    
    public static boolean validEmail(String email) {
        if (!notEmpty(email)) return false;
        return email.trim().matches("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$");
    }

    
    public static boolean validPassword(String password) {
        if (password == null || password.length() < 8) return false;
        boolean letter = false, digit = false;
        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) letter = true;
            if (Character.isDigit(c)) digit  = true;
        }
        return letter && digit;
    }

    
    public static boolean validRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    
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
