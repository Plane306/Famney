// Made by Jason Dang

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
import java.util.Comparator;
import java.util.Date;
import java.util.List;


@WebServlet("/IncomeServlet")
public class IncomeServlet extends HttpServlet {

    // Shows 20 entries per page
    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Ensures user is logged in and is part of a family
            User user = (User) request.getSession().getAttribute("user");
            Family family = (Family) request.getSession().getAttribute("family");

            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Ensures IncomeManager is created for session
            IncomeManager incomeManager = (IncomeManager) request.getSession().getAttribute("incomeManager");
            if (incomeManager == null) {
                throw new ServletException("IncomeManager not initialized in session");
            }

            // Pagination parameters
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Fetch all incomes
            List<Income> allIncomes = incomeManager.getAllIncomes(family.getFamilyId());

            // Sort by latest incomeDate first
            allIncomes.sort(Comparator.comparing(Income::getIncomeDate).reversed());

            // Pagination slice
            int totalRecords = allIncomes.size();
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            int fromIndex = Math.min((page - 1) * PAGE_SIZE, totalRecords);
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalRecords);
            List<Income> paginatedIncomes = allIncomes.subList(fromIndex, toIndex);

            // Pass to JSP
            request.setAttribute("allIncomes", paginatedIncomes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            RequestDispatcher dispatcher = request.getRequestDispatcher("incomes.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

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

            // Create new income
            if (action.equals("create")) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date incomeDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("incomeDate"));
                boolean isRecurring = "yes".equalsIgnoreCase(request.getParameter("isRecurring"));
                String frequency = request.getParameter("frequency");
                String source = request.getParameter("source");

                Income income = new Income(
                        family.getFamilyId(),
                        user.getUserId(),
                        categoryId,
                        amount,
                        description,
                        incomeDate,
                        isRecurring
                );
                income.setRecurrenceActive(isRecurring);
                income.setFrequency(frequency);
                income.setSource(source);

                boolean success;
                if (isRecurring) {
                    // For recurring income, generate all AUTO entries between date and today
                    success = incomeManager.addRecurringIncome(income);
                } else {
                    // Single income only
                    success = incomeManager.addIncome(income);
                }

                if (success) {
                    request.getSession().setAttribute("successMessage", "Income added successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to add income. Try again.");
                }

                // Redirect to list
                response.sendRedirect("IncomeServlet");

            // Update existing income
            } else if (action.equals("update")) {
                String incomeId = request.getParameter("incomeId");
                Income existingIncome = incomeManager.getIncomeById(incomeId);
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                String categoryId = request.getParameter("category");
                Date incomeDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("incomeDate"));
                boolean isRecurring = "yes".equalsIgnoreCase(request.getParameter("isRecurring"));
                String frequency = request.getParameter("frequency");
                String source = request.getParameter("source");

                Income updatedIncome = new Income(
                        incomeId,
                        family.getFamilyId(),
                        user.getUserId(),
                        categoryId,
                        amount,
                        description,
                        incomeDate,
                        existingIncome.getCreatedDate(),
                        new Date(),
                        isRecurring,
                        existingIncome.isRecurrenceActive(),
                        frequency,
                        true,
                        source
                );

                incomeManager.updateIncome(updatedIncome);

                // Redirect back to list
                response.sendRedirect("IncomeServlet");

            // Delete income
            } else if (action.equals("delete")) {
                String incomeId = request.getParameter("incomeId");

                if (incomeId != null && !incomeId.trim().isEmpty()) {
                    incomeManager.deleteIncome(incomeId.trim());
                    response.sendRedirect("IncomeServlet"); // <-- refresh page
                } else {
                    throw new ServletException("Invalid incomeId for deletion");
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
