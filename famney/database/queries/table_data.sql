-- Famney Sample Data for Testing (R1)
-- The hash below is SHA-256("password123" + "famney_salt")

-- Clear existing data if any
DELETE FROM Categories;
DELETE FROM Users;
DELETE FROM Families;
DELETE FROM BudgetCategories;
DELETE FROM Budgets;

-- F101: Sample Family Data
-- The Smith Family with family code FAMNEY-A1B2
INSERT INTO Families (familyId, familyCode, familyName, familyHead, memberCount, createdDate, lastModifiedDate, isActive) 
VALUES (
    'F0001',
    'FAMNEY-A1B2',
    'The Smith Family',
    'U0001',
    4,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    1
);

-- F101: Sample Users (4 family members with different roles)
-- Password for all users: "password123"
-- Hash generated using: PasswordUtil.hashPassword("password123")
-- Run PasswordUtil.main() to verify the hash value

-- User 1: John Smith (Family Head)
INSERT INTO Users (userId, email, password, fullName, role, familyId, joinDate, createdDate, lastModifiedDate, isActive)
VALUES (
    'U0001',
    'john@smith.com',
    '7fb287e06294e9f3ab31527c53b804e50409a7a6ac13f51d58b927eb69a5e053',
    'John Smith',
    'Family Head',
    'F0001',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    1
);

-- User 2: Jane Smith (Adult)
INSERT INTO Users (userId, email, password, fullName, role, familyId, joinDate, createdDate, lastModifiedDate, isActive)
VALUES (
    'U0002',
    'jane@smith.com',
    '7fb287e06294e9f3ab31527c53b804e50409a7a6ac13f51d58b927eb69a5e053',
    'Jane Smith',
    'Adult',
    'F0001',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    1
);

-- User 3: Mike Smith (Teen)
INSERT INTO Users (userId, email, password, fullName, role, familyId, joinDate, createdDate, lastModifiedDate, isActive)
VALUES (
    'U0003',
    'mike@smith.com',
    '7fb287e06294e9f3ab31527c53b804e50409a7a6ac13f51d58b927eb69a5e053',
    'Mike Smith',
    'Teen',
    'F0001',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    1
);

-- User 4: Lucy Smith (Kid)
INSERT INTO Users (userId, email, password, fullName, role, familyId, joinDate, createdDate, lastModifiedDate, isActive)
VALUES (
    'U0004',
    'lucy@smith.com',
    '7fb287e06294e9f3ab31527c53b804e50409a7a6ac13f51d58b927eb69a5e053',
    'Lucy Smith',
    'Kid',
    'F0001',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    1
);

-- F102: Default Expense Categories (6 categories)
INSERT INTO Categories (categoryId, familyId, categoryName, categoryType, isDefault, description, createdDate, lastModifiedDate, isActive)
VALUES
    ('C0001', 'F0001', 'Food & Dining', 'Expense', 1, 'Groceries, restaurants, takeaways', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0002', 'F0001', 'Transportation', 'Expense', 1, 'Petrol, public transport, car maintenance', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0003', 'F0001', 'Utilities', 'Expense', 1, 'Electricity, water, gas, internet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0004', 'F0001', 'Entertainment', 'Expense', 1, 'Movies, games, hobbies', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0005', 'F0001', 'Healthcare', 'Expense', 1, 'Medical expenses, insurance', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0006', 'F0001', 'Shopping', 'Expense', 1, 'Clothes, electronics, household items', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);

-- F102: Default Income Categories (4 categories)
INSERT INTO Categories (categoryId, familyId, categoryName, categoryType, isDefault, description, createdDate, lastModifiedDate, isActive)
VALUES
    ('C0007', 'F0001', 'Salary', 'Income', 1, 'Monthly salary from employment', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0008', 'F0001', 'Freelance', 'Income', 1, 'Freelance work and contracts', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0009', 'F0001', 'Allowance', 'Income', 1, 'Pocket money and allowances', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),
    ('C0010', 'F0001', 'Investment', 'Income', 1, 'Dividends, interest, capital gains', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1);

-- ==================================
-- INCOMES (last 3 months)
-- ==================================

