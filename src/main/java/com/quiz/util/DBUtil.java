package com.quiz.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// One place to get a MySQL connection.
// EDIT the password below to match your local MySQL setup.
public class DBUtil {

    private static final String URL  = "jdbc:mysql://localhost:3306/jamalpurquiz_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "1177@"; // <-- change this

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
