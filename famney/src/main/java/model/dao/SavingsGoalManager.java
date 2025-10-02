package model.dao;

import model.SavingsGoal;
import java.sql.*;
import java.util.*;

public class SavingsGoalManager {
    private Connection conn;

    public SavingsGoalManager(Connection conn) {
        this.conn = conn;
    }

    // Create a new savings goal
    public void createGoal(SavingsGoal goal) throws SQLException {
        String sql = "INSERT INTO SavingsGoals " +
                "(goalId, familyId, goalName, description, targetAmount, currentAmount, targetDate, " +
                "createdDate, lastModifiedDate, isActive, isCompleted, createdBy) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, goal.getGoalId());
            ps.setString(2, goal.getFamilyId());
            ps.setString(3, goal.getGoalName());
            ps.setString(4, goal.getDescription());
            ps.setDouble(5, goal.getTargetAmount());
            ps.setDouble(6, goal.getCurrentAmount());
            ps.setDate(7, goal.getTargetDate() != null ? new java.sql.Date(goal.getTargetDate().getTime()) : null);
            ps.setDate(8, new java.sql.Date(goal.getCreatedDate().getTime()));
            ps.setDate(9, new java.sql.Date(goal.getLastModifiedDate().getTime()));
            ps.setBoolean(10, goal.isActive());
            ps.setBoolean(11, goal.isCompleted());
            ps.setString(12, goal.getCreatedBy()); // ✅ new column
            ps.executeUpdate();
        }
    }

    // List all active goals for a family
    public List<SavingsGoal> listGoals(String familyId) throws SQLException {
        List<SavingsGoal> goals = new ArrayList<>();
        String sql = "SELECT * FROM SavingsGoals WHERE familyId=? AND isActive=1 ORDER BY createdDate DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, familyId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SavingsGoal g = new SavingsGoal(
                        rs.getString("goalId"),
                        rs.getString("familyId"),
                        rs.getString("goalName"),
                        rs.getString("description"),
                        rs.getDouble("targetAmount"),
                        rs.getDouble("currentAmount"),
                        rs.getDate("targetDate"),
                        rs.getTimestamp("createdDate"),
                        rs.getTimestamp("lastModifiedDate"),
                        rs.getBoolean("isActive"),
                        rs.getBoolean("isCompleted"),
                        rs.getString("createdBy"));
                goals.add(g);
            }
        }
        return goals;
    }

    // Add contribution to a savings goal
    public boolean addToSavingsGoal(String goalId, double amount) throws SQLException {
        conn.setAutoCommit(false);
        try {
            double current = 0, target = 0;
            String q = "SELECT currentAmount, targetAmount FROM SavingsGoals WHERE goalId=?";
            try (PreparedStatement ps = conn.prepareStatement(q)) {
                ps.setString(1, goalId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    current = rs.getDouble(1);
                    target = rs.getDouble(2);
                } else {
                    conn.rollback();
                    return false;
                }
            }

            double newAmt = current + amount;
            boolean completed = newAmt >= target;

            String u = "UPDATE SavingsGoals SET currentAmount=?, isCompleted=?, lastModifiedDate=CURRENT_TIMESTAMP WHERE goalId=?";
            try (PreparedStatement ps = conn.prepareStatement(u)) {
                ps.setDouble(1, newAmt);
                ps.setBoolean(2, completed);
                ps.setString(3, goalId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public void updateGoal(SavingsGoal goal) throws SQLException {
        String sql = "UPDATE SavingsGoals SET goalName=?, description=?, targetAmount=?, currentAmount=?, " +
                "targetDate=?, lastModifiedDate=?, isActive=?, isCompleted=?, createdBy=? " + // ✅ createdBy included
                "WHERE goalId=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, goal.getGoalName());
            ps.setString(2, goal.getDescription());
            ps.setDouble(3, goal.getTargetAmount());
            ps.setDouble(4, goal.getCurrentAmount());
            ps.setDate(5, goal.getTargetDate() != null ? new java.sql.Date(goal.getTargetDate().getTime()) : null);
            ps.setDate(6, new java.sql.Date(goal.getLastModifiedDate().getTime()));
            ps.setBoolean(7, goal.isActive());
            ps.setBoolean(8, goal.isCompleted());
            ps.setString(9, goal.getCreatedBy());
            ps.setString(10, goal.getGoalId());
            ps.executeUpdate();
        }
    }

    public void deleteGoal(String goalId) throws SQLException {
        String sql = "DELETE FROM SavingsGoals WHERE goalId=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, goalId);
            ps.executeUpdate();
        }
    }

}
