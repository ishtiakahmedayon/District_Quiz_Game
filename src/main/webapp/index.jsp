<%@ page import="java.util.List, com.quiz.model.PlayerScore, com.quiz.dao.PlayerScoreDAO, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <title>Jamalpur District Quiz</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Jamalpur District Quiz</h2>
    <p>Crops &middot; Geography &middot; Academic Institutions</p>

    <form action="quiz.jsp" method="get">
        <label>Your name: <input type="text" name="name" required></label>
        <button type="submit">Start Quiz</button>
    </form>

    <%
        // Only show the leaderboard if the database actually has scores.
        List<PlayerScore> top;
        try {
            top = new PlayerScoreDAO().getTopScores(3);
        } catch (SQLException e) {
            throw new RuntimeException("Database error: " + e.getMessage(), e);
        }
    %>
    <% if (!top.isEmpty()) { %>
        <h3>Top 3 Players</h3>
        <ol>
            <% for (PlayerScore ps : top) { %>
                <li><%= ps.playerName %> - <%= ps.totalScore %></li>
            <% } %>
        </ol>
    <% } %>
</body>
</html>
