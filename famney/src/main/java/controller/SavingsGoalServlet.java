package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.*;
import model.dao.SavingsGoalManager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/SavingsGoalServlet")
public class SavingsGoalServlet extends HttpServlet {

    private SavingsGoalManager mgr;

    @Override
    public void init() throws ServletException {
        try {
            // Load SQLite driver and connect
            Class.forName("org.sqlite.JDBC");
            String dbPath = "C:/Year 3 First Semester/Advanced Software Development/Github/Famney/famney/database/queries/famney.db";
            log("Using database path: " + dbPath);
            Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            mgr = new SavingsGoalManager(conn);
        } catch (Exception e) {
            throw new ServletException("DB init failed", e);
        }
    }

    // GET → Show all savings goals
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Family family = (Family) session.getAttribute("family");

        if (family == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            List<SavingsGoal> goals = mgr.listGoals(family.getFamilyId());
            req.setAttribute("goals", goals);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load goals: " + e.getMessage());
        }

        req.getRequestDispatcher("savings_goals.jsp").forward(req, resp);
    }

    // POST → Create or Add to goal
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        Family family = (Family) session.getAttribute("family");

        if (user == null || family == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                createGoal(req, family, user);
            } else if ("add".equals(action)) {
                addToGoal(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
        }

        // Always redirect back to doGet (to refresh list)
        resp.sendRedirect("SavingsGoalServlet");
    }

    // --- Create a new savings goal ---
    private void createGoal(HttpServletRequest req, Family family, User user) throws Exception {
        String name = req.getParameter("goalName");
        String targetAmount = req.getParameter("targetAmount");
        String targetDateStr = req.getParameter("targetDate");

        Date targetDate = null;
        if (targetDateStr != null && !targetDateStr.isEmpty()) {
            targetDate = new SimpleDateFormat("yyyy-MM-dd").parse(targetDateStr);
        }

        // Generate a new unique Goal ID
        String newGoalId = IdGenerator.generateGoalId();

        SavingsGoal g = new SavingsGoal(
                newGoalId, // set generated goalId
                family.getFamilyId(),
                name,
                Double.parseDouble(targetAmount),
                targetDate,
                user.getUserId());

        mgr.createGoal(g);
    }

    // --- Add amount to an existing goal ---
    private void addToGoal(HttpServletRequest req) throws Exception {
        String id = req.getParameter("goalId");
        String amountStr = req.getParameter("amount");

        double amt = Double.parseDouble(amountStr);
        boolean ok = mgr.addToSavingsGoal(id, amt);
        if (!ok) {
            throw new Exception("Goal not found in DB");
        }
    }
}
