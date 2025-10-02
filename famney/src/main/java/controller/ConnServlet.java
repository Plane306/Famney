package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/ConnServlet")
public class ConnServlet extends HttpServlet {
    private DBConnector connector;
    private Connection conn;

    @Override
    public void init() throws ServletException {
        try {
            connector = new DBConnector();
            conn = connector.openConnection();
        } catch (Exception e) {
            throw new ServletException("DB connection failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // Create and attach DAOs
        session.setAttribute("savingsGoalManager", new SavingsGoalManager(conn));

        resp.getWriter().println("DAOs initialized in session.");
    }

    @Override
    public void destroy() {
        try {
            connector.closeConnection();
        } catch (Exception ignore) {
        }
    }
}
