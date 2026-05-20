package com.satasat.utils;

public class Hasher {
    public static void main(String[] args) {
        System.out.println("Admin@123 -> " + PasswordHasher.hash("Admin@123"));
        System.out.println("Test@1234 -> " + PasswordHasher.hash("Test@1234"));
    }
}
