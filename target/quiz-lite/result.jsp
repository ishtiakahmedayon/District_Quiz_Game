<%@ page import="com.quiz.dao.PlayerScoreDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Result</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Quiz Result</h2>

    <p>
        <%= request.getAttribute("name") %> scored
        <%= request.getAttribute("score") %> / <%= request.getAttribute("total") %>
    </p>

    <%
        // Bonus: show the all-time high score (not required by the assignment,
        // but matches "highest score is shown on screen" from the original brief).
        String[] high = new PlayerScoreDAO().getHighScore();
    %>
    <% if (high != null) { %>
        <p>High Score: <%= high[0] %> - <%= high[1] %></p>
    <% } %>

    <a href="index.html">Play Again</a>
</body>
</html>
