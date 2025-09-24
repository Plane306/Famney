<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Submitted Expense</title>
</head>
<body>
    <h2>Expense Details</h2>

    <!-- These values come from request.setAttribute(...) in the servlet -->
    <p><strong>Category:</strong> ${category}</p>
    <p><strong>Amount:</strong> ${amount}</p>
    <p><strong>Date:</strong> ${date}</p>
    <p><strong>Description:</strong> ${description}</p>

    <hr>
    <a href="expense_form.jsp">Add another expense</a>
</body>
</html>
