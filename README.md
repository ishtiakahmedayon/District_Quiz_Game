# District Quiz Game — L11 Servlet CRUD

Minimal Servlet + JSP + JDBC implementation. No JavaScript, minimal CSS
(retro/skeleton look). Database: `jamalpurquiz_db`.

## 11.1 — Schema design + justification (Theory, 5 marks)

Schema (see `db/schema.sql`) follows the given ER diagram exactly:

```
CATEGORY (category_id PK, category_name)
QUESTION (question_id PK, category_id FK, question_text, option_a..d, correct_option)
PLAYER (player_id PK, name)
PLAYER_SCORE (score_id PK, player_id FK, total_score, played_on)
```

**Why this design:**
- **CATEGORY is a separate table** rather than a plain text column on
  QUESTION, so category names (Crops/Geography/Institutions) are stored
  once and referenced by `category_id` — avoids typos/duplication and
  makes it trivial to add a new category later (e.g. "History") without
  touching QUESTION's structure.
- **QUESTION → CATEGORY is many-to-one**: many questions belong to one
  category, which is exactly what a foreign key models.
- **PLAYER and PLAYER_SCORE are separate tables** (not one merged table)
  because a player can attempt the quiz multiple times — that's a
  one-to-many relationship (`PLAYER ||--o{ PLAYER_SCORE`). Storing scores
  directly on PLAYER would only allow one score per player ever.
- **`played_on` timestamp** on PLAYER_SCORE lets us order/filter attempts
  by time (e.g. "most recent" or "today's high score") without extra
  columns.
- **`correct_option` stored as a single CHAR('A'-'D')** instead of
  duplicating the answer text keeps grading a simple string comparison
  and keeps the row small.

## 11.2 — Save score (Practical, 8 marks)

`PlayerScoreDAO.saveScore(name, score)` — inserts into `PLAYER` first
(via `PreparedStatement` with `RETURN_GENERATED_KEYS` to get the new
`player_id`), then inserts into `PLAYER_SCORE` using that id as the
foreign key. Both inserts use `PreparedStatement`, no string-concatenated
SQL.

## 11.3 — Quiz logic (Practical, 7 marks)

Questions are shown **one at a time**, with a **10-second timer per
question**, using only `<meta http-equiv="refresh">` — no JavaScript.

- **Present**: `quiz.jsp` reads the current question index from the
  session and prints just that one `Question` object's form. Its
  `<head>` includes `<meta http-equiv="refresh" content="10;url=answer">`.
  If the player submits in time, the browser navigates away (POST) and
  the refresh never fires. If 10 seconds pass with no submission, the
  browser itself does a plain GET to `answer` — no JS timer needed.
- **Check + increment**: `AnswerServlet` handles both cases —
  `doPost()` (real answer) and `doGet()` (timeout, no answer) both call
  the same `gradeAndAdvance()`, which compares the submitted value
  against `q.correctOption`, increments `score` on a match, then
  advances `currentIndex` in the session and redirects to either the
  next question or (once all 5 are done) `result.jsp`.

Quiz state (`questions`, `currentIndex`, `score`, `playerName`) lives in
`HttpSession` between requests — that's what makes "resume where you
left off after each page load" possible without any client-side state.

## Top-3 leaderboard

`PlayerScoreDAO.getTopScores(3)` returns the top 3 `PlayerScore` rows
(name + score), used on both `index.jsp` (home screen) and `result.jsp`
(after a quiz). Both pages only print the `<ol>` if the list isn't
empty, so a brand-new database just shows the name form with no
leaderboard section.

## Files

```
db/schema.sql                          schema + 5 seed questions (run once)
src/main/java/com/quiz/
  model/Question.java                  one question (Serializable - stored in session)
  model/PlayerScore.java               one leaderboard row (name + score)
  util/DBUtil.java                     DB connection (edit password here)
  dao/QuestionDAO.java                 loads questions
  dao/PlayerScoreDAO.java              11.2 save logic + getTopScores() for leaderboard
  servlet/AnswerServlet.java           11.3 check/score logic, one question per request
src/main/webapp/
  index.jsp                           name entry + top-3 leaderboard, no JS
  quiz.jsp                            current question + 10s meta-refresh timer, no JS
  result.jsp                          final score + top-3 leaderboard, no JS
  style.css                           minimal retro styling
  WEB-INF/web.xml
```

## How to run (IntelliJ + Maven)

1. `mysql -u root -p < db/schema.sql` — creates `jamalpurquiz_db` and
   seeds the 5 questions.
2. Edit `src/main/java/com/quiz/util/DBUtil.java` — set your MySQL
   password (the `PASS` constant near the top).
3. Open the `quiz-lite` folder in IntelliJ as a Maven project.
4. Maven tool window → `district-quiz-lite > Plugins > jetty > jetty:run`
   (or run `mvn jetty:run` in the terminal).
5. Open `http://localhost:8080/quiz/`.

No separate Tomcat install needed — Jetty runs embedded via the Maven
plugin already configured in `pom.xml`.
