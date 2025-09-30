package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Expense;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/ExpenseServlet")
public class ExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));
            String description = request.getParameter("description");
            String categoryId = request.getParameter("category");
            String userId = request.getParameter("userId");

            Date expenseDate = new SimpleDateFormat("yyyy-MM-dd")
                    .parse(request.getParameter("expenseDate"));

            // Temporary Expense object
            Expense exp = new Expense();
            exp.setAmount(amount);
            exp.setDescription(description);
            exp.setCategoryId(categoryId);
            exp.setUserId(userId);
            exp.setExpenseDate(expenseDate);

            // Set attributes so they are available in expenses.jsp
            request.setAttribute("category", categoryId);
            request.setAttribute("amount", amount);
            request.setAttribute("date", new SimpleDateFormat("yyyy-MM-dd").format(expenseDate));
            request.setAttribute("description", description);

            // Get category-specific budget from session
            double categoryBudget = 0.0;
            java.util.List budgetCategories = (java.util.List) request.getSession().getAttribute("budgetCategories");
            if (budgetCategories != null) {
                for (Object obj : budgetCategories) {
                    // Use reflection to avoid import issues
                    try {
                        String catId = (String) obj.getClass().getMethod("getCategoryId").invoke(obj);
                        if (catId != null && catId.equals(categoryId)) {
                            Double allocated = (Double) obj.getClass().getMethod("getAllocatedAmount").invoke(obj);
                            categoryBudget = allocated != null ? allocated : 0.0;
                            break;
                        }
                    } catch (Exception ignore) {}
                }
            }
            request.setAttribute("categoryBudget", categoryBudget);

            // Forward to expenses.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}