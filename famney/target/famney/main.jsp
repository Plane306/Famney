<%@ page import="model.User"%>
<%@ page import="model.Family"%>

<html>
    <head>
        <title>Dashboard - Famney</title>
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
                align-items: center;
            }
            
            .nav-menu span {
                color: white;
                font-weight: 500;
            }
            
            .nav-menu a {
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
            
            /* Main Content */
            .main-container {
                flex: 1;
                padding: 2rem;
            }
            
            .dashboard-content {
                max-width: 1200px;
                margin: 0 auto;
            }
            
            /* Welcome Section */
            .user-welcome {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
            }
            
            .user-welcome h2 {
                color: #2c3e50;
                font-size: 2rem;
                margin-bottom: 0.5rem;
                font-weight: 300;
            }
            
            .user-welcome p {
                color: #666;
                font-size: 1.1rem;
                margin-bottom: 1rem;
            }
            
            .btn {
                display: inline-block;
                background: #667eea;
                color: white;
                padding: 0.8rem 1.5rem;
                border-radius: 5px;
                text-decoration: none;
                font-weight: 600;
                margin-right: 1rem;
                margin-top: 0.5rem;
                transition: all 0.3s ease;
            }
            
            .btn:hover {
                background: #5a6fd8;
                transform: translateY(-1px);
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
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                text-align: center;
            }
            
            .stat-card h3 {
                color: #667eea;
                margin-bottom: 0.5rem;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            .stat-card p {
                color: #2c3e50;
                font-size: 1.5rem;
                font-weight: bold;
                margin: 0;
            }
            
            /* Feature Navigation */
            .feature-navigation {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .feature-navigation h2 {
                color: #2c3e50;
                margin-bottom: 1.5rem;
                font-size: 1.5rem;
                font-weight: 300;
            }
            
            .feature-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
            }
            
            .feature-link {
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 10px;
                text-decoration: none;
                color: #2c3e50;
                transition: all 0.3s ease;
                text-align: center;
                border: 2px solid transparent;
            }
            
            .feature-link:hover {
                background: #667eea;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            }
            
            .feature-link h4 {
                margin-bottom: 0.5rem;
                font-size: 1rem;
            }
            
            .feature-link span {
                font-size: 0.8rem;
                opacity: 0.8;
            }
            
            .disabled-link {
                opacity: 0.5;
                pointer-events: none;
                background: #e9ecef;
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
                    padding: 0 1rem;
                }
                
                .dashboard-stats {
                    grid-template-columns: 1fr 1fr;
                }
                
                .feature-grid {
                    grid-template-columns: 1fr;
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
                    <h2>Welcome <%= user.getFullName() %></h2>
                    <p>You are logged in as <strong><%= user.getRole() %></strong> of <%= family.getFamilyName() %>.</p>
                    <% if ("Family Head".equals(user.getRole())) { %>
                        <p><strong>Family Code:</strong> <%= family.getFamilyCode() %></p>
                    <% } %>
                    
                    <a href="edit_profile.jsp" class="btn">My Profile</a>
                    <% if ("Family Head".equals(user.getRole())) { %>
                        <a href="family_management.jsp" class="btn">Manage Family</a>
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
                    <h2>Financial Management</h2>
                    
                    <div class="feature-grid">
                        <!-- F102 (Categories) -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="categories.jsp" class="feature-link">
                                <h4>Categories</h4>
                                <span>Manage expense & income categories</span>
                            </a>
                        <% } %>
                        
                        <!-- F103 (Budget Management) -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="budget_form.jsp" class="feature-link">
                                <h4>Budget</h4>
                                <span>Create & manage family budget</span>
                            </a>
                        <% } %>
                        
                        <!-- F104 (Expense Tracking) -->
                        <% if (!"Kid".equals(user.getRole())) { %>
                            <a href="expense_form.jsp" class="feature-link">
                                <h4>Add Expense</h4>
                                <span>Record family expenses</span>
                            </a>
                        <% } %>
                        
                        <!-- F105 (Income Management) -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="income_form.jsp" class="feature-link">
                                <h4>Add Income</h4>
                                <span>Record family income</span>
                            </a>
                        <% } %>
                        
                        <!-- F106 (Financial Dashboard) -->
                        <% if ("Family Head".equals(user.getRole()) || "Adult".equals(user.getRole())) { %>
                            <a href="dashboard_summary.jsp" class="feature-link">
                                <h4>Financial Reports</h4>
                                <span>View charts & summaries</span>
                            </a>
                        <% } %>
                        
                        <!-- F107 (Savings Goals) -->
                        <a href="savings_goals.jsp" class="feature-link">
                            <h4>Savings Goals</h4>
                            <span>Track family savings targets</span>
                        </a>
                        
                        <!-- F108 (Transaction History) -->
                        <% if (!"Kid".equals(user.getRole())) { %>
                            <a href="transaction_history.jsp" class="feature-link">
                                <h4>Transaction History</h4>
                                <span>View all financial activities</span>
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