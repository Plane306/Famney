<%@ page import="model.Budget" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.*" %>
<%
    Budget budget = (Budget) request.getAttribute("editBudget");
    String categoryId = (String) request.getAttribute("editCategoryId");
    int index = (request.getAttribute("editIndex") != null) ? (Integer) request.getAttribute("editIndex") : -1;
    // Prepopulated categories (same as view_budget.jsp)
    List<Category> categories = new ArrayList<>();
    Category cat1 = new Category(budget.getFamilyId(), "Food & Dining", "Expense", true, "Groceries, restaurants, takeaways");
    cat1.setCategoryId("CAT001");
    categories.add(cat1);
    Category cat2 = new Category(budget.getFamilyId(), "Transportation", "Expense", true, "Petrol, public transport, car maintenance");
    cat2.setCategoryId("CAT002");
    categories.add(cat2);
    Category cat3 = new Category(budget.getFamilyId(), "Utilities", "Expense", true, "Electricity, water, gas, internet");
    cat3.setCategoryId("CAT003");
    categories.add(cat3);
    Category cat4 = new Category(budget.getFamilyId(), "Entertainment", "Expense", true, "Movies, games, hobbies");
    cat4.setCategoryId("CAT004");
    categories.add(cat4);
    Category cat5 = new Category(budget.getFamilyId(), "Healthcare", "Expense", true, "Medical expenses, insurance");
    cat5.setCategoryId("CAT005");
    categories.add(cat5);
    Category cat6 = new Category(budget.getFamilyId(), "Shopping", "Expense", true, "Clothes, electronics, household items");
    cat6.setCategoryId("CAT006");
    categories.add(cat6);
    Category cat7 = new Category(budget.getFamilyId(), "Salary", "Income", true, "Monthly salary from employment");
    cat7.setCategoryId("CAT007");
    categories.add(cat7);
    Category cat8 = new Category(budget.getFamilyId(), "Freelance", "Income", true, "Freelance work and contracts");
    cat8.setCategoryId("CAT008");
    categories.add(cat8);
    Category cat9 = new Category(budget.getFamilyId(), "Allowance", "Income", true, "Pocket money and allowances");
    cat9.setCategoryId("CAT009");
    categories.add(cat9);
    Category cat10 = new Category(budget.getFamilyId(), "Investment", "Income", true, "Dividends, interest, capital gains");
    cat10.setCategoryId("CAT010");
    categories.add(cat10);
    Category cat11 = new Category(budget.getFamilyId(), "Education", "Expense", false, "School fees, books, courses");
    cat11.setCategoryId("CAT011");
    categories.add(cat11);
    Category cat12 = new Category(budget.getFamilyId(), "Pet Care", "Expense", false, "Pet food, vet bills, grooming");
    cat12.setCategoryId("CAT012");
    categories.add(cat12);
%>
<html>
<head>
    <title>Edit Budget</title>
    <style>
        body { background: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .edit-form { max-width: 500px; margin: 40px auto; background: white; padding: 2rem; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; color: #7f8c8d; }
        input, select { width: 100%; padding: 0.7rem; margin-bottom: 1.2rem; border-radius: 8px; border: 1px solid #e9ecef; }
        .btn-primary { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 1rem 2rem; border-radius: 10px; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; }
        .btn-primary:hover { background: #764ba2; }
    </style>
</head>
<body>
    <form class="edit-form" action="EditBudgetServlet" method="post">
        <h2>Edit Budget</h2>
        <input type="hidden" name="index" value="<%= index %>" />
        <label for="name">Budget Name</label>
        <input type="text" id="name" name="name" value="<%= budget.getBudgetName() %>" required />
        <label for="month">Month</label>
        <input type="number" id="month" name="month" min="1" max="12" value="<%= budget.getMonth() %>" required />
        <label for="budget">Total Amount</label>
        <input type="number" id="budget" name="budget" min="0" step="0.01" value="<%= budget.getTotalAmount() %>" required />
        <label for="category">Category</label>
        <select id="category" name="category" required>
            <% for (Category cat : categories) { %>
                <option value="<%= cat.getCategoryId() %>" <%= cat.getCategoryId().equals(categoryId) ? "selected" : "" %>><%= cat.getCategoryName() %></option>
            <% } %>
        </select>
        <button type="submit" class="btn-primary">Update Budget</button>
    </form>
</body>
</html>
