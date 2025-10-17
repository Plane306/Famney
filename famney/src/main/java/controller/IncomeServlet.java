package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Income;
import model.User;
import model.Family;
import model.dao.IncomeManager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/IncomeServlet")

public class IncomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            Family family = (Family) request.getSession().getAttribute("family");
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            IncomeManager incomeManager = (IncomeManager) request.getSession().getAttribute("incomeManager");
            if (incomeManager == null) {
                throw new ServletException("IncomeManager not initialized in session");
            }
            List<Income> allIncomes = incomeManager.getAllIncomes(family.getFamilyId());
            request.getSession().setAttribute("allIncomes", allIncomes);
            RequestDispatcher dispatcher = request.getRequestDispatcher("incomes.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    // Use IncomeManager from session

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
            IncomeManager incomeManager = (IncomeManager) request.getSession().getAttribute("incomeManager");
            if (incomeManager == null) {
                throw new ServletException("IncomeManager not initialized in session");
            }
            if (action == null || action.equals("create")) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date incomeDate = new SimpleDateFormat("yyyy-MM-dd")
                        .parse(request.getParameter("incomeDate"));
                Income income = new Income(
                    family.getFamilyId(),
                    user.getUserId(),
                    categoryId,
                    amount,
                    description,
                    incomeDate
                );
                incomeManager.addIncome(income);
            } else if (action.equals("update")) {
                String incomeId = request.getParameter("incomeId");
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date incomeDate = new SimpleDateFormat("yyyy-MM-dd")
                        .parse(request.getParameter("incomeDate"));
                Income updatedIncome = new Income(
                    incomeId,
                    family.getFamilyId(),
                    user.getUserId(),
                    categoryId,
                    amount,
                    description,
                    incomeDate,
                    new Date(),
                    new Date(),
                    false,
                    true,
                    null
                );
                incomeManager.updateIncome(updatedIncome);
            } else if (action.equals("delete")) {
                String incomeId = request.getParameter("incomeId");
                incomeManager.deleteIncome(incomeId);
            }

            // Get all incomes for the family and set in session for display
            List<Income> allIncomes = incomeManager.getAllIncomes(family.getFamilyId());
            request.getSession().setAttribute("allIncomes", allIncomes);

            RequestDispatcher dispatcher = request.getRequestDispatcher("incomes.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}