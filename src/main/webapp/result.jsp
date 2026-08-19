<%@ page import="java.util.List, com.quiz.model.PlayerScore, com.quiz.dao.PlayerScoreDAO, java.sql.SQLException" %>
<%
    Object score = session.getAttribute("finalScore");
    if (score == null) {
        response.sendRedirect("index.jsp"); // no finished quiz to show
        return;
    }
    String name = (String) session.getAttribute("playerName");
    int total = (Integer) session.getAttribute("finalTotal");

    List<PlayerScore> top;
    try {
        top = new PlayerScoreDAO().getTopScores(3);
    } catch (SQLException e) {
        throw new RuntimeException("Database error: " + e.getMessage(), e);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Result</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Quiz Result</h2>
    <p><%= name %> scored <%= score %> / <%= total %></p>

    <% if (!top.isEmpty()) { %>
        <h3>Top 3 Players</h3>
        <ol>
            <% for (PlayerScore ps : top) { %>
                <li><%= ps.playerName %> - <%= ps.totalScore %></li>
            <% } %>
        </ol>
    <% } %>

    <a href="index.jsp">Play Again</a>
</body>
</html>
