<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*"%>
<%@ page import="java.util.*"%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Savings Goal - Famney</title>
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
            .form-group {
                margin-bottom: 1.5rem;
            }
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #2c3e50;
                font-weight: 600;
                font-size: 0.9rem;
            }
            .form-group input, .form-group textarea {
                width: 100%;
                padding: 1rem;
                border: 2px solid #ecf0f1;
                border-radius: 10px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fafafa;
            }
            .form-group input:focus, .form-group textarea:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            }
            .btn-secondary {
                display: inline-block;
                text-align: center;
                width: 100%;
                background: transparent;
                color: #667eea;
                padding: 1rem;
                border: 2px solid #667eea;
                border-radius: 10px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .btn-secondary:hover {
                background: #667eea;
                color: white;
            }
            .footer {
                background: #2c3e50;
                color: white;
                padding: 2rem;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <%
            // --- Check authentication ---
            User user = (User) session.getAttribute("user");
            Family family = (Family) session.getAttribute("family");

            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // --- Flash messages ---
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (successMessage != null) session.removeAttribute("successMessage");
            if (errorMessage != null) session.removeAttribute("errorMessage");
        %>

        <header class="header">
            <div class="nav-container">
                <a href="main.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <span>Family: <%= family.getFamilyName() %></span>
                    <span><%= user.getFullName() %> (<%= user.getRole() %>)</span>
                    <a href="savings_goals.jsp">Goals</a>
                    <a href="main.jsp">Dashboard</a>
                    <a href="LogoutServlet">Logout</a>
                </nav>
            </div>
        </header>

        <div class="main-container">
            <div class="form-box">
                <div class="form-header">
                    <h1>🎯 Create Savings Goal</h1>
                    <p>Set a new target for your family's savings</p>
                </div>

                <% if (successMessage != null) { %>
                    <div class="success-message"><%= successMessage %></div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="error-message"><%= errorMessage %></div>
                <% } %>

                <form action="SavingsGoalServlet" method="post">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group">
                        <label for="goalName">Goal Name *</label>
                        <input type="text" id="goalName" name="goalName" required maxlength="100"
                            placeholder="e.g. Vacation Fund, Emergency Fund">
                    </div>

                    <div class="form-group">
                        <label for="description">Description (Optional)</label>
                        <textarea id="description" name="description" maxlength="200"
                                placeholder="Brief description of this goal..."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="targetAmount">Target Amount *</label>
                        <input type="number" id="targetAmount" name="targetAmount" step="0.01" min="1" required
                            placeholder="e.g. 5000.00">
                    </div>

                    <div class="form-group">
                        <label for="targetDate">Target Date (Optional)</label>
                        <input type="date" id="targetDate" name="targetDate">
                    </div>

                    <button type="submit" class="btn-primary">✔ Create Goal</button>
                    <a href="savings_goals.jsp" class="btn-secondary">↩ Cancel</a>
                </form>
            </div>
        </div>

        <footer class="footer">
            <div class="container">
                <p>&copy; 2025 Famney - Family Financial Management System</p>
            </div>
        </footer>
    </body>
</html>