package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.SavingsGoal;
import model.dao.SavingsGoalManager;

import java.io.IOException;
import java.util.List;

@WebServlet("/EditGoalServlet")
@SuppressWarnings("unchecked")
public class EditGoalServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String indexStr = request.getParameter("index");
        if (indexStr != null) {
            int index = Integer.parseInt(indexStr);
            HttpSession session = request.getSession();
            List<SavingsGoal> allGoals = (List<SavingsGoal>) session.getAttribute("allGoals");

            if (allGoals != null && allGoals.size() > index) {
                SavingsGoal goal = allGoals.get(index);
                request.setAttribute("editGoal", goal);
                request.setAttribute("editIndex", index);
                RequestDispatcher rd = request.getRequestDispatcher("edit_goal.jsp");
                rd.forward(request, response);
                return;
            }
        }
        response.sendRedirect("SavingsGoalServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String indexStr = request.getParameter("index");
        if (indexStr != null) {
            int index = Integer.parseInt(indexStr);
            HttpSession session = request.getSession();
            List<SavingsGoal> allGoals = (List<SavingsGoal>) session.getAttribute("allGoals");

            if (allGoals != null && allGoals.size() > index) {
                SavingsGoal goal = allGoals.get(index);

                String name = request.getParameter("goalName");
                double targetAmount = Double.parseDouble(request.getParameter("targetAmount"));
                String description = request.getParameter("description");
                String targetDate = request.getParameter("targetDate");

                goal.setGoalName(name);
                goal.setTargetAmount(targetAmount);
                goal.setDescription(description);
                if (targetDate != null && !targetDate.isEmpty()) {
                    goal.setTargetDate(java.sql.Date.valueOf(targetDate));
                }

                // Persist to DB
                SavingsGoalManager mgr = (SavingsGoalManager) session.getAttribute("savingsGoalManager");
                if (mgr != null) {
                    try {
                        mgr.updateGoal(goal);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                session.setAttribute("allGoals", allGoals);
            }
        }
        response.sendRedirect("SavingsGoalServlet");
    }
}
