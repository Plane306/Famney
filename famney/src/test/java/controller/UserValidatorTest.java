package controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit tests for UserValidator class.
 * Tests input validation rules for user registration and updates.
 * Critical for preventing invalid data and SQL injection.
 */
public class UserValidatorTest {
    
    private UserValidator validator;
    
    /**
     * Create new validator instance before each test.
     */
    @BeforeEach
    public void setUp() {
        validator = new UserValidator();
    }
    
    /**
     * Test validating correct email formats.
     * Should accept standard email patterns.
     */
    @Test
    public void testValidateEmail_ValidFormats() {
        // Test various valid email formats
        assertTrue(validator.validateEmail("user@example.com"),
                  "Should accept standard email");
        assertTrue(validator.validateEmail("test.user@domain.co.uk"),
                  "Should accept email with dots and subdomains");
        assertTrue(validator.validateEmail("user123@test.com"),
                  "Should accept email with numbers");
        assertTrue(validator.validateEmail("user+tag@example.com"),
                  "Should accept email with plus sign");
    }
    
    /**
     * Test rejecting invalid email formats.
     * Should reject emails missing @ or domain.
     */
    @Test
    public void testValidateEmail_InvalidFormats() {
        // Test various invalid email formats
        assertFalse(validator.validateEmail("notanemail"),
                   "Should reject email without @");
        assertFalse(validator.validateEmail("@example.com"),
                   "Should reject email without username");
        assertFalse(validator.validateEmail("user@"),
                   "Should reject email without domain");
        assertFalse(validator.validateEmail("user @example.com"),
                   "Should reject email with spaces");
        assertFalse(validator.validateEmail(""),
                   "Should reject empty string");
        assertFalse(validator.validateEmail(null),
                   "Should reject null email");
    }
    
    /**
     * Test validating correct full names.
     * Should accept names with 2-100 characters, letters only.
     */
    @Test
    public void testValidateFullName_ValidNames() {
        // Test valid name formats
        assertTrue(validator.validateFullName("John Smith"),
                  "Should accept standard name");
        assertTrue(validator.validateFullName("Mary Jane Watson"),
                  "Should accept name with multiple words");
        assertTrue(validator.validateFullName("AB"),
                  "Should accept minimum 2 characters");
        
        // Test 100 character name (maximum allowed)
        String longName = "A".repeat(100);
        assertTrue(validator.validateFullName(longName),
                  "Should accept 100 character name");
    }
    
    /**
     * Test rejecting invalid full names.
     * Should reject names with numbers, symbols, or wrong length.
     */
    @Test
    public void testValidateFullName_InvalidNames() {
        // Test invalid name formats
        assertFalse(validator.validateFullName("John123"),
                   "Should reject name with numbers");
        assertFalse(validator.validateFullName("John@Smith"),
                   "Should reject name with symbols");
        assertFalse(validator.validateFullName("A"),
                   "Should reject single character name");
        assertFalse(validator.validateFullName(""),
                   "Should reject empty string");
        assertFalse(validator.validateFullName(null),
                   "Should reject null name");
        
        // Test name too long (over 100 characters)
        String tooLong = "A".repeat(101);
        assertFalse(validator.validateFullName(tooLong),
                   "Should reject name over 100 characters");
    }
    
    /**
     * Test validating correct passwords.
     * Should accept passwords with minimum 6 characters.
     */
    @Test
    public void testValidatePassword_ValidPasswords() {
        // Test valid passwords
        assertTrue(validator.validatePassword("123456"),
                  "Should accept 6 character password");
        assertTrue(validator.validatePassword("password123"),
                  "Should accept longer password");
        assertTrue(validator.validatePassword("P@ssw0rd!"),
                  "Should accept password with special characters");
    }
    
    /**
     * Test rejecting invalid passwords.
     * Should reject passwords shorter than 6 characters.
     */
    @Test
    public void testValidatePassword_InvalidPasswords() {
        // Test invalid passwords
        assertFalse(validator.validatePassword("12345"),
                   "Should reject password with 5 characters");
        assertFalse(validator.validatePassword(""),
                   "Should reject empty password");
        assertFalse(validator.validatePassword(null),
                   "Should reject null password");
    }
    
    /**
     * Test validating correct family names.
     * Should accept family names with 2-100 characters.
     */
    @Test
    public void testValidateFamilyName_ValidNames() {
        // Test valid family names
        assertTrue(validator.validateFamilyName("The Smiths"),
                  "Should accept standard family name");
        assertTrue(validator.validateFamilyName("AB"),
                  "Should accept minimum 2 characters");
        
        // Test 100 character family name (maximum)
        String longName = "A".repeat(100);
        assertTrue(validator.validateFamilyName(longName),
                  "Should accept 100 character family name");
    }
    
