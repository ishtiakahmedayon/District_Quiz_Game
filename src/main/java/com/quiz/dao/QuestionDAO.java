package com.quiz.dao;

import com.quiz.model.Question;
import com.quiz.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    // Loads every question in the QUESTION table (all 5 seed questions).
    public List<Question> getAllQuestions() throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM QUESTION ORDER BY question_id";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Question q = new Question();
                q.questionId = rs.getInt("question_id");
                q.questionText = rs.getString("question_text");
                q.optionA = rs.getString("option_a");
                q.optionB = rs.getString("option_b");
                q.optionC = rs.getString("option_c");
                q.optionD = rs.getString("option_d");
                q.correctOption = rs.getString("correct_option");
                list.add(q);
            }
        }
        return list;
    }
}