-- Month: October 2025
INSERT INTO Incomes (incomeId, familyId, userId, categoryId, amount, description, incomeDate, isRecurring, isRecurrenceActive, frequency, isActive, source)
VALUES
('INC201','F0001','USR001','C0007',1500.00,'Salary','2025-10-15',1,1,'Monthly',1,'Company A'),
('INC202','F0001','USR002','C0008',300.00,'Freelance','2025-10-15',0,0,NULL,1,'Client B'),
('INC203','F0001','USR003','C0007',1600.00,'Salary','2025-10-15',1,1,'Monthly',1,'Company C'),
('INC204','F0001','USR004','C0010',400.00,'Investment','2025-10-15',0,0,NULL,1,'Broker D'),
('INC205','F0001','USR001','C0008',250.00,'Part-time','2025-10-15',0,0,NULL,1,'Company E'),
('INC206','F0001','USR002','C0010',450.00,'Investment','2025-10-15',1,1,'Monthly',1,'Broker F'),
('INC207','F0001','USR003','C0007',1550.00,'Salary','2025-10-15',1,1,'Monthly',1,'Company G'),
('INC208','F0001','USR004','C0008',220.00,'Freelance','2025-10-15',0,0,NULL,1,'Client H'),
('INC209','F0001','USR001','C0010',500.00,'Bonus','2025-10-15',0,0,NULL,1,'Company I'),
('INC210','F0001','USR002','C0007',1400.00,'Salary','2025-10-15',1,1,'Monthly',1,'Company J');

-- Month: September 2025
INSERT INTO Incomes (incomeId, familyId, userId, categoryId, amount, description, incomeDate, isRecurring, isRecurrenceActive, frequency, isActive, source)
VALUES
('INC211','F0001','USR001','C0007',1480.00,'Salary','2025-09-15',1,1,'Monthly',1,'Company A'),
('INC212','F0001','USR002','C0008',280.00,'Freelance','2025-09-15',0,0,NULL,1,'Client B'),
('INC213','F0001','USR003','C0007',1580.00,'Salary','2025-09-15',1,1,'Monthly',1,'Company C'),
('INC214','F0001','USR004','C0010',420.00,'Investment','2025-09-15',0,0,NULL,1,'Broker D'),
('INC215','F0001','USR001','C0008',260.00,'Part-time','2025-09-15',0,0,NULL,1,'Company E'),
('INC216','F0001','USR002','C0010',460.00,'Investment','2025-09-15',1,1,'Monthly',1,'Broker F'),
('INC217','F0001','USR003','C0007',1500.00,'Salary','2025-09-15',1,1,'Monthly',1,'Company G'),
('INC218','F0001','USR004','C0008',210.00,'Freelance','2025-09-15',0,0,NULL,1,'Client H'),
('INC219','F0001','USR001','C0010',480.00,'Bonus','2025-09-15',0,0,NULL,1,'Company I'),
('INC220','F0001','USR002','C0007',1420.00,'Salary','2025-09-15',1,1,'Monthly',1,'Company J');

-- Month: August 2025
INSERT INTO Incomes (incomeId, familyId, userId, categoryId, amount, description, incomeDate, isRecurring, isRecurrenceActive, frequency, isActive, source)
VALUES
('INC221','F0001','USR001','C0007',1450.00,'Salary','2025-08-15',1,1,'Monthly',1,'Company A'),
('INC222','F0001','USR002','C0008',260.00,'Freelance','2025-08-15',0,0,NULL,1,'Client B'),
('INC223','F0001','USR003','C0007',1520.00,'Salary','2025-08-15',1,1,'Monthly',1,'Company C'),
('INC224','F0001','USR004','C0010',410.00,'Investment','2025-08-15',0,0,NULL,1,'Broker D'),
('INC225','F0001','USR001','C0008',240.00,'Part-time','2025-08-15',0,0,NULL,1,'Company E'),
('INC226','F0001','USR002','C0010',430.00,'Investment','2025-08-15',1,1,'Monthly',1,'Broker F'),
('INC227','F0001','USR003','C0007',1480.00,'Salary','2025-08-15',1,1,'Monthly',1,'Company G'),
('INC228','F0001','USR004','C0008',230.00,'Freelance','2025-08-15',0,0,NULL,1,'Client H'),
('INC229','F0001','USR001','C0010',470.00,'Bonus','2025-08-15',0,0,NULL,1,'Company I'),
('INC230','F0001','USR002','C0007',1400.00,'Salary','2025-08-15',1,1,'Monthly',1,'Company J');

-- ==================================
-- EXPENSES (last 3 months)
-- ==================================

