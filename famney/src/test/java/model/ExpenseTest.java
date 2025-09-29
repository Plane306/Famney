package model;

import org.junit.Test;
import static org.junit.Assert.*;

import java.util.Date;

public class ExpenseTest {
    @Test
    public void testExpenseCreation() {
        Date expenseDate = new Date();
        Expense expense = new Expense("fam1", "user1", "cat1", 50.0, "Groceries", expenseDate);
        assertEquals("fam1", expense.getFamilyId());
        assertEquals("user1", expense.getUserId());
        assertEquals("cat1", expense.getCategoryId());
        assertEquals(50.0, expense.getAmount(), 0.001);
        assertEquals("Groceries", expense.getDescription());
        assertEquals(expenseDate, expense.getExpenseDate());
        assertTrue(expense.isActive());
        assertNotNull(expense.getCreatedDate());
    }

    @Test
    public void testSettersAndGetters() {
        Expense expense = new Expense();
        expense.setFamilyId("fam2");
        expense.setUserId("user2");
        expense.setCategoryId("cat2");
        expense.setAmount(75.5);
        expense.setDescription("Utilities");
        Date date = new Date();
        expense.setExpenseDate(date);
        expense.setActive(false);
        expense.setReceiptUrl("http://receipt.com/1");
        assertEquals("fam2", expense.getFamilyId());
        assertEquals("user2", expense.getUserId());
        assertEquals("cat2", expense.getCategoryId());
        assertEquals(75.5, expense.getAmount(), 0.001);
        assertEquals("Utilities", expense.getDescription());
        assertEquals(date, expense.getExpenseDate());
        assertFalse(expense.isActive());
        assertEquals("http://receipt.com/1", expense.getReceiptUrl());
    }

    @Test
    public void testIsValid() {
        Expense expense = new Expense("fam3", "user3", "cat3", 100.0, "Test Expense");
        assertTrue(expense.isValid());
        expense.setAmount(0.0);
        assertFalse(expense.isValid());
    }
}
