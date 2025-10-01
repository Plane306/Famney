package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.User;
import controller.PasswordUtil;
import controller.IdGenerator;

// Data Access Object for User table operations
// Handles all database operations for users
public class UserManager {
    
    private Connection conn;
    
    // Constructor takes database connection from ConnServlet
    public UserManager(Connection conn) throws SQLException {
        this.conn = conn;
    }
    
    // Create new user in database
    // Generates user ID automatically and hashes password
    // Returns true if successful, false if failed (duplicate email)
    public boolean createUser(User user) throws SQLException {
        // Generate unique user ID
        user.setUserId(IdGenerator.generateUserId());
        
        // Hash password before storing
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        
        String sql = "INSERT INTO Users (userId, email, password, fullName, role, familyId, " +
                     "joinDate, createdDate, lastModifiedDate, isActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUserId());
            stmt.setString(2, user.getEmail().trim());
            stmt.setString(3, hashedPassword);
            stmt.setString(4, user.getFullName().trim());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getFamilyId());
            stmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(10, true);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            // Check if error is due to duplicate email
            if (e.getMessage().contains("UNIQUE constraint failed")) {
                return false;
            }
            throw e;
        }
    }
    
    // Find user by email for login
    // Returns User object if found, null if not found
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ? AND isActive = 1";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.trim());
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("fullName"));
                user.setRole(rs.getString("role"));
                user.setFamilyId(rs.getString("familyId"));
                user.setJoinDate(rs.getTimestamp("joinDate"));
                user.setCreatedDate(rs.getTimestamp("createdDate"));
                user.setLastModifiedDate(rs.getTimestamp("lastModifiedDate"));
                user.setActive(rs.getBoolean("isActive"));
                
                return user;
            }
            
            return null;
        }
    }
    
    // Authenticate user login
    // Returns User object if credentials valid, null if invalid
    public User authenticate(String email, String password) throws SQLException {
        User user = findByEmail(email);
        
        if (user == null) {
            return null;
        }
        
        // Verify password matches stored hash
        if (PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        
        return null;
    }
    
    // Get all users in a family
    // Used by family management page
    public List<User> getUsersByFamily(String familyId) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE familyId = ? AND isActive = 1 ORDER BY role";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, familyId);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("fullName"));
                user.setRole(rs.getString("role"));
                user.setFamilyId(rs.getString("familyId"));
                user.setJoinDate(rs.getTimestamp("joinDate"));
                user.setCreatedDate(rs.getTimestamp("createdDate"));
                user.setLastModifiedDate(rs.getTimestamp("lastModifiedDate"));
                user.setActive(rs.getBoolean("isActive"));
                
                users.add(user);
            }
        }
        
        return users;
    }
    
    // Update user profile
    // Only updates email, full name, and optionally password
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET email = ?, fullName = ?, lastModifiedDate = ? " +
                     "WHERE userId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail().trim());
            stmt.setString(2, user.getFullName().trim());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setString(4, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Update user password
    // Separate method for password updates
    public boolean updatePassword(String userId, String newPassword) throws SQLException {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        
        String sql = "UPDATE Users SET password = ?, lastModifiedDate = ? WHERE userId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Update user role
    // Only Family Head can change roles
    public boolean updateUserRole(String userId, String newRole) throws SQLException {
        String sql = "UPDATE Users SET role = ?, lastModifiedDate = ? WHERE userId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Soft delete user (set isActive to false)
    // Only Family Head can remove members
    public boolean deleteUser(String userId) throws SQLException {
        String sql = "UPDATE Users SET isActive = 0, lastModifiedDate = ? WHERE userId = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setString(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Check if email already exists in database
    // Used during registration validation
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.trim());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }
}