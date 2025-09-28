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
            String categoryId = request.getParameter("categoryId");
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

<<<<<<< Updated upstream

            // Redirect to list page
            response.sendRedirect("expenses.jsp");
=======
            // Set attributes so they are available in expenses.jsp
            request.setAttribute("category", categoryId);
            request.setAttribute("amount", amount);
            request.setAttribute("date", new SimpleDateFormat("yyyy-MM-dd").format(expenseDate));
            request.setAttribute("description", description);

            // Forward to expenses.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("expenses.jsp");
            dispatcher.forward(request, response);
>>>>>>> Stashed changes
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
