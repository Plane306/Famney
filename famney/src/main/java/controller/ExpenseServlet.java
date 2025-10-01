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

    // Helper to get expenses list from session
    private List<Expense> getExpenses(HttpSession session) {
        List<Expense> allExpenses = (List<Expense>) session.getAttribute("allExpenses");
        if (allExpenses == null) {
            allExpenses = new java.util.ArrayList<>();
            session.setAttribute("allExpenses", allExpenses);
        }
        return allExpenses;
    }

    // CREATE: Add new expense (already in doPost)
    private void addExpense(HttpSession session, Expense expense) {
        List<Expense> allExpenses = getExpenses(session);
        allExpenses.add(expense);
        session.setAttribute("allExpenses", allExpenses);
    }

    // READ: Get all expenses
    private List<Expense> getAllExpenses(HttpSession session) {
        return getExpenses(session);
    }

    // UPDATE: Update an expense by index (for demo, no id field)
    private void updateExpense(HttpSession session, int index, Expense updatedExpense) {
        List<Expense> allExpenses = getExpenses(session);
        if (index >= 0 && index < allExpenses.size()) {
            allExpenses.set(index, updatedExpense);
            session.setAttribute("allExpenses", allExpenses);
        }
    }

    // DELETE: Remove an expense by index
    private void deleteExpense(HttpSession session, int index) {
        List<Expense> allExpenses = getExpenses(session);
        if (index >= 0 && index < allExpenses.size()) {
            allExpenses.remove(index);
            session.setAttribute("allExpenses", allExpenses);
        }
    }

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

            String action = request.getParameter("action");
            if (action == null || action.equals("create")) {
                // CREATE
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
                addExpense(request.getSession(), expense);
            } else if (action.equals("update")) {
                // UPDATE
                int index = Integer.parseInt(request.getParameter("index"));
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date expenseDate = new SimpleDateFormat("yyyy-MM-dd")
                        .parse(request.getParameter("expenseDate"));
                Expense updatedExpense = new Expense(
                    family.getFamilyId(),
                    user.getUserId(),
                    categoryId,
                    amount,
                    description,
                    expenseDate
                );
                updateExpense(request.getSession(), index, updatedExpense);
            } else if (action.equals("delete")) {
                // DELETE
                int index = Integer.parseInt(request.getParameter("index"));
                deleteExpense(request.getSession(), index);
            }

            // Forward to expenses.jsp (READ)
            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}