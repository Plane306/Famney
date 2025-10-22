<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*"%>
<%@ page import="model.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
    <head>
        <title>All Incomes - Famney</title>
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

            /* Header */
            .header {
                background: #2c3e50;
                padding: 1rem 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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

            .nav-menu a,
            .nav-menu span {
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

            /* Main content */
            .main-container {
                flex: 1;
                display: flex;
                justify-content: center;
                padding: 2rem;
            }

            .content-box {
                background: white;
                padding: 2rem 3rem;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                width: fit-content;
                max-width: 95%;
            }

            h1,
            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 1rem;
            }

            h1 {
                font-size: 2rem;
            }

            /* Buttons */
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 0.8rem 1.2rem;
                border: none;
                border-radius: 10px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                margin: 1rem auto;
                text-align: center;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            }

            /* Table styling */
            .incomes-table {
                width: 100%;
                border-collapse: collapse;
                margin: 0 auto;
            }

            .incomes-table th,
            .incomes-table td {
                border: 1px solid #ddd;
                padding: 0.75rem;
                text-align: center;
            }

            .incomes-table th {
                background-color: #667eea;
                color: white;
            }

            .actions button {
                padding: 0.4rem 0.8rem;
                margin: 0;
                min-width: 60px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9rem;
            }

            .btn-edit {
                background: #4caf50;
                color: white;
            }

            .btn-delete {
                background: #e74c3c;
                color: white;
            }

            /* Recurrence buttons */
            .btn-toggle {
                border: none;
                border-radius: 8px;
                color: white;
                padding: 0.5rem 0.9rem;
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-toggle.enable {
                background-color: #4caf50; 
            }

            .btn-toggle.disable {
                background-color: #e74c3c; 
            }

            .btn-toggle:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .actions form {
                display: inline-block;
                margin: 0 2px;
            }

            .pagination {
                text-align: center;
                margin-top: 1rem;
            }

            .pagination a,
            .pagination span {
                display: inline-block;
                margin: 0 5px;
                padding: 5px 10px;
                text-decoration: none;
                border: 1px solid #ccc;
                border-radius: 5px;
                color: #333;
            }

            .pagination a.active,
            .pagination span {
                background: #667eea;
                color: white;
                border-color: #667eea;
            }

            /* Footer */
            .footer {
                background: #2c3e50;
                color: white;
                padding: 2rem;
                text-align: center;
            }

            @media (max-width: 768px) {
                .content-box {
                    padding: 1.5rem;
                }
                .nav-menu {
                    gap: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            User user = (User) session.getAttribute("user");
            Family family = (Family) session.getAttribute("family");
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            List<Income> allIncomes = (List<Income>) request.getAttribute("allIncomes");
            if (allIncomes == null) allIncomes = new ArrayList<>();
            int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
            int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;

            List<Income> originalRecurring = new ArrayList<>();
            for (Income inc : allIncomes) {
                if (inc.isRecurring() && !inc.getDescription().startsWith("AUTO")) {
                    originalRecurring.add(inc);
                }
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
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
                <h1>Incomes List</h1>

                <% if (!originalRecurring.isEmpty()) { %>
                    <h2>Recurring Incomes</h2>
                    <table class="incomes-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Income</th>
                                <th>Amount</th>
                                <th>Frequency</th>
                                <th>Source</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Income income : originalRecurring) { %>
                            <tr>
                                <td><%= sdf.format(income.getIncomeDate()) %></td>
                                <td><%= income.getDisplayTitle() %></td>
                                <td>$<%= String.format("%.2f", income.getAmount()) %></td>
                                <td><%= income.getFrequency() %></td>
                                <td><%= income.getSourceDisplay() %></td>
                                <td class="actions">
                                    <form action="ToggleRecurrenceServlet" method="post">
                                        <input type="hidden" name="incomeId" value="<%= income.getIncomeId() %>">
                                        <% if (income.isRecurrenceActive()) { %>
                                            <input type="hidden" name="action" value="disable">
                                            <button type="submit" class="btn-toggle disable">Disable Recurrence</button>
                                        <% } else { %>
                                            <input type="hidden" name="action" value="enable">
                                            <button type="submit" class="btn-toggle enable">Enable Recurrence</button>
                                        <% } %>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <br>
                <% } %>

                <h2>All Income Records</h2>
                <table class="incomes-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Income</th>
                            <th>Amount</th>
                            <th>Income Type</th>
                            <th>Frequency</th>
                            <th>Source</th>
                            <th>Days Old</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (!allIncomes.isEmpty()) {
                            for (Income income : allIncomes) {
                    %>
                        <tr>
                            <td><%= sdf.format(income.getIncomeDate()) %></td>
                            <td><%= income.getDisplayTitle() %></td>
                            <td>$<%= String.format("%.2f", income.getAmount()) %></td>
                            <td><%= income.getRecurringStatusDisplay() %></td>
                            <td><%= income.isRecurring() ? income.getFrequency() : "-" %></td>
                            <td><%= income.getSourceDisplay() %></td>
                            <td><%= income.getIncomeAgeInDays() %></td>
                            <td class="actions">
                                <form action="income_form.jsp" method="get">
                                    <input type="hidden" name="incomeId" value="<%= income.getIncomeId() %>">
                                    <button type="submit" class="btn-edit">Edit</button>
                                </form>
                                <form action="IncomeServlet" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="incomeId" value="<%= income.getIncomeId() %>">
                                    <button type="submit" class="btn-delete" onclick="return confirm('Are you sure?');">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr>
                            <td colspan="8" style="text-align:center;">No incomes recorded yet.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>

                <a href="income_form.jsp" class="btn-primary">Add New Income</a>

                <div class="pagination">
                <%
                    if (totalPages > 1) {
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == currentPage) { %>
                                <span><%= i %></span>
                    <%      } else { %>
                                <a href="IncomeServlet?page=<%= i %>"><%= i %></a>
                    <%      }
                        }
                    }
                %>
                </div>
            </div>
        </div>

        <footer class="footer">
            &copy; 2025 Famney - Family Financial Management System
        </footer>
    </body>
</html>
