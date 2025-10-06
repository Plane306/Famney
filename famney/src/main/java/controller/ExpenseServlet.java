package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Expense;
import model.User;
import model.Family;
<<<<<<< HEAD
=======
import model.dao.ExpenseManager;
>>>>>>> development

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/ExpenseServlet")

public class ExpenseServlet extends HttpServlet {
<<<<<<< HEAD

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

=======
>>>>>>> development
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
<<<<<<< HEAD
            // Get user and family from session
=======
>>>>>>> development
            User user = (User) request.getSession().getAttribute("user");
            Family family = (Family) request.getSession().getAttribute("family");
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }
<<<<<<< HEAD

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
=======
            ExpenseManager expenseManager = (ExpenseManager) request.getSession().getAttribute("expenseManager");
            if (expenseManager == null) {
                throw new ServletException("ExpenseManager not initialized in session");
            }
            List<Expense> allExpenses = expenseManager.getAllExpenses(family.getFamilyId());
            request.getSession().setAttribute("allExpenses", allExpenses);
>>>>>>> development
            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
<<<<<<< HEAD
=======
    // Use ExpenseManager from session

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            Family family = (Family) request.getSession().getAttribute("family");
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String action = request.getParameter("action");
            ExpenseManager expenseManager = (ExpenseManager) request.getSession().getAttribute("expenseManager");
            if (expenseManager == null) {
                throw new ServletException("ExpenseManager not initialized in session");
            }
            if (action == null || action.equals("create")) {
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
                expenseManager.addExpense(expense);
            } else if (action.equals("update")) {
                String expenseId = request.getParameter("expenseId");
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date expenseDate = new SimpleDateFormat("yyyy-MM-dd")
                        .parse(request.getParameter("expenseDate"));
                Expense updatedExpense = new Expense(
                    expenseId,
                    family.getFamilyId(),
                    user.getUserId(),
                    categoryId,
                    amount,
                    description,
                    expenseDate,
                    new Date(),
                    new Date(),
                    true,
                    null
                );
                expenseManager.updateExpense(updatedExpense);
            } else if (action.equals("delete")) {
                String expenseId = request.getParameter("expenseId");
                expenseManager.deleteExpense(expenseId);
            }

            // Get all expenses for the family and set in session for display
            List<Expense> allExpenses = expenseManager.getAllExpenses(family.getFamilyId());
            request.getSession().setAttribute("allExpenses", allExpenses);

            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
>>>>>>> development
}