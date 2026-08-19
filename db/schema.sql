

CREATE DATABASE IF NOT EXISTS jamalpurquiz_db;
USE jamalpurquiz_db;


CREATE TABLE CATEGORY (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);


CREATE TABLE QUESTION (
    question_id    INT AUTO_INCREMENT PRIMARY KEY,
    category_id    INT NOT NULL,
    question_text  VARCHAR(300) NOT NULL,
    option_a       VARCHAR(150) NOT NULL,
    option_b       VARCHAR(150) NOT NULL,
    option_c       VARCHAR(150) NOT NULL,
    option_d       VARCHAR(150) NOT NULL,
    correct_option CHAR(1) NOT NULL,   -- 'A', 'B', 'C', or 'D'
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
);


CREATE TABLE PLAYER (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(50) NOT NULL
);


CREATE TABLE PLAYER_SCORE (
    score_id    INT AUTO_INCREMENT PRIMARY KEY,
    player_id   INT NOT NULL,
    total_score INT NOT NULL,
    played_on   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES PLAYER(player_id)
);



INSERT INTO CATEGORY (category_name) VALUES ('Crops'), ('Geography'), ('Institutions');
s

INSERT INTO QUESTION (category_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'Jamalpur''s sandy river chars along the Brahmaputra are especially known for growing which crop?', 'Tea', 'Groundnut (peanut)', 'Coffee', 'Rubber', 'B'),
(1, 'Which staple grain crop is grown across most of Jamalpur district?', 'Wheat', 'Rice', 'Barley', 'Maize', 'B'),
(2, 'Jamalpur district falls under which division of Bangladesh?', 'Dhaka Division', 'Rajshahi Division', 'Mymensingh Division', 'Rangpur Division', 'C'),
(2, 'Which major river flows through Jamalpur district?', 'Padma', 'Brahmaputra (Jamuna)', 'Karnaphuli', 'Surma', 'B'),
(3, 'Which public university for science and technology is located at Melandaha, Jamalpur?', 'Jamalpur Science and Technology University', 'Bangladesh Agricultural University', 'Jagannath University', 'Islamic University', 'A');
