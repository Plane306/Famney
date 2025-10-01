package model.dao;

import model.User;
import controller.PasswordUtil;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * JUnit tests for UserManager DAO class.
 * Tests user authentication, CRUD operations, and email validation.
 * These tests use an in-memory SQLite database for isolation.
 */
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class UserManagerTest {
    
    private Connection testConn;
    private UserManager userManager;
    private String testFamilyId = "F0001";
    
    /**
     * Set up test database before all tests.
     * Creates tables and initialises UserManager with test connection.
     */
    @BeforeAll
    public void setUpDatabase() throws Exception {
        // Use in-memory database for testing (faster and isolated)
        testConn = DriverManager.getConnection("jdbc:sqlite::memory:");
        
        // Create Users table for testing
        Statement stmt = testConn.createStatement();
        stmt.execute(
            "CREATE TABLE Users (" +
            "userId VARCHAR(8) PRIMARY KEY, " +
            "email VARCHAR(100) NOT NULL UNIQUE, " +
            "password VARCHAR(255) NOT NULL, " +
            "fullName VARCHAR(100) NOT NULL, " +
            "role VARCHAR(20) NOT NULL, " +
            "familyId VARCHAR(8) NOT NULL, " +
            "joinDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "lastModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "isActive BOOLEAN NOT NULL DEFAULT TRUE)"
        );
        
        // Initialise UserManager with test connection
        userManager = new UserManager(testConn);
    }
    
    /**
     * Clean up database after each test to ensure test isolation.
     */
    @AfterEach
    public void cleanDatabase() throws SQLException {
        Statement stmt = testConn.createStatement();
        stmt.execute("DELETE FROM Users");
    }
    
    /**
     * Close database connection after all tests complete.
     */
    @AfterAll
    public void closeDatabase() throws SQLException {
        if (testConn != null && !testConn.isClosed()) {
            testConn.close();
        }
    }
    
    /**
     * Test creating a new user successfully.
     * Verifies that user can be created and stored in database.
     */
    @Test
    public void testCreateUser_Success() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("john@test.com");
        user.setPassword("password123");
        user.setFullName("John Smith");
        user.setRole("Family Head");
        user.setFamilyId(testFamilyId);
        
        // Create user in database
        boolean result = userManager.createUser(user);
        
        // Verify creation was successful
        assertTrue(result, "User should be created successfully");
        assertNotNull(user.getUserId(), "User ID should be generated");
    }
    
    /**
     * Test that creating user with duplicate email fails.
     * Database constraint should prevent duplicate emails.
     */
    @Test
    public void testCreateUser_DuplicateEmail() throws SQLException {
        // Create first user
        User user1 = new User();
        user1.setEmail("duplicate@test.com");
        user1.setPassword("password123");
        user1.setFullName("First User");
        user1.setRole("Adult");
        user1.setFamilyId(testFamilyId);
        
        userManager.createUser(user1);
        
        // Try to create second user with same email
        User user2 = new User();
        user2.setEmail("duplicate@test.com");
        user2.setPassword("different123");
        user2.setFullName("Second User");
        user2.setRole("Teen");
        user2.setFamilyId(testFamilyId);
        
        boolean result = userManager.createUser(user2);
        
        // Verify second user creation failed
        assertFalse(result, "Cannot create user with duplicate email");
    }
    
    /**
     * Test user authentication with correct credentials.
     * Should return user object when email and password match.
     */
    @Test
    public void testAuthenticate_ValidCredentials() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("auth@test.com");
        user.setPassword("testpass123");
        user.setFullName("Auth User");
        user.setRole("Family Head");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Try to authenticate with correct credentials
        User authenticated = userManager.authenticate("auth@test.com", "testpass123");
        
        // Verify authentication successful
        assertNotNull(authenticated, "Should authenticate with valid credentials");
        assertEquals("auth@test.com", authenticated.getEmail());
        assertEquals("Auth User", authenticated.getFullName());
    }
    
    /**
     * Test authentication with wrong password.
     * Should return null when password doesn't match.
     */
    @Test
    public void testAuthenticate_WrongPassword() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("wrong@test.com");
        user.setPassword("correctpass");
        user.setFullName("Test User");
        user.setRole("Adult");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Try to authenticate with wrong password
        User authenticated = userManager.authenticate("wrong@test.com", "wrongpass");
        
        // Verify authentication failed
        assertNull(authenticated, "Should not authenticate with wrong password");
    }
    
    /**
     * Test authentication with non-existent email.
     * Should return null when email doesn't exist in database.
     */
    @Test
    public void testAuthenticate_NonExistentEmail() throws SQLException {
        // Try to authenticate with email that doesn't exist
        User authenticated = userManager.authenticate("notexist@test.com", "anypass");
        
        // Verify authentication failed
        assertNull(authenticated, "Should not authenticate non-existent user");
    }
    
    /**
     * Test finding user by email address.
     * Should return user object when email exists in database.
     */
    @Test
    public void testFindByEmail_Exists() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("find@test.com");
        user.setPassword("password123");
        user.setFullName("Findable User");
        user.setRole("Teen");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Find user by email
        User found = userManager.findByEmail("find@test.com");
        
        // Verify user was found
        assertNotNull(found, "Should find user by email");
        assertEquals("find@test.com", found.getEmail());
        assertEquals("Findable User", found.getFullName());
    }
    
    /**
     * Test finding user with email that doesn't exist.
     * Should return null when email not found in database.
     */
    @Test
    public void testFindByEmail_NotExists() throws SQLException {
        // Try to find non-existent email
        User found = userManager.findByEmail("notfound@test.com");
        
        // Verify no user was found
        assertNull(found, "Should return null for non-existent email");
    }
    
    /**
     * Test checking if email exists in database.
     * Used during registration to prevent duplicate emails.
     */
    @Test
    public void testEmailExists() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("exists@test.com");
        user.setPassword("password123");
        user.setFullName("Existing User");
        user.setRole("Adult");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Check if email exists
        boolean exists = userManager.emailExists("exists@test.com");
        boolean notExists = userManager.emailExists("notexists@test.com");
        
        // Verify results
        assertTrue(exists, "Email should exist in database");
        assertFalse(notExists, "Email should not exist in database");
    }
    
    /**
     * Test updating user profile information.
     * Should update email and full name successfully.
     */
    @Test
    public void testUpdateUser() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("old@test.com");
        user.setPassword("password123");
        user.setFullName("Old Name");
        user.setRole("Adult");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Update user details
        user.setEmail("new@test.com");
        user.setFullName("New Name");
        
        boolean updated = userManager.updateUser(user);
        
        // Verify update was successful
        assertTrue(updated, "User should be updated successfully");
        
        // Verify changes persisted in database
        User found = userManager.findByEmail("new@test.com");
        assertNotNull(found, "Should find user with new email");
        assertEquals("New Name", found.getFullName());
    }
    
    /**
     * Test updating user password.
     * Password should be hashed before storing in database.
     */
    @Test
    public void testUpdatePassword() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("passupdate@test.com");
        user.setPassword("oldpassword");
        user.setFullName("Password User");
        user.setRole("Adult");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        String userId = user.getUserId();
        
        // Update password
        boolean updated = userManager.updatePassword(userId, "newpassword");
        
        // Verify password update was successful
        assertTrue(updated, "Password should be updated successfully");
        
        // Verify can authenticate with new password
        User authenticated = userManager.authenticate("passupdate@test.com", "newpassword");
        assertNotNull(authenticated, "Should authenticate with new password");
        
        // Verify cannot authenticate with old password
        User notAuthenticated = userManager.authenticate("passupdate@test.com", "oldpassword");
        assertNull(notAuthenticated, "Should not authenticate with old password");
    }
    
    /**
     * Test updating user role (Family Head functionality).
     * Only Family Head should be able to change member roles.
     */
    @Test
    public void testUpdateUserRole() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("role@test.com");
        user.setPassword("password123");
        user.setFullName("Role User");
        user.setRole("Teen");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        String userId = user.getUserId();
        
        // Update role from Teen to Adult
        boolean updated = userManager.updateUserRole(userId, "Adult");
        
        // Verify role update was successful
        assertTrue(updated, "Role should be updated successfully");
        
        // Verify role changed in database
        User found = userManager.findByEmail("role@test.com");
        assertEquals("Adult", found.getRole());
    }
    
    /**
     * Test soft deleting user (setting isActive to false).
     * User data should remain in database but marked as inactive.
     */
    @Test
    public void testDeleteUser() throws SQLException {
        // Create test user
        User user = new User();
        user.setEmail("delete@test.com");
        user.setPassword("password123");
        user.setFullName("Delete User");
        user.setRole("Kid");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        String userId = user.getUserId();
        
        // Soft delete user
        boolean deleted = userManager.deleteUser(userId);
        
        // Verify deletion was successful
        assertTrue(deleted, "User should be soft deleted successfully");
        
        // Verify user cannot be found (findByEmail only returns active users)
        User found = userManager.findByEmail("delete@test.com");
        assertNull(found, "Deleted user should not be found by active queries");
    }
    
    /**
     * Test password hashing during user creation.
     * Password should be hashed, not stored as plain text.
     */
    @Test
    public void testPasswordHashingOnCreation() throws SQLException {
        // Create user with plain text password
        User user = new User();
        user.setEmail("hash@test.com");
        user.setPassword("plainpassword");
        user.setFullName("Hash User");
        user.setRole("Adult");
        user.setFamilyId(testFamilyId);
        
        userManager.createUser(user);
        
        // Retrieve user from database
        User found = userManager.findByEmail("hash@test.com");
        
        // Verify password is hashed (not equal to plain text)
        assertNotEquals("plainpassword", found.getPassword(), 
                       "Password should be hashed, not stored as plain text");
        
        // Verify hashed password can be verified
        assertTrue(PasswordUtil.verifyPassword("plainpassword", found.getPassword()),
                  "Should be able to verify original password against hash");
    }
}