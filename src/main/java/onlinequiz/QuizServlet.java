package onlinequiz;

import java.io.IOException;
import java.util.List;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {
	

	
	

	    private QuestionDAO questionDAO = new QuestionDAO();

	    @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	            throws ServletException, IOException {
	        HttpSession session = request.getSession();
	        if (session.getAttribute("questionList") == null) {
	            List<Question> questionList = questionDAO.getAllQuestions();
	            if (questionList == null || questionList.isEmpty()) {
	                questionList = new java.util.ArrayList<>();
	                questionList.add(new Question("Capital of India?", "Mumbai", "Delhi", "Kolkata", "Chennai", "B"));
	            }
	            session.setAttribute("username", "Player");
	            session.setAttribute("questionList", questionList);
	            session.setAttribute("currentQ", 0);
	            session.setAttribute("score", 0);
	            session.setAttribute("timePerQ", 60);
	        }
	        request.getRequestDispatcher("quiz.jsp").forward(request, response);
	    }

	    @Override
	    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	            throws ServletException, IOException {
	        HttpSession session = request.getSession();
	        String action = request.getParameter("action");
	        
	        if ("answer".equals(action)) {
	            int currentQ = (int) session.getAttribute("currentQ");
	            List<Question> questionList = (List<Question>) session.getAttribute("questionList");
	            Question q = questionList.get(currentQ);
	            String userAns = request.getParameter("ans");
	            if (userAns == null) userAns = "TIME_UP";
	            boolean isCorrect = q.getCorrectAns().equals(userAns);
	            String feedback;
	            if ("TIME_UP".equals(userAns)) {
	                feedback = "Time's Up! ❌ Correct: " + q.getCorrectAns();
	            } else if (isCorrect) {
	                feedback = "Correct! ✅";
	                session.setAttribute("score", (int) session.getAttribute("score") + 1);
	            } else {
	                feedback = "Wrong ❌ Correct: " + q.getCorrectAns();
	            }
	            session.setAttribute("feedback", feedback);
	            session.setAttribute("isCorrect", isCorrect);
	            session.setAttribute("selectedAns", userAns);
	            response.sendRedirect("quiz");
	            return;
	        }
	        
	        else if ("next".equals(action)) {
	            int currentQ = (int) session.getAttribute("currentQ") + 1;
	            List<Question> questionList = (List<Question>) session.getAttribute("questionList");
	            if (currentQ >= questionList.size()) {
	                try {
	                    Class.forName("com.mysql.cj.jdbc.Driver");
	                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizdb", "root", "");
	                    String query = "INSERT INTO results(username, score) VALUES(?,?)";
	                    PreparedStatement ps = con.prepareStatement(query);
	                    ps.setString(1, (String) session.getAttribute("username"));
	                    ps.setInt(2, (int) session.getAttribute("score"));
	                    ps.executeUpdate();
	                    ps.close(); con.close();
	                } catch(Exception e) { e.printStackTrace(); }
	                response.sendRedirect("result.jsp");
	            } else {
	                session.setAttribute("currentQ", currentQ);
	                session.removeAttribute("feedback");
	                session.removeAttribute("isCorrect");
	                session.removeAttribute("selectedAns");
	                response.sendRedirect("quiz");
	            }
	            return;
	        }
	        doGet(request, response);
	    }
	}
	








   
