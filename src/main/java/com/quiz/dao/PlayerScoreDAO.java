package com.quiz.dao;

import com.quiz.util.DBUtil;

import java.sql.*;

public class PlayerScoreDAO {

    // ---- 11.2: save the player's name + final score into the DB ----
    public void saveScore(String name, int score) throws SQLException {
        try (Connection con = DBUtil.getConnection()) {

            // Step 1: insert a new row into PLAYER, get back its generated player_id
            String insertPlayer = "INSERT INTO PLAYER (name) VALUES (?)";
            int playerId;
            try (PreparedStatement ps = con.prepareStatement(insertPlayer, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, name);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                keys.next();
                playerId = keys.getInt(1);
            }

            // Step 2: insert the score row, linked to that player_id (foreign key)
            String insertScore = "INSERT INTO PLAYER_SCORE (player_id, total_score) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertScore)) {
                ps.setInt(1, playerId);
                ps.setInt(2, score);
                ps.executeUpdate();
            }
        }
    }

    // ---- Bonus: highest score of all time, with the player's name ----
    // Returns {name, score} or null if nobody has played yet.
    public String[] getHighScore() throws SQLException {
        String sql = "SELECT p.name, s.total_score FROM PLAYER_SCORE s " +
                     "JOIN PLAYER p ON p.player_id = s.player_id " +
                     "ORDER BY s.total_score DESC LIMIT 1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return new String[] { rs.getString("name"), String.valueOf(rs.getInt("total_score")) };
            }
            return null;
        }
    }
}
