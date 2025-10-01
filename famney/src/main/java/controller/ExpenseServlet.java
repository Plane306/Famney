package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Expense;
import model.User;
import model.Family;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/ExpenseServlet")
public class ExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get user and family from session
            User user = (User) request.getSession().getAttribute("user");
            Family family = (Family) request.getSession().getAttribute("family");
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            double amount = Double.parseDouble(request.getParameter("amount"));
            String description = request.getParameter("description");
            String categoryId = request.getParameter("category");
            Date expenseDate = new SimpleDateFormat("yyyy-MM-dd")
                    .parse(request.getParameter("expenseDate"));

            Expense expense = new Expense(
                family.getFamilyId(),
                user.getUserId(),
                categoryId,
                amount,
                description,
                expenseDate
            );

            // Retrieve or create the expenses list in session
            List<Expense> allExpenses = (List<Expense>) request.getSession().getAttribute("allExpenses");
            if (allExpenses == null) {
                allExpenses = new java.util.ArrayList<>();
            }
            allExpenses.add(expense);
            request.getSession().setAttribute("allExpenses", allExpenses);

            // Set attributes for display in expenses.jsp
            request.setAttribute("category", categoryId);
            request.setAttribute("amount", amount);
            request.setAttribute("date", new SimpleDateFormat("yyyy-MM-dd").format(expenseDate));
            request.setAttribute("description", description);

            // Forward to expenses.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}