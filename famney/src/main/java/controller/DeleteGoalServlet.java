package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.SavingsGoal;
import model.dao.SavingsGoalManager;

import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteGoalServlet")
@SuppressWarnings("unchecked")
public class DeleteGoalServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String indexStr = request.getParameter("index");
        if (indexStr != null) {
            int index = Integer.parseInt(indexStr);
            HttpSession session = request.getSession();
            List<SavingsGoal> allGoals = (List<SavingsGoal>) session.getAttribute("allGoals");

            if (allGoals != null && allGoals.size() > index) {
                String goalId = allGoals.get(index).getGoalId();

                // Persist to DB
                SavingsGoalManager mgr = (SavingsGoalManager) session.getAttribute("savingsGoalManager");
                if (mgr != null) {
                    try {
                        mgr.deleteGoal(goalId);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // Remove from session list
                allGoals.remove(index);
                session.setAttribute("allGoals", allGoals);
            }
        }
        response.sendRedirect("SavingsGoalServlet");
    }
}
