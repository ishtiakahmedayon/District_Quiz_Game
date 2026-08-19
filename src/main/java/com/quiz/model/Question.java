package com.quiz.model;

import java.io.Serializable;

// Plain data holder for one quiz question.
// Public fields (no getters/setters) to keep this as short as possible.
// Serializable because we now store the question list inside HttpSession.
public class Question implements Serializable {
    public int questionId;
    public String questionText;
    public String optionA, optionB, optionC, optionD;
    public String correctOption; // "A" / "B" / "C" / "D"
}
