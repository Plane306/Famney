package model.dao;

import model.Income;
import java.sql.*;
import java.util.*;

public class IncomeManager {
	private Connection connection;

	public IncomeManager(Connection connection) {
		this.connection = connection;
	}

	// Add income to DB
	public boolean addIncome(Income income) {
		String sql = "INSERT INTO Incomes (incomeId, familyId, userId, categoryId, amount, description, incomeDate, createdDate, lastModifiedDate, isActive) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			String incomeId = UUID.randomUUID().toString().substring(0,8);
			ps.setString(1, incomeId);
			ps.setString(2, income.getFamilyId());
			ps.setString(3, income.getUserId());
			ps.setString(4, income.getCategoryId());
			ps.setDouble(5, income.getAmount());
			ps.setString(6, income.getDescription());
			ps.setTimestamp(7, new java.sql.Timestamp(income.getIncomeDate().getTime()));
			ps.setTimestamp(8, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setBoolean(10, true);
			int rows = ps.executeUpdate();
			return rows > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
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
				incomes.add(mapResultSetToIncome(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return incomes;
	}

	// Update income
	public boolean updateIncome(Income income) {
		String sql = "UPDATE Incomes SET categoryId=?, amount=?, description=?, incomeDate=?, lastModifiedDate=? WHERE incomeId=? AND isActive=1";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setString(1, income.getCategoryId());
			ps.setDouble(2, income.getAmount());
			ps.setString(3, income.getDescription());
			ps.setTimestamp(4, new java.sql.Timestamp(income.getIncomeDate().getTime()));
			ps.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(6, income.getIncomeId());
			int rows = ps.executeUpdate();
			return rows > 0;
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
			int rows = ps.executeUpdate();
			return rows > 0;
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
			rs.getBoolean("isActive"),
			null // receiptUrl (future)
		);
	}
}
