<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="java.util.*" %>
<html>
<head><title>Add Expense</title></head>
<body>
<h2>Record Expense</h2>

<form action="ExpenseServlet" method="post">
    Amount: <input type="number" name="amount" step="0.01" required/><br/><br/>
    Description: <input type="text" name="description"/><br/><br/>
    Date: <input type="date" name="expenseDate" required/><br/><br/>

    Category:
    <select name="categoryId" required>
        <option value="">--Select--</option>
        <option value="Food">Food</option>
        <option value="Transport">Transport</option>
        <option value="Utilities">Utilities</option>
    </select><br/><br/>

    Member:
    <select name="userId" required>
        <option value="">--Select--</option>
        <option value="Alice">Alice</option>
        <option value="Bob">Bob</option>
    </select><br/><br/>

    <input type="submit" value="Add Expense"/>
</form>

<p><a href="expenses.jsp">View All Expenses</a></p>
</body>
</html>
