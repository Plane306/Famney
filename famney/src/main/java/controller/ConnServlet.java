package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.dao.*;

/**
 * Central servlet for database connectivity and DAO manager initialisation.
 * All JSP pages should include this servlet to access database functionality.
 */
@WebServlet("/ConnServlet")
public class ConnServlet extends HttpServlet {
    private DBConnector db;
    private Connection conn;
    
    // Famney DAO Managers
    @SuppressWarnings("unused")
    private UserManager userManager;
    @SuppressWarnings("unused")
    private FamilyManager familyManager;
    @SuppressWarnings("unused")
    private CategoryManager categoryManager;
    private BudgetManager budgetManager;
    private ExpenseManager expenseManager;


    
    @Override
    public void init() {
        try {
            db = new DBConnector();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ConnServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        conn = db.openConnection();
        
        try {
            // Initialise all DAO managers
            budgetManager = new BudgetManager(conn);
            expenseManager = new ExpenseManager(conn);
        } catch (SQLException ex) {
            Logger.getLogger(ConnServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        // Export all DAO managers to session for JSP access
        session.setAttribute("budgetManager", budgetManager);
        session.setAttribute("expenseManager", expenseManager);
        // Redirect to original target if present
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        }
    }
    
    @Override
    public void destroy() {
        try {
            db.closeConnection();
        } catch (SQLException ex) {
            Logger.getLogger(ConnServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
