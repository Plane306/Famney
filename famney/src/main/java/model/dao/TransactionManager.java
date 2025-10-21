package model.dao;

import java.sql.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.*;

/**
 * DAO for Transaction History (F108).
 * Combines Income and Expenses into unified transaction view.
 */
public class TransactionManager {

    private Connection connection;

    public TransactionManager(Connection connection) throws SQLException {
        this.connection = connection;
    }

    /**
     * Gets filtered transactions with pagination.
     * This is the main method for F108.
     */
    public List<Map<String, Object>> getFilteredTransactions(
            String familyId,
            String categoryFilter,
            String typeFilter,
            String memberFilter,
            String startDate,
            String endDate,
            String searchTerm,
            int page,
            int pageSize) {

        List<Map<String, Object>> transactions = new ArrayList<>();

        Long startDateMillis = parseDateFilter(startDate, false);
        Long endDateExclusiveMillis = parseDateFilter(endDate, true);

        String incomeDateExpr = "CASE WHEN typeof(i.incomeDate) = 'integer' THEN i.incomeDate "
                + "ELSE CAST(strftime('%s', i.incomeDate) AS INTEGER) * 1000 END";
        String expenseDateExpr = "CASE WHEN typeof(e.expenseDate) = 'integer' THEN e.expenseDate "
                + "ELSE CAST(strftime('%s', e.expenseDate) AS INTEGER) * 1000 END";

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM (");

        // Income transactions
        sql.append(" SELECT 'Income' as type, i.incomeId as transactionId, i.amount, ");
        sql.append(" i.description, ").append(incomeDateExpr).append(" as date, i.userId, ");
        sql.append(" c.categoryId, c.categoryName, u.fullName ");
        sql.append(" FROM Income i ");
        sql.append(" JOIN Categories c ON i.categoryId = c.categoryId ");
        sql.append(" JOIN Users u ON i.userId = u.userId ");
        sql.append(" WHERE i.familyId = ? ");

        // Apply filters for income
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND i.categoryId = ? ");
        }
        if (memberFilter != null && !memberFilter.isEmpty()) {
            sql.append(" AND i.userId = ? ");
        }
        if (startDateMillis != null) {
            sql.append(" AND ").append(incomeDateExpr).append(" >= ? ");
        }
        if (endDateExclusiveMillis != null) {
            sql.append(" AND ").append(incomeDateExpr).append(" < ? ");
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (i.description LIKE ? OR c.categoryName LIKE ?) ");
        }
        if ("Expense".equals(typeFilter)) {
            sql.append(" AND 1=0 ");
        }

        sql.append(" UNION ALL ");

        // Expense transactions
        sql.append(" SELECT 'Expense' as type, e.expenseId as transactionId, e.amount, ");
        sql.append(" e.description, ").append(expenseDateExpr).append(" as date, e.userId, ");
        sql.append(" c.categoryId, c.categoryName, u.fullName ");
        sql.append(" FROM Expenses e ");
        sql.append(" JOIN Categories c ON e.categoryId = c.categoryId ");
        sql.append(" JOIN Users u ON e.userId = u.userId ");
        sql.append(" WHERE e.familyId = ? AND e.isActive = 1 ");

        // Apply same filters for expenses
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND e.categoryId = ? ");
        }
        if (memberFilter != null && !memberFilter.isEmpty()) {
            sql.append(" AND e.userId = ? ");
        }
        if (startDateMillis != null) {
            sql.append(" AND ").append(expenseDateExpr).append(" >= ? ");
        }
        if (endDateExclusiveMillis != null) {
            sql.append(" AND ").append(expenseDateExpr).append(" < ? ");
        }
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND (e.description LIKE ? OR c.categoryName LIKE ?) ");
        }
        if ("Income".equals(typeFilter)) {
            sql.append(" AND 1=0 ");
        }

        sql.append(") transactions ");
        sql.append("ORDER BY date DESC ");
        sql.append("LIMIT ? OFFSET ?");

        try (PreparedStatement pstmt = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            // Set parameters for income query
            pstmt.setString(paramIndex++, familyId);
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                pstmt.setString(paramIndex++, categoryFilter);
            }
            if (memberFilter != null && !memberFilter.isEmpty()) {
                pstmt.setString(paramIndex++, memberFilter);
            }
            if (startDateMillis != null) {
                pstmt.setLong(paramIndex++, startDateMillis);
            }
            if (endDateExclusiveMillis != null) {
                pstmt.setLong(paramIndex++, endDateExclusiveMillis);
            }
            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }

            // Set parameters for expense query (same filters)
            pstmt.setString(paramIndex++, familyId);
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                pstmt.setString(paramIndex++, categoryFilter);
            }
            if (memberFilter != null && !memberFilter.isEmpty()) {
                pstmt.setString(paramIndex++, memberFilter);
            }
            if (startDateMillis != null) {
                pstmt.setLong(paramIndex++, startDateMillis);
            }
            if (endDateExclusiveMillis != null) {
                pstmt.setLong(paramIndex++, endDateExclusiveMillis);
            }
            if (searchTerm != null && !searchTerm.isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }

            // Pagination
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex, (page - 1) * pageSize);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> transaction = new HashMap<>();
                transaction.put("type", rs.getString("type"));
                transaction.put("transactionId", rs.getString("transactionId"));
                transaction.put("amount", rs.getDouble("amount"));
                transaction.put("description", rs.getString("description"));
                transaction.put("date", rs.getTimestamp("date"));
                transaction.put("userId", rs.getString("userId"));
                transaction.put("userName", rs.getString("fullName"));
                transaction.put("categoryId", rs.getString("categoryId"));
                transaction.put("categoryName", rs.getString("categoryName"));
                transactions.add(transaction);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return transactions;
    }

    private Long parseDateFilter(String rawDate, boolean endExclusive) {
        if (rawDate == null) {
            return null;
        }
        String normalised = rawDate.trim();
        if (normalised.isEmpty()) {
            return null;
        }
        normalised = normalised.replace('/', '-').replaceAll("[^0-9\\-]", "");
        if (!normalised.contains("-") && normalised.matches("\\d{8}")) {
            normalised = normalised.substring(0, 4) + "-" +
                    normalised.substring(4, 6) + "-" +
                    normalised.substring(6);
        }
        try {
            LocalDate localDate = LocalDate.parse(normalised);
            if (endExclusive) {
                localDate = localDate.plusDays(1);
            }
            return localDate.atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    /**
     * Gets total transaction count for pagination.
     */
    public int getTotalTransactionCount(String familyId) {
        String sql = "SELECT COUNT(*) as total FROM (" +
                " SELECT incomeId FROM Income WHERE familyId = ?" +
                " UNION ALL " +
                " SELECT expenseId FROM Expenses WHERE familyId = ? AND isActive = 1" +
                ") transactions";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, familyId);
            pstmt.setString(2, familyId);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}
