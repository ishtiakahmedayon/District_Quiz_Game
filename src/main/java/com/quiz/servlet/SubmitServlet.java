package com.quiz.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quiz.dao.PlayerScoreDAO;
import com.quiz.dao.QuestionDAO;
import com.quiz.model.Question;


@WebServlet("/submit")
public class SubmitServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");

        try {
            // ---- 11.3: quiz logic - present (already done in quiz.jsp),

            List<Question> questions = new QuestionDAO().getAllQuestions();
            int score = 0;

            for (Question q : questions) {

                String chosen = req.getParameter("q" + q.questionId);
                if (q.correctOption.equalsIgnoreCase(chosen)) {
                    score++; 
            }

            // ---- 11.2: save player name + final score into the DB ----
            new PlayerScoreDAO().saveScore(name, score);


            req.setAttribute("name", name);
            req.setAttribute("score", score);
            req.setAttribute("total", questions.size());
            req.getRequestDispatcher("result.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}
