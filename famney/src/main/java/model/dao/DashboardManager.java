// Made by Jason Dang

package model.dao;

import java.sql.*;
import java.util.*;

public class DashboardManager {

    private final Connection connection;

    public DashboardManager(Connection connection) {
        this.connection = connection;
    }

    /**
     * Helper method to generate date expression for SQLite timestamps.
     */
    private String getDateExpr(String columnName) {
        return "CASE " +
               "WHEN typeof(" + columnName + ")='integer' THEN datetime(" + columnName + "/1000,'unixepoch')" +
               " ELSE " + columnName +
               " END";
    }

    /**
     * Gets complete dashboard data for a specific month.
     */
    public Map<String, Object> getDashboardData(String familyId, int month, int year) {
        Map<String, Object> data = new HashMap<>();

        data.put("monthlySummary", getMonthlyFinancialSummary(familyId, month, year));
        data.put("budgetPerformance", getBudgetPerformance(familyId, month, year));
        data.put("topCategories", getTopSpendingCategories(familyId, month, year, 5));
        data.put("recentTransactions", getRecentTransactions(familyId, 10));
        data.put("financialTrend", getFinancialTrend(familyId, 6));

        return data;
    }

    /**
     * Gets monthly income, expenses, and net savings.
     */
    public Map<String, Object> getMonthlyFinancialSummary(String familyId, int month, int year) {
        Map<String, Object> summary = new HashMap<>();
        String monthStr = String.format("%02d", month);
        String yearStr = String.valueOf(year);
        String incomeDateExpr = getDateExpr("incomeDate");
        String expenseDateExpr = getDateExpr("expenseDate");

        String sql = 
                    "SELECT " +
                    "SUM(CASE WHEN type='Income' THEN amount ELSE 0 END) AS totalIncome, " +
                    "SUM(CASE WHEN type='Expense' THEN amount ELSE 0 END) AS totalExpenses " +
                    "FROM (" +
                    " SELECT amount, 'Income' AS type FROM Income " +
                    " WHERE familyId=? AND strftime('%m', " + incomeDateExpr + ")=? " +
                    " AND strftime('%Y', " + incomeDateExpr + ")=? AND isActive=1 " +
                    " UNION ALL " +
                    " SELECT amount, 'Expense' AS type FROM Expenses " +
                    " WHERE familyId=? AND strftime('%m', " + expenseDateExpr + ")=? " +
                    " AND strftime('%Y', " + expenseDateExpr + ")=? AND isActive=1" +
                    ")";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, familyId);
            pstmt.setString(2, monthStr);
            pstmt.setString(3, yearStr);
            pstmt.setString(4, familyId);
            pstmt.setString(5, monthStr);
            pstmt.setString(6, yearStr);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                double income = rs.getDouble("totalIncome");
                double expenses = rs.getDouble("totalExpenses");
                summary.put("totalIncome", income);
                summary.put("totalExpenses", expenses);
                summary.put("netSavings", income - expenses);
                summary.put("savingsRate", income > 0 ? ((income - expenses) / income) * 100 : 0);
            }

            System.out.println("Monthly Summary: income=" + summary.get("totalIncome") +
                               ", expenses=" + summary.get("totalExpenses"));

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return summary;
    }

    /**
     * Gets budget performance for a month.
     */
    public Map<String, Object> getBudgetPerformance(String familyId, int month, int year) {
        Map<String, Object> performance = new HashMap<>();
        List<Map<String, Object>> budgets = new ArrayList<>();
        String monthStr = String.format("%02d", month);
        String yearStr = String.valueOf(year);
        String expenseDateExpr = getDateExpr("expenseDate");

        String sql = "SELECT b.category, b.budgetAmount, " +
                        "COALESCE((SELECT SUM(amount) FROM Expenses e " +
                        "          WHERE familyId=? AND category=b.category " +
                        "          AND strftime('%m', " + expenseDateExpr + ")=? " +
                        "          AND strftime('%Y', " + expenseDateExpr + ")=? AND isActive=1), 0) AS actualSpent " +
                        "FROM Budgets b WHERE familyId=?";


        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, familyId);
            pstmt.setString(2, monthStr);
            pstmt.setString(3, yearStr);
            pstmt.setString(4, familyId);

            ResultSet rs = pstmt.executeQuery();
            int rowCount = 0;
            while (rs.next()) {
                Map<String, Object> b = new HashMap<>();
                b.put("category", rs.getString("category"));
                b.put("budgetAmount", rs.getDouble("budgetAmount"));
                b.put("actualSpent", rs.getDouble("actualSpent"));
                b.put("variance", rs.getDouble("budgetAmount") - rs.getDouble("actualSpent"));
                budgets.add(b);
                rowCount++;
            }
            System.out.println("Budget Performance rows=" + rowCount);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        performance.put("budgets", budgets);
        return performance;
    }

    /**
     * Gets top spending categories for a month.
     */
    public List<Map<String, Object>> getTopSpendingCategories(String familyId, int month, int year, int limit) {
        List<Map<String, Object>> categories = new ArrayList<>();
        String monthStr = String.format("%02d", month);
        String yearStr = String.valueOf(year);
        String expenseDateExpr = getDateExpr("expenseDate");

        String sql = "SELECT c.categoryName AS categoryName, SUM(e.amount) AS totalSpent " +
             "FROM Expenses e " +
             "JOIN Categories c ON e.categoryId = c.categoryId " +
             "WHERE e.familyId = ? " +
             "AND strftime('%m', " + expenseDateExpr + ") = ? " +
             "AND strftime('%Y', " + expenseDateExpr + ") = ? " +
             "AND e.isActive = 1 " +
             "GROUP BY c.categoryName " +
             "ORDER BY totalSpent DESC " +
             "LIMIT ?";


        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, familyId);
            pstmt.setString(2, monthStr);
            pstmt.setString(3, yearStr);
            pstmt.setInt(4, limit);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> c = new HashMap<>();
                c.put("categoryName", rs.getString("categoryName"));
                c.put("totalSpent", rs.getDouble("totalSpent"));
                categories.add(c);
            }
            System.out.println("Top Categories rows=" + categories.size());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    /**
     * Gets recent transactions (both income and expenses).
     */
    public List<Map<String, Object>> getRecentTransactions(String familyId, int limit) {
        List<Map<String, Object>> transactions = new ArrayList<>();
        String incomeDateExpr = getDateExpr("incomeDate");
        String expenseDateExpr = getDateExpr("expenseDate");

        String sql = "SELECT 'Income' AS type, " + incomeDateExpr + " AS date, i.amount, i.description, c.categoryName AS categoryName " +
             "FROM Income i JOIN Categories c ON i.categoryId = c.categoryId " +
             "WHERE i.familyId=? AND i.isActive=1 " +
             "UNION ALL " +
             "SELECT 'Expense' AS type, " + expenseDateExpr + " AS date, e.amount, e.description, c.categoryName AS categoryName " +
             "FROM Expenses e JOIN Categories c ON e.categoryId = c.categoryId " +
             "WHERE e.familyId=? AND e.isActive=1 " +
             "ORDER BY date DESC LIMIT ?";


        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, familyId);
            pstmt.setString(2, familyId);
            pstmt.setInt(3, limit);

            ResultSet rs = pstmt.executeQuery();
            int rowCount = 0;
            while (rs.next()) {
                Map<String, Object> t = new HashMap<>();
                t.put("type", rs.getString("type"));
                t.put("date", rs.getString("date"));
                t.put("amount", rs.getDouble("amount"));
                t.put("description", rs.getString("description"));
                t.put("categoryName", rs.getString("categoryName"));
                transactions.add(t);
                rowCount++;
            }
            System.out.println("Recent Transactions rows=" + rowCount);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return transactions;
    }

    /**
     * Gets financial trend for the last N months.
     */
    public List<Map<String, Object>> getFinancialTrend(String familyId, int months) {
        List<Map<String, Object>> trend = new ArrayList<>();
        List<String> monthYearList = new ArrayList<>();
        Calendar cal = Calendar.getInstance();

        for (int i = months - 1; i >= 0; i--) {
            Calendar c = (Calendar) cal.clone();
            c.add(Calendar.MONTH, -i);
            String monthStr = String.format("%02d", c.get(Calendar.MONTH) + 1);
            String yearStr = String.valueOf(c.get(Calendar.YEAR));
            monthYearList.add(yearStr + "-" + monthStr);
        }

        String placeholders = String.join(",", Collections.nCopies(months, "?"));
        String incomeDateExpr = getDateExpr("incomeDate");
        String expenseDateExpr = getDateExpr("expenseDate");

        String sqlIncome = "SELECT strftime('%Y-%m', " + incomeDateExpr + ") AS ym, SUM(amount) AS income " +
                   "FROM Income WHERE familyId=? AND isActive=1 AND strftime('%Y-%m', " + incomeDateExpr + ") IN (" + placeholders + ") " +
                   "GROUP BY ym";

        String sqlExpenses = "SELECT strftime('%Y-%m', " + expenseDateExpr + ") AS ym, SUM(amount) AS expenses " +
                            "FROM Expenses WHERE familyId=? AND isActive=1 AND strftime('%Y-%m', " + expenseDateExpr + ") IN (" + placeholders + ") " +
                            "GROUP BY ym";


        Map<String, Double> incomeMap = new HashMap<>();
        Map<String, Double> expenseMap = new HashMap<>();

        try {
            // Income
            try (PreparedStatement pstmt = connection.prepareStatement(sqlIncome)) {
                pstmt.setString(1, familyId);
                for (int i = 0; i < monthYearList.size(); i++) pstmt.setString(i + 2, monthYearList.get(i));
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) incomeMap.put(rs.getString("ym"), rs.getDouble("income"));
            }

            // Expenses
            try (PreparedStatement pstmt = connection.prepareStatement(sqlExpenses)) {
                pstmt.setString(1, familyId);
                for (int i = 0; i < monthYearList.size(); i++) pstmt.setString(i + 2, monthYearList.get(i));
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) expenseMap.put(rs.getString("ym"), rs.getDouble("expenses"));
            }

            // Build trend list
            for (String ym : monthYearList) {
                String[] parts = ym.split("-");
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("year", Integer.parseInt(parts[0]));
                monthData.put("month", Integer.parseInt(parts[1]));
                monthData.put("income", incomeMap.getOrDefault(ym, 0.0));
                monthData.put("expenses", expenseMap.getOrDefault(ym, 0.0));
                trend.add(monthData);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return trend;
    }
}
