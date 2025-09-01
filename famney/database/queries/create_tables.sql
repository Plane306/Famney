-- Famney Family Financial Management System SQL Tables

-- Drop tables if they exist (in reverse order due to foreign key dependencies)
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Families;

-- F101: FAMILIES TABLE
-- Core entity for family groups with unique family codes
CREATE TABLE Families (
    familyId VARCHAR(8) PRIMARY KEY,
    familyCode VARCHAR(15) NOT NULL UNIQUE,
    familyName VARCHAR(100) NOT NULL,
    familyHead VARCHAR(8) NOT NULL,
    memberCount INT NOT NULL DEFAULT 1 CHECK (memberCount >= 1),
    createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lastModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    isActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- F101: USERS TABLE  
-- Family members with role-based access control
CREATE TABLE Users (
    userId VARCHAR(8) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullName VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Family Head', 'Adult', 'Teen', 'Kid')),
    familyId VARCHAR(8) NOT NULL,
    joinDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lastModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Foreign key constraint to Families table
    CONSTRAINT fk_users_family FOREIGN KEY (familyId) REFERENCES Families(familyId) ON DELETE CASCADE
);

-- F102: CATEGORIES TABLE
-- Expense and income categories for budget organization
CREATE TABLE Categories (
    categoryId VARCHAR(8) PRIMARY KEY,
    familyId VARCHAR(8) NOT NULL,
    categoryName VARCHAR(50) NOT NULL,
    categoryType VARCHAR(10) NOT NULL CHECK (categoryType IN ('Expense', 'Income')),
    isDefault BOOLEAN NOT NULL DEFAULT FALSE,
    description VARCHAR(200),
    createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lastModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Foreign key constraint to Families table
    CONSTRAINT fk_categories_family FOREIGN KEY (familyId) REFERENCES Families(familyId) ON DELETE CASCADE,
    
    -- Unique constraint: category name must be unique within a family
    CONSTRAINT uk_category_family_name UNIQUE (familyId, categoryName)
);

-- F101 & F102: CONSTRAINTS & BUSINESS RULES:
-- 1. Family Head role: Only one per family
-- 2. Family Code: Must be unique across all families
-- 3. Email: Must be unique across all users
-- 4. Category Name: Must be unique within each family
-- 5. Member Count: Must be >= 1 (family must have at least one member)
-- 6. Roles: Restricted to 'Family Head', 'Adult', 'Teen', 'Kid'
-- 7. Category Types: Restricted to 'Expense', 'Income'
-- 8. Cascade Delete: Removing family removes all users and categories
-- 9. Default Categories: Cannot be deleted (enforced in application logic)
-- 10. Active Status: Soft delete mechanism for all entities