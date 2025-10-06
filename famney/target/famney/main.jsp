<%@ page import="model.User"%>
<%@ page import="model.Family"%>

<html>
    <head>
        <title>Famney - Family Dashboard</title>
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
            
            .dashboard-content {
                padding: 0 1rem;
            }
            
            .user-welcome {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                text-align: center;
            }
            
            .user-welcome h2 {
                color: #2c3e50;
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }
            
            .user-welcome p {
                color: #7f8c8d;
                margin-bottom: 1.5rem;
                font-size: 1.1rem;
            }
            
            .quick-actions {
                display: flex;
                gap: 1rem;
                justify-content: center;
                flex-wrap: wrap;
                margin-top: 1rem;
            }
            
            .btn {
                padding: 0.8rem 1.5rem;
                border: none;
                border-radius: 10px;
                font-size: 0.95rem;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                text-align: center;
                transition: all 0.3s ease;
                cursor: pointer;
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-2px);
            }
            
            .btn-admin {
                background: #ffc107;
                color: #212529;
            }
            
            .btn-admin:hover {
                background: #ffb300;
                transform: translateY(-2px);
            }
            
            /* Dashboard Stats */
            .dashboard-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }
            
            .stat-card {
                background: white;
                padding: 1.5rem;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                text-align: center;
                border-left: 5px solid #667eea;
            }
            
            .stat-card h3 {
                color: #7f8c8d;
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
                text-transform: uppercase;
            }
            
            .stat-card p {
                color: #2c3e50;
                font-size: 2rem;
                font-weight: bold;
            }
            
            /* Feature Navigation */
            .feature-navigation {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }
            
            .feature-navigation h2 {
                color: #2c3e50;
                margin-bottom: 1.5rem;
                text-align: center;
                font-size: 1.8rem;
            }
            
            .feature-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
            }
            
            .feature-link {
                display: block;
                padding: 1.5rem;
                background: #f8f9fa;
                border-radius: 15px;
                text-decoration: none;
                color: #2c3e50;
                border: 2px solid transparent;
                transition: all 0.3s ease;
                border-left: 5px solid #667eea;
            }
            
            .feature-link:hover {
                background: white;
                border-color: #667eea;
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            
            .feature-link h4 {
                font-size: 1.2rem;
                margin-bottom: 0.5rem;
                color: #2c3e50;
            }
            
            .feature-link span {
                color: #6c757d;
                font-size: 0.9rem;
            }
            
            .section-header {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 1rem;
                border-radius: 10px;
                margin: 1.5rem 0;
                text-align: center;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.9rem;
                letter-spacing: 1px;
            }
            
            .admin-only {
                border-left-color: #ffc107;
            }
            
            .admin-only:hover {
                border-color: #ffc107;
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
                .dashboard-content {
                    padding: 0;
                }
                
                .dashboard-stats {
                    grid-template-columns: 1fr 1fr;
                }
                
                .feature-grid {
                    grid-template-columns: 1fr;
                }
                
                .quick-actions {
                    flex-direction: column;
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
                    <span>Welcome, <%= user.getFullName() %></span>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="dashboard-content">
                <div class="user-welcome">
                    <h2>Welcome <%= user.getFullName() %>!</h2>
                    <p>You are logged in as <strong><%= user.getRole() %></strong> of <%= family.getFamilyName() %> Family.</p>
                    <% if ("Family Head".equals(user.getRole())) { %>
                        <p><strong>Family Code:</strong> <%= family.getFamilyCode() %> (Share this with family members)</p>
                    <% } %>
                    

                </div>
                
                <!-- Quick Stats -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <h3>Family Members</h3>
                        <p>4</p>
                    </div>
                    <div class="stat-card">
                        <h3>This Month</h3>
                        <p>$1,250</p>
                    </div>
                    <div class="stat-card">
                        <h3>Budget Used</h3>
                        <p>68%</p>
                    </div>
                    <div class="stat-card">
                        <h3>Savings Goal</h3>
                        <p>$2,500</p>
                    </div>
                </div>
                
                <!-- Feature Navigation -->
                <div class="feature-navigation">
                    <h2>Family Financial Management</h2>
                    
                    <div class="feature-grid">
                        <!-- F101 User & Family Management -->
                        <a href="edit_profile.jsp" class="feature-link">
                            <h4>&#128100; Edit My Profile</h4>
                            <span>Update your personal information and password</span>
                        </a>
                        
                        <% if ("Family Head".equals(user.getRole())) { %>
                            <a href="family_management.jsp" class="feature-link admin-only">
                                <h4>&#128106; Manage Family</h4>
                                <span>Manage family members, roles, and permissions</span>
                            </a>
                        <% } %>
                        
                        <!-- F102 Category Management -->
                        <% if ("Family Head".equals(user.getRole())) { %>
                            <a href="categories.jsp" class="feature-link admin-only">
                                <h4>&#128221; Manage Categories</h4>
                                <span>Create and edit expense & income categories</span>
                            </a>
                        <% } else if ("Adult".equals(user.getRole())) { %>
                            <a href="categories.jsp" class="feature-link">
                                <h4>&#128214; View Categories</h4>
                                <span>Browse available expense & income categories</span>
                            </a>
                        <% } %>
                        
                        <!-- F103 Budget Features -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="budget_form.jsp" class="feature-link">
                                <h4>&#128179; Budget Planning</h4>
                                <span>Create and manage monthly family budgets</span>
                            </a>
                        <% } %>
                        
                        <!-- F104 Expense Features -->
                        <% if (!"Kid".equals(user.getRole())) { %>
                            <a href="expense_form.jsp" class="feature-link">
                                <h4>&#128184; Add Expense</h4>
                                <span>Record family expenses</span>
                            </a>
                        <% } %>

                        <!-- F105 Income Features -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="income_form.jsp" class="feature-link">
                                <h4>&#128176; Add Income</h4>
                                <span>Record family income sources</span>
                            </a>
                            <!-- F106 Financial Dashboard Features -->
                            <a href="dashboard_summary.jsp" class="feature-link">
                                <h4>&#128202; Financial Reports</h4>
                                <span>View charts, summaries & analytics</span>
                            </a>
                        <% } %>

                        <!-- F107 Savings Goals Features -->
                        <a href="savings_goals.jsp" class="feature-link">
                            <h4>&#127919; Savings Goals</h4>
                            <span>Track family savings targets and progress</span>
                        </a>

                        <!-- F108 Transaction History Features -->
                        <% if (!"Kid".equals(user.getRole())) { %>
                            <a href="transaction_history.jsp" class="feature-link">
                                <h4>&#128203; Transaction History</h4>
                                <span>View all financial activities and history</span>
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <footer class="footer">
            <div class="container">
                <p>&copy; 2025 Famney - Family Financial Management System</p>
            </div>
        </footer>
    </body>
</html>