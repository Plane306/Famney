<%@ page import="model.User" %>
<%@ page import="model.Family" %>
<%@ page import="model.Category" %>
<%@ page import="model.Income" %>
<%@ page import="model.dao.IncomeManager" %>
<%@ page import="model.dao.CategoryManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head>
    <title>Record Income - Famney</title>
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

        /* Main Container */
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
            color: #555;
            font-size: 0.95rem;
            margin-top: 0.3rem;
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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #ecf0f1;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }

        .form-group input:focus,
        .form-group select:focus {
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

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            border: 1px solid #c3e6cb;
            text-align: center;
            font-weight: 600;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            border: 1px solid #f5c6cb;
            text-align: center;
        }

        /* Footer */
        .footer {
            background: #2c3e50;
            color: white;
            padding: 2rem;
            text-align: center;
        }

        /* Responsive */
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

    <script>
        function toggleRecurringOptions() {
            const checked = document.querySelector('input[name="isRecurring"]:checked');
            const recurringSection = document.getElementById("recurringOptions");
            const frequencySelect = document.getElementById("frequency");
            if (checked && checked.value === "yes") {
                recurringSection.style.display = "block";
                frequencySelect.setAttribute("required", "required");
            } else {
                recurringSection.style.display = "none";
                frequencySelect.removeAttribute("required");
                frequencySelect.value = "";
            }
        }
    </script>
</head>

<body>
<%
    // Session check
    User user = (User) session.getAttribute("user");
    Family family = (Family) session.getAttribute("family");
    if (user == null || family == null) { response.sendRedirect("login.jsp"); return; }

    Income income = null;
    String incomeId = request.getParameter("incomeId");
    IncomeManager incomeManager = (IncomeManager) session.getAttribute("incomeManager");
    if (incomeId != null && incomeManager != null) {
        income = incomeManager.getIncomeById(incomeId);
    }

    List<Category> categories = new ArrayList<>();
    CategoryManager cm = (CategoryManager) session.getAttribute("categoryManager");
    if (cm != null) {
        try { categories = cm.getCategoriesByType(family.getFamilyId(), "Income"); }
        catch (SQLException e) { categories = (List<Category>) session.getAttribute("categories"); if (categories == null) categories = new ArrayList<>(); }
    }

    String todayStr = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>

<header class="header">
    <div class="nav-container">
        <a href="index.jsp" class="logo">Famney</a>
        <nav class="nav-menu">
            <span>Welcome, <%= user.getFullName() %></span>
            <a href="main.jsp">Dashboard</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </div>
</header>

<div class="main-container">
    <div class="content-box">
        <div class="content-header">
            <h1><%= (income != null ? "Edit Income" : "Record New Income") %></h1>
            <p>Fields marked with <span style="color:red;">*</span> are required.</p>
        </div>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success-message"><%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form action="IncomeServlet" method="post" class="income-form">
            <% if (income != null) { %>
                <input type="hidden" name="incomeId" value="<%= income.getIncomeId() %>">
                <input type="hidden" name="action" value="update">
            <% } else { %>
                <input type="hidden" name="action" value="create">
            <% } %>

            <div class="form-group">
                <label>User</label>
                <span><%= user.getFullName() %></span>
            </div>

            <div class="form-group">
                <label for="amount">Amount<span style="color:red;">*</span></label>
                <input type="number" id="amount" name="amount" step="0.01" min="0.01" value="<%= (income != null ? income.getAmount() : "") %>" required />
            </div>

            <div class="form-group">
                <label for="description">(Optional) Description</label>
                <input type="text" id="description" name="description" placeholder="e.g. Work" value="<%= (income != null ? income.getDescription() : "") %>" />
            </div>

            <div class="form-group">
                <label for="source">(Optional) Source</label>
                <input type="text" id="source" name="source" placeholder="e.g. Company Name" value="<%= (income != null ? income.getSource() : "") %>" />
            </div>

            <div class="form-group">
                <label for="incomeDate">Date<span style="color:red;">*</span></label>
                <input type="date" id="incomeDate" name="incomeDate" required
                       value="<%= (income != null ? new SimpleDateFormat("yyyy-MM-dd").format(income.getIncomeDate()) : todayStr) %>"/>
            </div>

            <div class="form-group">
                <label for="category">Category<span style="color:red;">*</span></label>
                <select id="category" name="category" required>
                    <option value="">--Select Category--</option>
                    <% for (Category c : categories) { %>
                        <option value="<%= c.getCategoryId() %>" <%= (income != null && income.getCategoryId().equals(c.getCategoryId()) ? "selected" : "") %>>
                            <%= c.getCategoryName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Is this income recurring?<span style="color:red;">*</span></label>
                <label>
                    <input type="radio" name="isRecurring" value="yes" onclick="toggleRecurringOptions()"
                    <%= (income != null && income.isRecurring() ? "checked" : "") %>
                    <%= (income != null ? "disabled" : "") %> >Yes
                </label>
                <label>
                    <input type="radio" name="isRecurring" value="no" onclick="toggleRecurringOptions()"
                        <%= (income == null || !income.isRecurring() ? "checked" : "") %>
                        <%= (income != null ? "disabled" : "") %> >No
                </label>
            </div>

            <div id="recurringOptions" style="<%= (income != null && income.isRecurring() ? "display:block;" : "display:none;") %>">
                <div class="form-group">
                    <label for="frequency">Frequency:<span style="color:red;">*</span></label>
                    <select id="frequency" name="frequency" <%= (income != null ? "disabled" : "") %>>
                        <option value="">--Select Frequency--</option>
                        <option value="Daily" <%= (income != null && "Daily".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Daily</option>
                        <option value="Weekly" <%= (income != null && "Weekly".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Weekly</option>
                        <option value="Fortnightly" <%= (income != null && "Fortnightly".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Fortnightly</option>
                        <option value="Monthly" <%= (income != null && "Monthly".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Monthly</option>
                        <option value="Quarterly" <%= (income != null && "Quarterly".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Quarterly</option>
                        <option value="Yearly" <%= (income != null && "Yearly".equalsIgnoreCase(income.getFrequency()) ? "selected" : "") %>>Yearly</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-primary"><%= (income != null ? "Update Income" : "Add Income") %></button>
        </form>

        <div style="text-align:center; margin-top:2rem;">
            <form action="IncomeServlet" method="get">
                <button type="submit" class="btn-secondary">View All Incomes</button>
            </form>
        </div>

    </div>
</div>

<footer class="footer">
    <p>&copy; 2025 Famney - Family Financial Management System</p>
</footer>
</body>
</html>
