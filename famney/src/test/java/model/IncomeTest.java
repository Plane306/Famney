package model;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class IncomeTest {

    @Test
    public void testIncomeCreation() {
        Date incomeDate = new Date();
        Income income = new Income("fam1", "user1", "cat1", 50.0, "Groceries", incomeDate);
        assertEquals("fam1", income.getFamilyId());
        assertEquals("user1", income.getUserId());
        assertEquals("cat1", income.getCategoryId());
        assertEquals(50.0, income.getAmount(), 0.001);
        assertEquals("Groceries", income.getDescription());
        assertEquals(incomeDate, income.getIncomeDate());
        assertTrue(income.isActive());
        assertNotNull(income.getCreatedDate());
    }

    @Test
    public void testSettersAndGetters() {
        Income income = new Income();
        income.setFamilyId("fam2");
        income.setUserId("user2");
        income.setCategoryId("cat2");
        income.setAmount(75.5);
        income.setDescription("Utilities");
        Date date = new Date();
        income.setIncomeDate(date);
        income.setActive(false);
        income.setReceiptUrl("http://receipt.com/1");
        assertEquals("fam2", income.getFamilyId());
        assertEquals("user2", income.getUserId());
        assertEquals("cat2", income.getCategoryId());
        assertEquals(75.5, income.getAmount(), 0.001);
        assertEquals("Utilities", income.getDescription());
        assertEquals(date, income.getIncomeDate());
        assertFalse(income.isActive());
        assertEquals("http://receipt.com/1", income.getReceiptUrl());
    }

    @Test
    public void testIsValid() {
        Income income = new Income("fam3", "user3", "cat3", 100.0, "Test Income");
        assertTrue(income.isValid());
        income.setAmount(0.0);
        assertFalse(income.isValid());
    }

    @Test
    public void testNegativeIncome() {
        Income income = new Income(null, "", null, -10.0, "", null);
        assertFalse(income.isValid());
        income.setAmount(Double.MAX_VALUE);
        assertTrue(income.getAmount() > 0);
    }
}
