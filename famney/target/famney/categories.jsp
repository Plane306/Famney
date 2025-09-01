<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="model.Category"%>
<%@ page import="java.util.*"%>

<html>
    <head>
        <title>Manage Categories - Famney</title>
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
            
            /* Main Container */
            .main-container {
                flex: 1;
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
                width: 100%;
            }
            
            .management-card {
                background: white;
                padding: 3rem;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                margin-bottom: 2rem;
            }
            
            .page-header {
                text-align: center;
                margin-bottom: 2rem;
            }
            
            .page-header h1 {
                color: #2c3e50;
                font-size: 2.5rem;
                margin-bottom: 0.5rem;
            }
            
            .page-header p {
                color: #7f8c8d;
                font-size: 1.1rem;
            }
            
            .btn-add {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 0.8rem 1.5rem;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
            }
            
            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            }
            
            .category-stats {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 1rem;
                margin-bottom: 2rem;
            }
            
            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 1.5rem;
                border-radius: 10px;
                text-align: center;
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }
            
            .stat-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }
            
            .category-filters {
                display: flex;
                gap: 1rem;
                margin-bottom: 2rem;
            }
            
            .filter-btn {
                padding: 0.5rem 1rem;
                border: 2px solid #667eea;
                background: transparent;
                color: #667eea;
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 600;
            }
            
            .filter-btn.active, .filter-btn:hover {
                background: #667eea;
                color: white;
            }
            
            .categories-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            }
            
            .categories-table thead {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .categories-table th,
            .categories-table td {
                padding: 1.2rem;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
            }
            
            .categories-table th {
                font-weight: 600;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .categories-table tbody tr:hover {
                background: #f8f9fa;
                transition: background 0.3s ease;
            }
            
            .category-name {
                font-weight: 600;
                color: #2c3e50;
            }
            
            .category-type-badge {
                display: inline-block;
                padding: 0.3rem 0.8rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .expense-badge {
                background: #f8d7da;
                color: #721c24;
            }
            
            .income-badge {
                background: #d4edda;
                color: #155724;
            }
            
            .default-badge {
                background: #d1ecf1;
                color: #0c5460;
                font-size: 0.65rem;
                padding: 0.2rem 0.5rem;
                margin-left: 0.5rem;
                border-radius: 15px;
                display: inline-block;
                vertical-align: middle;
                font-weight: 500;
                text-transform: uppercase;
            }
            
            .action-buttons {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }
            
            .btn-small {
                padding: 0.4rem 0.8rem;
                border: none;
                border-radius: 8px;
                font-size: 0.8rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }
            
            .btn-edit {
                background: #ffc107;
                color: #212529;
            }
            
            .btn-edit:hover {
                background: #ffb300;
                transform: translateY(-1px);
            }
            
            .btn-delete {
                background: #dc3545;
                color: white;
            }
            
            .btn-delete:hover {
                background: #c82333;
                transform: translateY(-1px);
            }
            
            .btn-delete:disabled {
                background: #6c757d;
                cursor: not-allowed;
                transform: none;
            }
            
            .btn-back {
                display: inline-block;
                text-align: center;
                background: transparent;
                color: #667eea;
                padding: 1rem 2rem;
                border: 2px solid #667eea;
                border-radius: 10px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                margin-top: 2rem;
            }
            
            .btn-back:hover {
                background: #667eea;
                color: white;
            }
            
            .empty-state {
                text-align: center;
                padding: 3rem;
                color: #7f8c8d;
            }
            
            .empty-state h3 {
                font-size: 1.5rem;
                margin-bottom: 1rem;
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
                .main-container {
                    padding: 1rem;
                }
                
                .category-management {
                    padding: 2rem;
                }
                
                .action-bar {
                    flex-direction: column;
                    gap: 1rem;
                }
                
                .categories-table {
                    font-size: 0.9rem;
                }
                
                .categories-table th,
                .categories-table td {
                    padding: 0.5rem;
                }
            }
        </style>
    </head>
    
    <body>
        <%
            // Check authentication
            User user = (User) session.getAttribute("user");
            Family family = (Family) session.getAttribute("family");
            
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // R0 Prototype: Create sample categories data
            List<Category> categories = new ArrayList<>();
            
            // Default expense categories
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
            
            // Default income categories  
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
            
            // Custom categories (non-default examples)
            Category cat11 = new Category(family.getFamilyId(), "Education", "Expense", false, "School fees, books, courses");
            cat11.setCategoryId("CAT011");
            categories.add(cat11);
            
            Category cat12 = new Category(family.getFamilyId(), "Pet Care", "Expense", false, "Pet food, vet bills, grooming");
            cat12.setCategoryId("CAT012");
            categories.add(cat12);
            
            // Filter categories 
            String filterType = request.getParameter("type");
            List<Category> filteredCategories = categories;
            
            if ("expense".equals(filterType)) {
                filteredCategories = new ArrayList<>();
                for (Category cat : categories) {
                    if ("Expense".equals(cat.getCategoryType())) {
                        filteredCategories.add(cat);
                    }
                }
            } else if ("income".equals(filterType)) {
                filteredCategories = new ArrayList<>();
                for (Category cat : categories) {
                    if ("Income".equals(cat.getCategoryType())) {
                        filteredCategories.add(cat);
                    }
                }
            }
            
            // Calculate statistics
            int expenseCount = 0;
            int incomeCount = 0;
            int customCount = 0;
            
            for (Category cat : categories) {
                if ("Expense".equals(cat.getCategoryType())) {
                    expenseCount++;
                } else {
                    incomeCount++;
                }
                if (!cat.isDefault()) {
                    customCount++;
                }
            }
        %>
        
        <header class="header">
            <div class="nav-container">
                <a href="main.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <span>Family: <%= family.getFamilyName() %></span>
                    <span><%= user.getFullName() %> (<%= user.getRole() %>)</span>
                    <a href="main.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="management-card">
                <div class="page-header">
                    <h1>&#128295; Category Management</h1>
                    <p>Organize your family's expenses and income with custom categories</p>
                </div>
                
                <div class="category-stats">
                    <div class="stat-card">
                        <div class="stat-number"><%= categories.size() %></div>
                        <div class="stat-label">Total Categories</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= expenseCount %></div>
                        <div class="stat-label">Expense Types</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= incomeCount %></div>
                        <div class="stat-label">Income Types</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= customCount %></div>
                        <div class="stat-label">Custom Categories</div>
                    </div>
                </div>
                
                <% if ("Family Head".equals(user.getRole())) { %>
                    <div style="text-align: center; margin-bottom: 2rem;">
                        <a href="category_form.jsp" class="btn-add">&#10133; Add New Category</a>
                    </div>
                <% } %>
                
                <div class="category-filters">
                    <button class="filter-btn <%= (filterType == null || "all".equals(filterType)) ? "active" : "" %>" 
                            onclick="location.href='categories.jsp?type=all'">All Categories</button>
                    <button class="filter-btn <%= "expense".equals(filterType) ? "active" : "" %>" 
                            onclick="location.href='categories.jsp?type=expense'">&#128179; Expenses</button>
                    <button class="filter-btn <%= "income".equals(filterType) ? "active" : "" %>" 
                            onclick="location.href='categories.jsp?type=income'">&#128176; Income</button>
                </div>
                
                <% if (filteredCategories.isEmpty()) { %>
                    <div class="empty-state">
                        <h3>No categories found</h3>
                        <p>Start by creating your first custom category to organize your family finances.</p>
                        <% if ("Family Head".equals(user.getRole())) { %>
                            <a href="category_form.jsp" class="btn-add" style="margin-top: 1rem;">Create First Category</a>
                        <% } %>
                    </div>
                <% } else { %>
                    <table class="categories-table">
                        <thead>
                            <tr>
                                <th>Category</th>
                                <th>Type</th>
                                <th>Description</th>
                                <th>Status</th>
                                <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                                    <th>Actions</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Category category : filteredCategories) { %>
                                <tr>
                                    <td>
                                        <span class="category-name">
                                            <%= category.getCategoryName() %>
                                            <% if (category.isDefault()) { %>
                                                <span class="default-badge">DEFAULT</span>
                                            <% } %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="category-type-badge <%= "Expense".equals(category.getCategoryType()) ? "expense-badge" : "income-badge" %>">
                                            <%= category.getCategoryType() %>
                                        </span>
                                    </td>
                                    <td>
                                        <%= category.getDescription() != null ? category.getDescription() : "No description" %>
                                    </td>
                                    <td>
                                        Active
                                    </td>
                                    <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="category_form.jsp?action=edit&id=<%= category.getCategoryId() %>" class="btn-small btn-edit">
                                                    Edit
                                                </a>
                                                <% if ("Family Head".equals(user.getRole())) { %>
                                                    <% if (!category.isDefault()) { %>
                                                        <button class="btn-small btn-delete" onclick="confirmDelete('<%= category.getCategoryName() %>')">
                                                            Delete
                                                        </button>
                                                    <% } else { %>
                                                        <button class="btn-small btn-delete" disabled title="Cannot delete default categories">
                                                            Delete
                                                        </button>
                                                    <% } %>
                                                <% } %>
                                            </div>
                                        </td>
                                    <% } %>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
                
                <div style="text-align: center;">
                    <a href="main.jsp" class="btn-back">&#127968; Back to Dashboard</a>
                </div>
            </div>
        </div>
        
        <footer class="footer">
            <div class="container">
                <p>&copy; 2025 Famney - Family Financial Management System</p>
            </div>
        </footer>
        
        <script>
            function confirmDelete(categoryName) {
                if (confirm('Are you sure you want to delete "' + categoryName + '"?')) {
                    alert('Category "' + categoryName + '" would be deleted in full implementation.');
                }
            }
        </script>
    </body>
</html>