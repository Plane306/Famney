package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import model.Family;
import model.dao.DashboardManager;

import java.io.IOException;
import java.util.Calendar;
import java.util.Map;


@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    
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
            DashboardManager dashboardManager = (DashboardManager) request.getSession().getAttribute("dashboardManager");
            if (dashboardManager == null) {
                throw new ServletException("DashboardManager not initialized in session");
            }
        
            Calendar cal = Calendar.getInstance();
            int month = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH is 0-based
            int year = cal.get(Calendar.YEAR);

            String monthParam = request.getParameter("month");
            String yearParam = request.getParameter("year");

            try {
                if (monthParam != null) month = Integer.parseInt(monthParam);
                if (yearParam != null) year = Integer.parseInt(yearParam);
            } catch (NumberFormatException e) {
                // Use default current month/year if parsing fails
            }

            Map<String, Object> dashboardData = dashboardManager.getDashboardData(family.getFamilyId(), month, year);
            if (dashboardData == null) {
                throw new ServletException("Failed to load dashboard data");
            }

            //Set data as request attributes for JSP
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("selectedMonth", month);
            request.setAttribute("selectedYear", year);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("dashboard_summary.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }  
} 
