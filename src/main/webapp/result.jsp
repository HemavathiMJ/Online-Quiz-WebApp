<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Thank You</title>
<style>
    body { font-family: Arial; background: #f4f4f9; text-align: center; padding-top: 100px; }
    .box { background: white; width: 400px; margin: auto; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
</style>
</head>
<body>
    <div class="box">
        <h2>Thank You for Playing!</h2>
        <h3>${sessionScope.username}</h3>
        <h1>Your Final Score: ${sessionScope.score} / ${sessionScope.questionList.size()}</h1>
        <a href="index.html"><button>Play Again</button></a>
    </div>
</body>
</html>