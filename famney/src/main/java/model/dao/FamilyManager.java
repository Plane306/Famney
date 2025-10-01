package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import model.Family;
import controller.IdGenerator;

// Data Access Object for Family table operations
// Handles family creation and member management
public class FamilyManager {
    
    private Connection conn;
    
    // Constructor takes database connection from ConnServlet
    public FamilyManager(Connection conn) throws SQLException {
        this.conn = conn;
    }
    
    // Create new family in database
    // Generates family ID and code automatically
    // Returns the created Family object with generated values
    public Family createFamily(Family family) throws SQLException {
        // Generate unique family ID and code
        family.setFamilyId(IdGenerator.generateFamilyId());
        family.setFamilyCode(IdGenerator.generateFamilyCode());
        
        String sql = "INSERT INTO Families (familyId, familyCode, familyName, familyHead, " +
                     "memberCount, createdDate, lastModifiedDate, isActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, family.getFamilyId());
            stmt.setString(2, family.getFamilyCode());
            stmt.setString(3, family.getFamilyName().trim());
            stmt.setString(4, family.getFamilyHead());
            stmt.setInt(5, 1); // Initial member count is 1 (the family head)
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(8, true);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                return family;
            }
            
            return null;
        }
    }
    
    // Find family by family code
    // Used when member joins existing family
    // Returns Family object if found, null if not found
    public Family findByFamilyCode(String familyCode) throws SQLException {
        String sql = "SELECT * FROM Families WHERE familyCode = ? AND isActive = 1";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, familyCode.trim().toUpperCase());
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Family family = new Family();
                family.setFamilyId(rs.getString("familyId"));
                family.setFamilyCode(rs.getString("familyCode"));
                family.setFamilyName(rs.getString("familyName"));
                family.setFamilyHead(rs.getString("familyHead"));
                family.setMemberCount(rs.getInt("memberCount"));
                family.setCreatedDate(rs.getTimestamp("createdDate"));
                family.setLastModifiedDate(rs.getTimestamp("lastModifiedDate"));
                family.setActive(rs.getBoolean("isActive"));
                
                return family;
            }
            
            return null;
        }
    }
    
    // Find family by family ID
    // Used to get family details for logged in user
    public Family findByFamilyId(String familyId) throws SQLException {
        String sql = "SELECT * FROM Families WHERE familyId = ? AND isActive = 1";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, familyId);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Family family = new Family();
                family.setFamilyId(rs.getString("familyId"));
                family.setFamilyCode(rs.getString("familyCode"));
                family.setFamilyName(rs.getString("familyName"));
                family.setFamilyHead(rs.getString("familyHead"));
                family.setMemberCount(rs.getInt("memberCount"));
                family.setCreatedDate(rs.getTimestamp("createdDate"));
                family.setLastModifiedDate(rs.getTimestamp("lastModifiedDate"));
                family.setActive(rs.getBoolean("isActive"));
                
                return family;
            }
            
            return null;
        }
    }
    
    // Increment member count when new member joins
    // Called after successfully adding new user to family
    public boolean incrementMemberCount(String familyId) throws SQLException {
        String sql = "UPDATE Families SET memberCount = memberCount + 1, " +
                     "lastModifiedDate = ? WHERE familyId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setString(2, familyId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Decrement member count when member leaves or is removed
    // Only decrement if count is greater than 1
    public boolean decrementMemberCount(String familyId) throws SQLException {
        String sql = "UPDATE Families SET memberCount = memberCount - 1, " +
                     "lastModifiedDate = ? WHERE familyId = ? AND memberCount > 1";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setString(2, familyId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Update family name
    // Only Family Head can change family name
    public boolean updateFamilyName(String familyId, String newName) throws SQLException {
        String sql = "UPDATE Families SET familyName = ?, lastModifiedDate = ? " +
                     "WHERE familyId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newName.trim());
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, familyId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Check if family code already exists
    // Used during family creation to ensure unique code
    public boolean familyCodeExists(String familyCode) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Families WHERE familyCode = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, familyCode.trim().toUpperCase());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }
    
    // Get current member count for a family
    // Used for display and validation
    public int getMemberCount(String familyId) throws SQLException {
        String sql = "SELECT memberCount FROM Families WHERE familyId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, familyId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("memberCount");
            }
        }
        
        return 0;
    }
}