-- October 2025
INSERT INTO Expenses (expenseId, familyId, userId, categoryId, amount, description, expenseDate, isActive)
VALUES
('EXP201','F0001','USR001','C0001',150.00,'Groceries','2025-10-15',1),
('EXP202','F0001','USR002','C0002',60.00,'Transport','2025-10-15',1),
('EXP203','F0001','USR003','C0003',300.00,'Utilities','2025-10-15',1),
('EXP204','F0001','USR004','C0004',50.00,'Entertainment','2025-10-15',1),
('EXP205','F0001','USR001','C0005',200.00,'Healthcare','2025-10-15',1),
('EXP206','F0001','USR002','C0006',180.00,'Shopping','2025-10-15',1),
('EXP207','F0001','USR003','C0001',120.00,'Groceries','2025-10-15',1),
('EXP208','F0001','USR004','C0002',70.00,'Fuel','2025-10-15',1),
('EXP209','F0001','USR001','C0003',110.00,'Internet','2025-10-15',1),
('EXP210','F0001','USR002','C0004',40.00,'Movies','2025-10-15',1);

-- September 2025
INSERT INTO Expenses (expenseId, familyId, userId, categoryId, amount, description, expenseDate, isActive)
VALUES
('EXP211','F0001','USR001','C0001',140.00,'Groceries','2025-09-15',1),
('EXP212','F0001','USR002','C0002',65.00,'Transport','2025-09-15',1),
('EXP213','F0001','USR003','C0003',310.00,'Utilities','2025-09-15',1),
('EXP214','F0001','USR004','C0004',55.00,'Entertainment','2025-09-15',1),
('EXP215','F0001','USR001','C0005',210.00,'Healthcare','2025-09-15',1),
('EXP216','F0001','USR002','C0006',190.00,'Shopping','2025-09-15',1),
('EXP217','F0001','USR003','C0001',130.00,'Groceries','2025-09-15',1),
('EXP218','F0001','USR004','C0002',75.00,'Fuel','2025-09-15',1),
('EXP219','F0001','USR001','C0003',120.00,'Internet','2025-09-15',1),
('EXP220','F0001','USR002','C0004',45.00,'Movies','2025-09-15',1);

-- August 2025
INSERT INTO Expenses (expenseId, familyId, userId, categoryId, amount, description, expenseDate, isActive)
VALUES
('EXP221','F0001','USR001','C0001',135.00,'Groceries','2025-08-15',1),
('EXP222','F0001','USR002','C0002',60.00,'Transport','2025-08-15',1),
('EXP223','F0001','USR003','C0003',305.00,'Utilities','2025-08-15',1),
('EXP224','F0001','USR004','C0004',50.00,'Entertainment','2025-08-15',1),
('EXP225','F0001','USR001','C0005',205.00,'Healthcare','2025-08-15',1),
('EXP226','F0001','USR002','C0006',175.00,'Shopping','2025-08-15',1),
('EXP227','F0001','USR003','C0001',125.00,'Groceries','2025-08-15',1),
('EXP228','F0001','USR004','C0002',65.00,'Fuel','2025-08-15',1),
('EXP229','F0001','USR001','C0003',115.00,'Internet','2025-08-15',1),
('EXP230','F0001','USR002','C0004',45.00,'Movies','2025-08-15',1);

-- ==================================
-- BUDGETS AND BUDGET CATEGORIES
-- ==================================

-- October 2025
INSERT INTO Budgets (budgetId, familyId, budgetName, month, year, totalAmount, createdBy, createdDate, lastModifiedDate, isActive)
VALUES
('BUD201','F0001','October Budget',10,2025,2500.00,'USR001',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

INSERT INTO BudgetCategories (budgetId, categoryId, allocatedAmount, createdDate, lastModifiedDate, isActive)
VALUES
('BUD201','C0001',600.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD201','C0002',400.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD201','C0003',500.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD201','C0004',300.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD201','C0005',300.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD201','C0006',400.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

-- September 2025
INSERT INTO Budgets (budgetId, familyId, budgetName, month, year, totalAmount, createdBy, createdDate, lastModifiedDate, isActive)
VALUES
('BUD202','F0001','September Budget',9,2025,2550.00,'USR001',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

INSERT INTO BudgetCategories (budgetId, categoryId, allocatedAmount, createdDate, lastModifiedDate, isActive)
VALUES
('BUD202','C0001',610.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD202','C0002',410.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD202','C0003',510.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD202','C0004',310.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD202','C0005',310.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD202','C0006',400.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

-- August 2025
INSERT INTO Budgets (budgetId, familyId, budgetName, month, year, totalAmount, createdBy, createdDate, lastModifiedDate, isActive)
VALUES
('BUD203','F0001','August Budget',8,2025,2600.00,'USR001',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

INSERT INTO BudgetCategories (budgetId, categoryId, allocatedAmount, createdDate, lastModifiedDate, isActive)
VALUES
('BUD203','C0001',620.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD203','C0002',420.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD203','C0003',520.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD203','C0004',310.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD203','C0005',310.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
('BUD203','C0006',420.00,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);