    /**
     * Test rejecting invalid family names.
     * Should reject family names that are too short or too long.
     */
    @Test
    public void testValidateFamilyName_InvalidNames() {
        // Test invalid family names
        assertFalse(validator.validateFamilyName("A"),
                   "Should reject single character family name");
        assertFalse(validator.validateFamilyName(""),
                   "Should reject empty family name");
        assertFalse(validator.validateFamilyName(null),
                   "Should reject null family name");
        
        // Test family name too long
        String tooLong = "A".repeat(101);
        assertFalse(validator.validateFamilyName(tooLong),
                   "Should reject family name over 100 characters");
    }
    
    /**
     * Test validating correct user roles.
     * Should accept only: Family Head, Adult, Teen, Kid.
     */
    @Test
    public void testValidateRole_ValidRoles() {
        // Test all valid roles
        assertTrue(validator.validateRole("Family Head"),
                  "Should accept Family Head role");
        assertTrue(validator.validateRole("Adult"),
                  "Should accept Adult role");
        assertTrue(validator.validateRole("Teen"),
                  "Should accept Teen role");
        assertTrue(validator.validateRole("Kid"),
                  "Should accept Kid role");
    }
    
    /**
     * Test rejecting invalid user roles.
     * Should reject any role not in the allowed list.
     */
    @Test
    public void testValidateRole_InvalidRoles() {
        // Test invalid roles
        assertFalse(validator.validateRole("Administrator"),
                   "Should reject invalid role");
        assertFalse(validator.validateRole("Guest"),
                   "Should reject Guest role");
        assertFalse(validator.validateRole(""),
                   "Should reject empty role");
        assertFalse(validator.validateRole(null),
                   "Should reject null role");
    }
    
    /**
     * Test validating correct family code format.
     * Should accept format FAMNEY-XXXX where X is alphanumeric.
     */
    @Test
    public void testValidateFamilyCode_ValidCodes() {
        // Test valid family code formats
        assertTrue(validator.validateFamilyCode("FAMNEY-A1B2"),
                  "Should accept valid family code");
        assertTrue(validator.validateFamilyCode("FAMNEY-ABCD"),
                  "Should accept code with all letters");
        assertTrue(validator.validateFamilyCode("FAMNEY-1234"),
                  "Should accept code with all numbers");
        assertTrue(validator.validateFamilyCode("famney-a1b2"),
                  "Should accept lowercase (will be converted to uppercase)");
    }
    
    /**
     * Test rejecting invalid family code formats.
     * Should reject codes not matching FAMNEY-XXXX pattern.
     */
    @Test
    public void testValidateFamilyCode_InvalidCodes() {
        // Test invalid family code formats
        assertFalse(validator.validateFamilyCode("FAMNEY-ABC"),
                   "Should reject code with 3 characters");
        assertFalse(validator.validateFamilyCode("FAMNEY-ABCDE"),
                   "Should reject code with 5 characters");
        assertFalse(validator.validateFamilyCode("FAMILY-A1B2"),
                   "Should reject wrong prefix");
        assertFalse(validator.validateFamilyCode("FAMNEYA1B2"),
                   "Should reject code without hyphen");
        assertFalse(validator.validateFamilyCode(""),
                   "Should reject empty string");
        assertFalse(validator.validateFamilyCode(null),
                   "Should reject null code");
    }
    
    /**
     * Test checking if passwords match.
     * Used during registration to confirm password.
     */
    @Test
    public void testPasswordsMatch() {
        // Test matching passwords
        assertTrue(validator.passwordsMatch("password123", "password123"),
                  "Should return true for matching passwords");
        
        // Test non-matching passwords
        assertFalse(validator.passwordsMatch("password123", "different123"),
                   "Should return false for different passwords");
        assertFalse(validator.passwordsMatch("password", "Password"),
                   "Should be case-sensitive");
        assertFalse(validator.passwordsMatch(null, "password"),
                   "Should handle null password");
        assertFalse(validator.passwordsMatch("password", null),
                   "Should handle null confirm password");
    }
    
    /**
     * Test trimming whitespace in validation.
     * Validator should handle leading/trailing spaces.
     */
    @Test
    public void testValidation_WhitespaceTrimming() {
        // Test that validation trims whitespace
        assertTrue(validator.validateEmail(" user@test.com "),
                  "Should trim whitespace from email");
        assertTrue(validator.validateFullName(" John Smith "),
                  "Should trim whitespace from name");
        assertTrue(validator.validateFamilyCode(" FAMNEY-A1B2 "),
                  "Should trim whitespace from family code");
    }
}