<%@ page import="java.util.List, com.quiz.model.Question, com.quiz.dao.QuestionDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Answer all questions</h2>

    <%

        List<Question> questions = new QuestionDAO().getAllQuestions();
        String name = request.getParameter("name");
    %>

    <form action="submit" method="post">

        <input type="hidden" name="name" value="<%= name %>">

        <% for (Question q : questions) { %>
            <p>
                <b><%= q.questionText %></b><br>
                <input type="radio" name="q<%= q.questionId %>" value="A"> <%= q.optionA %><br>
                <input type="radio" name="q<%= q.questionId %>" value="B"> <%= q.optionB %><br>
                <input type="radio" name="q<%= q.questionId %>" value="C"> <%= q.optionC %><br>
                <input type="radio" name="q<%= q.questionId %>" value="D"> <%= q.optionD %>
            </p>
        <% } %>

        <button type="submit">Submit Quiz</button>
    </form>
</body>
</html>
