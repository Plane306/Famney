package model.dao;

import model.Income;
import java.sql.*;
import java.util.*;
import java.util.Date;
import controller.IdGenerator;

public class IncomeManager {

    private Connection connection;

    public IncomeManager(Connection connection) {
        this.connection = connection;
    }

    public boolean addRecurringIncome(Income income) {
        // Make sure recurring incomes are active by default
        if (income.isRecurring()) {
            income.setRecurrenceActive(true);
        }

        // Add the main income first
        boolean added = addIncome(income);

        // If added, generate missing recurrences between incomeDate and today
        if (added && income.isRecurring() && income.isRecurrenceActive() && income.isActive()) {
            try {
                generateNextRecurringIncome(income);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return added;
    }

    // Add income to DB
    public boolean addIncome(Income income) {
        String sql = "INSERT INTO Incomes (incomeId, familyId, userId, categoryId, amount, description, incomeDate, createdDate, lastModifiedDate, isRecurring, isRecurrenceActive, frequency, isActive, source) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String incomeId = IdGenerator.generateIncomeId();
            ps.setString(1, incomeId);
            ps.setString(2, income.getFamilyId());
            ps.setString(3, income.getUserId());
            ps.setString(4, income.getCategoryId());
            ps.setDouble(5, income.getAmount());
            ps.setString(6, income.getDescription());
            ps.setTimestamp(7, new java.sql.Timestamp(income.getIncomeDate().getTime()));
            ps.setTimestamp(8, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.setBoolean(10, income.isRecurring());
            ps.setBoolean(11, income.isRecurring() ? true : income.isRecurrenceActive()); // recurring incomes have their recurrence automatically active
            ps.setString(12, income.getFrequency());
            ps.setBoolean(13, income.isActive());
            ps.setString(14, income.getSource());

            int rows = ps.executeUpdate();
            System.out.println("[DEBUG] Inserting " + incomeId + " " + income.getFamilyId() + " " + income.getUserId() + " " + income.getCategoryId() + " " + income.getAmount() + " " + income.getDescription() + " " + income.getIncomeDate() + " " + income.getCreatedDate() + " " + income.getLastModifiedDate() + " " + income.isRecurring() + " " + income.getFrequency() + " " + income.isActive() + " " + income.getSource());

            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void generateNextRecurringIncome(Income income) throws SQLException {
        if (!income.isRecurring() || !income.isActive() || !income.isRecurrenceActive() || income.getFrequency() == null || income.getDescription().contains("AUTO"))
            return;

        Calendar cal = Calendar.getInstance();
        cal.setTime(truncateTime(income.getIncomeDate())); // start from base income date
        Date today = truncateTime(new Date());

        while (!cal.getTime().after(today)) {
            Date currentDate = cal.getTime();

            // Skip original income date itself
            if (!currentDate.equals(truncateTime(income.getIncomeDate()))) {
                // Check if this date already has an AUTO income
                boolean exists = incomeExistsOnDate(income.getFamilyId(), income.getDescription(), currentDate);
                if (!exists) {
                    Income autoIncome = new Income(
                        IdGenerator.generateIncomeId(),
                        income.getFamilyId(),
                        income.getUserId(),
                        income.getCategoryId(),
                        income.getAmount(),
                        "AUTO " + income.getDescription(),
                        currentDate,
                        new Date(),
                        new Date(),
                        true,
                        false,
                        income.getFrequency(),
                        true,
                        income.getSource()
                    );
                    addIncome(autoIncome);
                }
            }

            // Move to next recurrence
            switch (income.getFrequency().toLowerCase()) {
                case "daily":
                    cal.add(Calendar.DATE, 1);
                    break;
                case "weekly":
                    cal.add(Calendar.DATE, 7);
                    break;
                case "fortnightly":
                    cal.add(Calendar.DATE, 14);
                    break;
                case "monthly":
                    cal.add(Calendar.MONTH, 1);
                    break;
                case "quarterly":
                    cal.add(Calendar.MONTH, 3);
                    break;
                case "yearly":
                    cal.add(Calendar.YEAR, 1);
                    break;
                default:
                    return;
            }
        }
    }

    // Helper: check if income with same description and date exists
    private boolean incomeExistsOnDate(String familyId, String description, Date date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Incomes WHERE familyId=? AND description=? AND DATE(incomeDate)=? AND isActive=1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, familyId);
            ps.setString(2, "AUTO " + description); 
            ps.setDate(3, new java.sql.Date(date.getTime()));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Get income by ID
    public Income getIncomeById(String incomeId) {
        String sql = "SELECT * FROM Incomes WHERE incomeId = ? AND isActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, incomeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToIncome(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all incomes for a family
    public List<Income> getAllIncomes(String familyId) {
        List<Income> incomes = new ArrayList<>();
        String sql = "SELECT * FROM Incomes WHERE familyId = ? AND isActive = 1 ORDER BY incomeDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, familyId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Income income = mapResultSetToIncome(rs);
                incomes.add(income);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incomes;
    }

    // Update income
    public boolean updateIncome(Income income) {
        String sql = "UPDATE Incomes SET categoryId=?, amount=?, description=?, incomeDate=?, lastModifiedDate=?, source=? WHERE incomeId=? AND isActive=1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, income.getCategoryId());
            ps.setDouble(2, income.getAmount());
            ps.setString(3, income.getDescription());
            ps.setTimestamp(4, new java.sql.Timestamp(income.getIncomeDate().getTime()));
            ps.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.setString(6, income.getSource());
            ps.setString(7, income.getIncomeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete income (soft delete)
    public boolean deleteIncome(String incomeId) {
        String sql = "UPDATE Incomes SET isActive=0, lastModifiedDate=? WHERE incomeId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.setString(2, incomeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleRecurrence(String incomeId, boolean enable) {
        String sql = "UPDATE Incomes SET isRecurrenceActive=?, lastModifiedDate=? WHERE incomeId=? AND isActive=1 AND isRecurring=1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, enable);
            ps.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
            ps.setString(3, incomeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: map ResultSet to Income
    private Income mapResultSetToIncome(ResultSet rs) throws SQLException {
        return new Income(
            rs.getString("incomeId"),
            rs.getString("familyId"),
            rs.getString("userId"),
            rs.getString("categoryId"),
            rs.getDouble("amount"),
            rs.getString("description"),
            rs.getTimestamp("incomeDate"),
            rs.getTimestamp("createdDate"),
            rs.getTimestamp("lastModifiedDate"),
            rs.getBoolean("isRecurring"),
            rs.getBoolean("isRecurrenceActive"),
            rs.getString("frequency"),
            rs.getBoolean("isActive"),
            rs.getString("source")
        );
    }

    // Helper to truncate time (set hours/minutes/seconds to 0)
    private Date truncateTime(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }
}
