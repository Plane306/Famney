package controller;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit tests for PasswordUtil class.
 * Tests password hashing and verification functionality.
 * Critical for security - ensures passwords are properly hashed.
 */
public class PasswordUtilTest {
    
    /**
     * Test that password hashing produces consistent results.
     * Same password should always produce same hash.
     */
    @Test
    public void testHashPassword_Consistency() {
        String password = "testpassword123";
        
        // Hash the same password twice
        String hash1 = PasswordUtil.hashPassword(password);
        String hash2 = PasswordUtil.hashPassword(password);
        
        // Verify both hashes are identical
        assertEquals(hash1, hash2, 
                    "Same password should produce same hash");
    }
    
    /**
     * Test that different passwords produce different hashes.
     * Security requirement - prevents hash collisions.
     */
    @Test
    public void testHashPassword_DifferentPasswords() {
        String password1 = "password123";
        String password2 = "password456";
        
        // Hash different passwords
        String hash1 = PasswordUtil.hashPassword(password1);
        String hash2 = PasswordUtil.hashPassword(password2);
        
        // Verify hashes are different
        assertNotEquals(hash1, hash2,
                       "Different passwords should produce different hashes");
    }
    
    /**
     * Test that hash is not the same as original password.
     * Passwords must never be stored as plain text.
     */
    @Test
    public void testHashPassword_NotPlainText() {
        String password = "mypassword";
        
        // Hash the password
        String hash = PasswordUtil.hashPassword(password);
        
        // Verify hash is not plain text
        assertNotEquals(password, hash,
                       "Hash should not be the same as plain text password");
    }
    
    /**
     * Test verifying correct password against hash.
     * Should return true when password matches the hash.
     */
    @Test
    public void testVerifyPassword_CorrectPassword() {
        String password = "correctpass";
        String hash = PasswordUtil.hashPassword(password);
        
        // Verify correct password
        boolean isValid = PasswordUtil.verifyPassword(password, hash);
        
        // Should return true for correct password
        assertTrue(isValid, 
                  "Should verify correct password successfully");
    }
    
    /**
     * Test verifying wrong password against hash.
     * Should return false when password doesn't match the hash.
     */
    @Test
    public void testVerifyPassword_WrongPassword() {
        String correctPassword = "correctpass";
        String wrongPassword = "wrongpass";
        String hash = PasswordUtil.hashPassword(correctPassword);
        
        // Verify wrong password
        boolean isValid = PasswordUtil.verifyPassword(wrongPassword, hash);
        
        // Should return false for wrong password
        assertFalse(isValid,
                   "Should not verify wrong password");
    }
    
    /**
     * Test that hash length is consistent.
     * SHA-256 should always produce 64-character hex string.
     */
    @Test
    public void testHashPassword_Length() {
        String password = "testlength";
        
        // Hash the password
        String hash = PasswordUtil.hashPassword(password);
        
        // SHA-256 produces 64-character hex string
        assertEquals(64, hash.length(),
                    "SHA-256 hash should be 64 characters long");
    }
    
    /**
     * Test hashing empty string.
     * Should still produce valid hash (edge case).
     */
    @Test
    public void testHashPassword_EmptyString() {
        String emptyPassword = "";
        
        // Hash empty string
        String hash = PasswordUtil.hashPassword(emptyPassword);
        
        // Should produce a hash (not null or empty)
        assertNotNull(hash, "Should hash empty string");
        assertFalse(hash.isEmpty(), "Hash should not be empty");
        assertEquals(64, hash.length(), "Hash should still be 64 characters");
    }
    
    /**
     * Test hashing very long password.
     * Should handle long passwords without errors (edge case).
     */
    @Test
    public void testHashPassword_LongPassword() {
        // Create 1000 character password
        String longPassword = "a".repeat(1000);
        
        // Hash long password
        String hash = PasswordUtil.hashPassword(longPassword);
        
        // Should produce valid hash
        assertNotNull(hash, "Should hash long password");
        assertEquals(64, hash.length(),
                    "Hash length should be consistent for long password");
    }
    
    /**
     * Test password with special characters.
     * Should correctly hash passwords containing symbols.
     */
    @Test
    public void testHashPassword_SpecialCharacters() {
        String specialPassword = "p@ssw0rd!#$%^&*()";
        
        // Hash password with special characters
        String hash = PasswordUtil.hashPassword(specialPassword);
        
        // Should verify correctly
        assertTrue(PasswordUtil.verifyPassword(specialPassword, hash),
                  "Should handle special characters in password");
    }
    
    /**
     * Test case sensitivity of passwords.
     * Passwords should be case-sensitive for security.
     */
    @Test
    public void testHashPassword_CaseSensitive() {
        String lowercase = "password";
        String uppercase = "PASSWORD";
        
        // Hash both versions
        String hashLower = PasswordUtil.hashPassword(lowercase);
        String hashUpper = PasswordUtil.hashPassword(uppercase);
        
        // Verify hashes are different
        assertNotEquals(hashLower, hashUpper,
                       "Password hashing should be case-sensitive");
    }
}