package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.dao.BudgetManager;
<<<<<<< HEAD
=======
import model.dao.ExpenseManager;
>>>>>>> development
import model.dao.DBConnector;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebFilter("/*")
public class DAOInitFilter implements Filter {
    private DBConnector db;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        try {
            db = new DBConnector();
        } catch (Exception e) {
            throw new ServletException("DBConnector init failed", e);
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession();

        // Only initialize if not already present
<<<<<<< HEAD
        if (session.getAttribute("budgetManager") == null) {
            Connection conn = db.openConnection();
=======
        Connection conn = db.openConnection();
        if (session.getAttribute("budgetManager") == null) {
>>>>>>> development
            try {
                session.setAttribute("budgetManager", new BudgetManager(conn));
            } catch (SQLException e) {
                throw new ServletException("Failed to init BudgetManager", e);
            }
        }
<<<<<<< HEAD
=======
        if (session.getAttribute("expenseManager") == null) {
            session.setAttribute("expenseManager", new ExpenseManager(conn));
        }
>>>>>>> development
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Optionally close DBConnector
    }
}
