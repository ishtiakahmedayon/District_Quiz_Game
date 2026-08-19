<%@ page import="java.util.List, com.quiz.model.Question, com.quiz.dao.QuestionDAO, java.sql.SQLException" %>
<%
    // If a name was passed in (fresh click from index.jsp), start a NEW quiz
    // and store everything the player needs in the session.
    String name = request.getParameter("name");
    if (name != null) {
        try {
            session.setAttribute("playerName", name);
            session.setAttribute("questions", new QuestionDAO().getAllQuestions());
            session.setAttribute("currentIndex", 0);
            session.setAttribute("score", 0);
        } catch (SQLException e) {
            throw new RuntimeException("Database error: " + e.getMessage(), e);
        }
    }

    List<Question> questions = (List<Question>) session.getAttribute("questions");
    if (questions == null) {
        response.sendRedirect("index.jsp"); // no quiz in progress
        return;
    }
    int idx = (Integer) session.getAttribute("currentIndex");
    Question q = questions.get(idx);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>
    <link rel="stylesheet" href="style.css">
    <!-- No JS: if the player doesn't submit within 10s, the browser itself
         re-requests this same URL as a GET, which AnswerServlet treats as
         a timeout (no answer chosen) and moves on to the next question. -->
    <meta http-equiv="refresh" content="10;url=answer">
</head>
<body>
    <p>Question <%= idx + 1 %> / <%= questions.size() %> &nbsp; | &nbsp; You have 10 seconds</p>

    <form action="answer" method="post">
        <p><b><%= q.questionText %></b></p>
        <input type="radio" name="selected" value="A"> <%= q.optionA %><br>
        <input type="radio" name="selected" value="B"> <%= q.optionB %><br>
        <input type="radio" name="selected" value="C"> <%= q.optionC %><br>
        <input type="radio" name="selected" value="D"> <%= q.optionD %><br>
        <button type="submit">Submit Answer</button>
    </form>
</body>
</html>
