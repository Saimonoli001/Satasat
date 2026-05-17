package com.satasat.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * JDBC connection utility.
 * Change DB_URL / DB_USER / DB_PASS to match your environment.
 */
public class DBConnection {

    private static final String DB_URL  =
            "jdbc:h2:./satasat_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;INIT=RUNSCRIPT FROM 'classpath:schema.sql'\\;RUNSCRIPT FROM 'classpath:data.sql'";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "";

    static {
        try {
            Class.forName("org.h2.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("H2 driver not found: " + e.getMessage());
        }
    }

    /** Returns a new JDBC connection from DriverManager. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /** Silently closes any AutoCloseable (Connection, Statement, ResultSet). */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}
