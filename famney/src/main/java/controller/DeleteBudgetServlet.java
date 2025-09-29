package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteBudgetServlet")
public class DeleteBudgetServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String indexStr = request.getParameter("index");
        if (indexStr != null) {
            int index = Integer.parseInt(indexStr);
            HttpSession session = request.getSession();
            List allBudgets = (List) session.getAttribute("allBudgets");
            List allCategories = (List) session.getAttribute("allCategories");
            if (allBudgets != null && allBudgets.size() > index) {
                allBudgets.remove(index);
            }
            if (allCategories != null && allCategories.size() > index) {
                allCategories.remove(index);
            }
            session.setAttribute("allBudgets", allBudgets);
            session.setAttribute("allCategories", allCategories);
        }
        response.sendRedirect("view_budget.jsp");
    }
}
