
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="java.util.*" %>
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
%>
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">Famney</a>
            <nav class="nav-menu">
                <a href="main.jsp">Dashboard</a>
                <a href="expense_form.jsp">Add Expense</a>
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
            <div class="expense-details">
                <p><strong>Category:</strong> ${category}</p>
                <p><strong>Amount:</strong> ${amount}</p>
                <p><strong>Date:</strong> ${date}</p>
                <p><strong>Description:</strong> ${description}</p>
                <p><strong>Budget for this category:</strong> $<%= request.getAttribute("categoryBudget") != null ? request.getAttribute("categoryBudget") : "N/A" %></p>            </div>
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