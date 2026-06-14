<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="onlinequiz.Question" %>
  
<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>
    <style>
        body { font-family: Arial; background: #f4f4f9; padding: 20px; }
        .container { background: white; max-width: 600px; margin: auto; padding: 30px; border-radius: 10px; }
        .timer { font-size: 24px; color: red; float: right; }
        .option { display: block; margin: 10px 0; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        .correct { background: #d4edda; border: 1px solid #28a745; }
        .wrong { background: #f8d7da; border: 1px solid #dc3545; }
        .feedback { padding: 15px; margin: 15px 0; border-radius: 5px; font-weight: bold; }
        button { padding: 12px 25px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <%
        List<Question> questionList = (List<Question>) session.getAttribute("questionList");
        if (questionList == null || questionList.isEmpty()) {
            out.println("<h2>Error: No questions found.</h2>");
            return;
        }
        
        Integer currentQ = (Integer) session.getAttribute("currentQ");
        if (currentQ == null) currentQ = 0;
        
        Question q = questionList.get(currentQ);
        String username = (String) session.getAttribute("username");
        Integer score = (Integer) session.getAttribute("score");
        if (score == null) score = 0;
        if (username == null) username = "Player";
        
        String feedback = (String) session.getAttribute("feedback");
        Boolean isCorrect = (Boolean) session.getAttribute("isCorrect");
        String selectedAns = (String) session.getAttribute("selectedAns");
        Integer timePerQ = (Integer) session.getAttribute("timePerQ");
        if (timePerQ == null) timePerQ = 60;
    %>
    <div class="container">
        <span class="timer" id="timer"></span>
        <h3>Player: <%= username %> | Score: <%= score %></h3>
        <h4>Q<%= currentQ + 1 %> of <%= questionList.size() %></h4>
        <hr>
        
        <h3><%= q.getQuestion() %></h3>

        <% if (feedback != null && !feedback.isEmpty()) { %>
            <div class="option <%= "A".equals(q.getCorrectAns()) ? "correct" : "" %> <%= "A".equals(selectedAns) && !isCorrect ? "wrong" : "" %>">A. <%= q.getOptionA() %></div>
            <div class="option <%= "B".equals(q.getCorrectAns()) ? "correct" : "" %> <%= "B".equals(selectedAns) && !isCorrect ? "wrong" : "" %>">B. <%= q.getOptionB() %></div>
            <div class="option <%= "C".equals(q.getCorrectAns()) ? "correct" : "" %> <%= "C".equals(selectedAns) && !isCorrect ? "wrong" : "" %>">C. <%= q.getOptionC() %></div>
            <div class="option <%= "D".equals(q.getCorrectAns()) ? "correct" : "" %> <%= "D".equals(selectedAns) && !isCorrect ? "wrong" : "" %>">D. <%= q.getOptionD() %></div>
            
            <div class="feedback <%= isCorrect ? "correct" : "wrong" %>"><%= feedback %></div>
            
            <form action="quiz" method="post">
                <input type="hidden" name="action" value="next">
                <button type="submit">
                    <%= (currentQ + 1 >= questionList.size()) ? "Finish Quiz" : "Next Question" %>
                </button>
            </form>
        <% } else { %>
            <form id="quizForm" action="quiz" method="post">
                <input type="hidden" name="action" value="answer">
                <label class="option"><input type="radio" name="ans" value="A" required> A. <%= q.getOptionA() %></label>
                <label class="option"><input type="radio" name="ans" value="B" required> B. <%= q.getOptionB() %></label>
                <label class="option"><input type="radio" name="ans" value="C" required> C. <%= q.getOptionC() %></label>
                <label class="option"><input type="radio" name="ans" value="D" required> D. <%= q.getOptionD() %></label>
                <br>
                <button type="submit">Submit Answer</button>
            </form>
            
            <script>
                let timeLeft = <%= timePerQ %>; 
                let timer = setInterval(function() {
                    document.getElementById("timer").innerHTML = "Time: " + timeLeft + "s";
                    timeLeft--;
                    if (timeLeft < 0) {
                        clearInterval(timer);
                        document.getElementById("quizForm").submit();
                    }
                }, 1000);
            </script>
        <% } %>
    </div>
</body>
</html>