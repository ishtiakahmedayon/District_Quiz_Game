package com.quiz.servlet;

import com.quiz.dao.PlayerScoreDAO;
import com.quiz.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

// Grades ONE question, then moves the session forward to the next one.
// Reached two ways:
//   - doPost: player clicked "Submit Answer" on quiz.jsp
//   - doGet:  the <meta refresh> on quiz.jsp fired after 10s with no answer
//             (browser does a plain GET to this same URL)
@WebServlet("/answer")
@SuppressWarnings("unchecked")
public class AnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        gradeAndAdvance(req, resp, req.getParameter("selected"));
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        gradeAndAdvance(req, resp, null); // timeout = no answer chosen
    }

    private void gradeAndAdvance(HttpServletRequest req, HttpServletResponse resp, String selected)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("questions") == null) {
            resp.sendRedirect("index.jsp"); // no active quiz -- send them back to start
            return;
        }

        List<Question> questions = (List<Question>) session.getAttribute("questions");
        int currentIndex = (int) session.getAttribute("currentIndex");
        int score = (int) session.getAttribute("score");

        // ---- 11.3: check the current question's answer, increment score ----
        Question current = questions.get(currentIndex);
        if (current.correctOption.equalsIgnoreCase(selected)) {
            score++;
        }
        currentIndex++;

        if (currentIndex >= questions.size()) {
            // quiz finished -- save to DB and go to the result page
            try {
                new PlayerScoreDAO().saveScore((String) session.getAttribute("playerName"), score);
            } catch (SQLException e) {
                throw new ServletException("Database error: " + e.getMessage(), e);
            }
            session.setAttribute("finalScore", score);
            session.setAttribute("finalTotal", questions.size());
            resp.sendRedirect("result.jsp");
        } else {
            // more questions left -- save progress, show the next one
            session.setAttribute("currentIndex", currentIndex);
            session.setAttribute("score", score);
            resp.sendRedirect("quiz.jsp");
        }
    }
}
