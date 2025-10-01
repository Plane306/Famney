
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*"%>
<%@ page import="model.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head>
    <title>Submitted Expense - Famney</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .header {
            background: #2c3e50;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }
        .logo {
            font-size: 2rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }
        .nav-menu {
            display: flex;
            gap: 2rem;
        }
        .nav-menu a, .nav-menu span {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .nav-menu a:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
        }
        .nav-menu span {
            font-weight: 600;
            opacity: 0.9;
        }
        .main-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }
        .content-box {
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            max-width: 500px;
            width: 100%;
        }
        .content-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .content-header h1 {
            color: #2c3e50;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .content-header p {
            color: #7f8c8d;
            font-size: 1rem;
        }
        .expense-details {
            margin-top: 2rem;
        }
        .expense-details p {
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }
        .btn-primary {
            width: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 1rem;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        .footer {
            background: #2c3e50;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        @media (max-width: 768px) {
            .content-box {
                margin: 1rem;
                padding: 2rem;
            }
            .nav-menu {
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    Family family = (Family) session.getAttribute("family");
    if (user == null || family == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // --- Begin: Copy categories logic from categories.jsp ---
    List<Category> categories = new ArrayList<>();
    Category cat1 = new Category(family.getFamilyId(), "Food & Dining", "Expense", true, "Groceries, restaurants, takeaways");
    cat1.setCategoryId("CAT001");
    categories.add(cat1);
    Category cat2 = new Category(family.getFamilyId(), "Transportation", "Expense", true, "Petrol, public transport, car maintenance");
    cat2.setCategoryId("CAT002");
    categories.add(cat2);
    Category cat3 = new Category(family.getFamilyId(), "Utilities", "Expense", true, "Electricity, water, gas, internet");
    cat3.setCategoryId("CAT003");
    categories.add(cat3);
    Category cat4 = new Category(family.getFamilyId(), "Entertainment", "Expense", true, "Movies, games, hobbies");
    cat4.setCategoryId("CAT004");
    categories.add(cat4);
    Category cat5 = new Category(family.getFamilyId(), "Healthcare", "Expense", true, "Medical expenses, insurance");
    cat5.setCategoryId("CAT005");
    categories.add(cat5);
    Category cat6 = new Category(family.getFamilyId(), "Shopping", "Expense", true, "Clothes, electronics, household items");
    cat6.setCategoryId("CAT006");
    categories.add(cat6);
    Category cat7 = new Category(family.getFamilyId(), "Salary", "Income", true, "Monthly salary from employment");
    cat7.setCategoryId("CAT007");
    categories.add(cat7);
    Category cat8 = new Category(family.getFamilyId(), "Freelance", "Income", true, "Freelance work and contracts");
    cat8.setCategoryId("CAT008");
    categories.add(cat8);
    Category cat9 = new Category(family.getFamilyId(), "Allowance", "Income", true, "Pocket money and allowances");
    cat9.setCategoryId("CAT009");
    categories.add(cat9);
    Category cat10 = new Category(family.getFamilyId(), "Investment", "Income", true, "Dividends, interest, capital gains");
    cat10.setCategoryId("CAT010");
    categories.add(cat10);
    Category cat11 = new Category(family.getFamilyId(), "Education", "Expense", false, "School fees, books, courses");
    cat11.setCategoryId("CAT011");
    categories.add(cat11);
    Category cat12 = new Category(family.getFamilyId(), "Pet Care", "Expense", false, "Pet food, vet bills, grooming");
    cat12.setCategoryId("CAT012");
    categories.add(cat12);
    // --- End: Copy categories logic from categories.jsp ---
%>
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">Famney</a>
            <nav class="nav-menu">
                <a href="main.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
            </nav>
        </div>
    </header>
    <div class="main-container">
        <div class="content-box">
            <div class="content-header">
                <h1>Expense Details</h1>
                <p>See the details of your submitted expense</p>
            </div>
            <%
                List<model.Expense> allExpenses = (List<model.Expense>) session.getAttribute("allExpenses");
                if (allExpenses != null && !allExpenses.isEmpty()) {
                    for (model.Expense exp : allExpenses) {
            %>
            <div class="expense-details">
                <p><strong>User:</strong> <%= exp.getUserId() %></p>
                <%
                    String catName = exp.getCategoryId();
                    for (Category cat : categories) {
                        if (cat.getCategoryId().equals(exp.getCategoryId())) {
                            catName = cat.getCategoryName();
                            break;
                        }
                    }
                %>
                <p><strong>Category:</strong> <%= catName %></p>
                <p><strong>Amount:</strong> <%= exp.getAmount() %></p>
                <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(exp.getExpenseDate()) %></p>
                <p><strong>Description:</strong> <%= exp.getDescription() %></p>
            </div>
            <hr/>
            <%
                    }
                } else {
            %>
            <p>No expenses recorded yet.</p>
            <%
                }
            %>
            <a href="expense_form.jsp" class="btn-primary">Add another expense</a>
        </div>
    </div>
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Famney - Family Financial Management System</p>
        </div>
    </footer>
</body>
</html>