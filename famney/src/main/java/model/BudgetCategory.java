package model;

import java.io.Serializable;
import java.util.Date;

// BudgetCategory class (Represents budget allocation per category)
// Links Budget with Categories for detailed budget breakdown
class BudgetCategory implements Serializable {
    
    private String budgetCategoryId;
    private String budgetId;
    private String categoryId;
    private double allocatedAmount;
    private Date createdDate;
    private Date lastModifiedDate;
    private boolean isActive;
    
    // Constructor for creating new budget category allocation
    public BudgetCategory(String budgetId, String categoryId, double allocatedAmount) {
        this.budgetId = budgetId;
        this.categoryId = categoryId;
        this.allocatedAmount = allocatedAmount;
        this.createdDate = new Date();
        this.lastModifiedDate = new Date();
        this.isActive = true;
    }

    // Full constructor (for database retrieval)
    public BudgetCategory(String budgetCategoryId, String budgetId, String categoryId, 
                          double allocatedAmount, Date createdDate, Date lastModifiedDate, boolean isActive) {
        this.budgetCategoryId = budgetCategoryId;
        this.budgetId = budgetId;
        this.categoryId = categoryId;
        this.allocatedAmount = allocatedAmount;
        this.createdDate = createdDate;
        this.lastModifiedDate = lastModifiedDate;
        this.isActive = isActive;
    }
    
    // Default constructor
    public BudgetCategory() {
        this.createdDate = new Date();
        this.lastModifiedDate = new Date();
        this.isActive = true;
        this.allocatedAmount = 0.0;
    }
    
    // Getters and Setters
    public String getBudgetCategoryId() {
        return budgetCategoryId;
    }

    public void setBudgetCategoryId(String budgetCategoryId) {
        this.budgetCategoryId = budgetCategoryId;
        this.lastModifiedDate = new Date();
    }

    public String getBudgetId() {
        return budgetId;
    }

    public void setBudgetId(String budgetId) {
        this.budgetId = budgetId;
        this.lastModifiedDate = new Date();
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
        this.lastModifiedDate = new Date();
    }

    public double getAllocatedAmount() {
        return allocatedAmount;
    }

    public void setAllocatedAmount(double allocatedAmount) {
        this.allocatedAmount = allocatedAmount;
        this.lastModifiedDate = new Date();
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(Date lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
        this.lastModifiedDate = new Date();
    }
    
    // Business logic methods
    
    // Get formatted allocated amount
    public String getFormattedAllocatedAmount() {
        return String.format("$%.2f", allocatedAmount);
    }
    
    // Validate budget category data
    public boolean isValid() {
        return budgetId != null && !budgetId.trim().isEmpty() &&
               categoryId != null && !categoryId.trim().isEmpty() &&
               allocatedAmount >= 0; // Allow 0 allocation
    }
    
    // Check if allocation amount is positive
    public boolean hasPositiveAllocation() {
        return allocatedAmount > 0;
    }
    
    @Override
    public String toString() {
        return "BudgetCategory{" +
                "budgetCategoryId='" + budgetCategoryId + '\'' +
                ", budgetId='" + budgetId + '\'' +
                ", categoryId='" + categoryId + '\'' +
                ", allocatedAmount=" + allocatedAmount +
                ", isActive=" + isActive +
                '}';
    }
}