// Made by Jason Dang

package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.dao.IncomeManager;

@WebServlet("/ToggleRecurrenceServlet")
public class ToggleRecurrenceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String incomeId = request.getParameter("incomeId");
        String action = request.getParameter("action");
        boolean enable = "enable".equalsIgnoreCase(action);

        try {
            IncomeManager incomeManager = (IncomeManager) request.getSession().getAttribute("incomeManager");
            incomeManager.toggleRecurrence(incomeId, enable);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Refresh the page after toggling
        response.sendRedirect("IncomeServlet");
    }
}
