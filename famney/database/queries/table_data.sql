INSERT INTO SavingsGoals (
        goalId,
        familyId,
        goalName,
        description,
        targetAmount,
        currentAmount,
        targetDate,
        createdDate,
        lastModifiedDate,
        isActive,
        isCompleted,
        createdBy
    )
VALUES (
        'G1',
        'F1',
        'Vacation Fund',
        'Save for family trip',
        5000,
        1000,
        '2025-12-31',
        DATE('now'),
        DATE('now'),
        1,
        0,
        'admin'
    ),
    (
        'G2',
        'F1',
        'Emergency Fund',
        'Backup savings',
        10000,
        2500,
        '2026-06-30',
        DATE('now'),
        DATE('now'),
        1,
        0,
        'admin'
    );