package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Budget;
import model.BudgetCategory;
import model.User;
import model.Family;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/BudgetServlet")
public class BudgetServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Family family = (Family) request.getSession().getAttribute("family");
        if (user == null || family == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String budgetName = request.getParameter("name");
        int month = Integer.parseInt(request.getParameter("month"));
        String[] categoriesSelected = request.getParameterValues("category");
        String[] amountsEntered = request.getParameterValues("budget");

        Budget budget = new Budget(
            family.getFamilyId(),
            budgetName,
            month,
            2025,
            0.0,
            user.getUserId()
        );

        List<BudgetCategory> budgetCategories = new ArrayList<>();
        double totalAmount = 0.0;
        if (categoriesSelected != null && amountsEntered != null) {
            for (int i = 0; i < categoriesSelected.length; i++) {
                if (categoriesSelected[i] != null && !categoriesSelected[i].isEmpty() &&
                    amountsEntered[i] != null && !amountsEntered[i].isEmpty()) {
                    double amount = Double.parseDouble(amountsEntered[i]);
                    totalAmount += amount;
                    budgetCategories.add(new BudgetCategory(
                        null, null, categoriesSelected[i], amount, new Date(), new Date(), true
                    ));
                }
            }
        }
        budget.setTotalAmount(totalAmount);


        // Retrieve or create the budgets list in session
        List<Budget> allBudgets = (List<Budget>) request.getSession().getAttribute("allBudgets");
        if (allBudgets == null) {
            allBudgets = new ArrayList<>();
        }
        allBudgets.add(budget);
        request.getSession().setAttribute("allBudgets", allBudgets);

        // Store category IDs for each budget in allCategories
        List<String> allCategories = (List<String>) request.getSession().getAttribute("allCategories");
        if (allCategories == null) {
            allCategories = new ArrayList<>();
        }
        // For each category selected, add its ID to allCategories
        if (categoriesSelected != null) {
            for (String catId : categoriesSelected) {
                if (catId != null && !catId.isEmpty()) {
                    allCategories.add(catId);
                }
            }
        }
        request.getSession().setAttribute("allCategories", allCategories);

        // Store categories for this budget (optional: you may want a map of budgetId -> categories)
        List<List<BudgetCategory>> allBudgetCategories = (List<List<BudgetCategory>>) request.getSession().getAttribute("allBudgetCategories");
        if (allBudgetCategories == null) {
            allBudgetCategories = new ArrayList<>();
        }
        allBudgetCategories.add(budgetCategories);
        request.getSession().setAttribute("allBudgetCategories", allBudgetCategories);

        // Optionally keep currentBudget and budgetCategories for immediate use
        request.getSession().setAttribute("currentBudget", budget);
        request.getSession().setAttribute("budgetCategories", budgetCategories);
        response.sendRedirect("view_budget.jsp");
    }
}
