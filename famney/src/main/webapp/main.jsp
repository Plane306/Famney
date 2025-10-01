<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="model.dao.UserManager"%>
<%@ page import="model.dao.FamilyManager"%>
<%@ page import="java.util.List"%>

<!-- Initialise database connection -->
<jsp:include page="/ConnServlet" flush="true"/>

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
            
            .success-message {
                background: #d4edda;
                color: #155724;
                padding: 1rem;
                border-radius: 10px;
                margin-bottom: 1rem;
                border: 1px solid #c3e6cb;
                text-align: center;
            }
            
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
            
            .admin-only {
                border-left-color: #ffc107;
            }
            
            .admin-only:hover {
                border-color: #ffc107;
            }
            
            .footer {
                background: #2c3e50;
                color: white;
                padding: 2rem;
                text-align: center;
            }
            
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
            
            // Get flash message
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                session.removeAttribute("successMessage");
            }
            
            // Get DAO managers from session
            UserManager userManager = (UserManager) session.getAttribute("userManager");
            FamilyManager familyManager = (FamilyManager) session.getAttribute("familyManager");
            
            // Get real member count from database
            int memberCount = 0;
            try {
                if (familyManager != null) {
                    memberCount = familyManager.getMemberCount(family.getFamilyId());
                }
            } catch (Exception e) {
                memberCount = family.getMemberCount();
            }
        %>
        
        <header class="header">
            <div class="nav-container">
                <a href="index.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <span>Welcome, <%= user.getFullName() %></span>
                    <a href="LogoutServlet">Logout</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="dashboard-content">
                <div class="user-welcome">
                    <% if (successMessage != null) { %>
                        <div class="success-message">
                            <%= successMessage %>
                        </div>
                    <% } %>
                    
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
                        <p><%= memberCount %></p>
                    </div>
                    <div class="stat-card">
                        <h3>Your Role</h3>
                        <p><%= user.getRole() %></p>
                    </div>
                    <div class="stat-card">
                        <h3>Family Since</h3>
                        <p><%= family.getCreatedDate() != null ? 
                            new java.text.SimpleDateFormat("MMM yyyy").format(family.getCreatedDate()) : "Recently" %></p>
                    </div>
                    <div class="stat-card">
                        <h3>Account Active</h3>
                        <p><%= user.isActive() ? "Yes" : "No" %></p>
                    </div>
                </div>
                
                <!-- Feature Navigation -->
                <div class="feature-navigation">
                    <h2>Family Financial Management</h2>
                    
                    <div class="feature-grid">
                        <!-- F101 User & Family Management -->
                        <a href="edit_profile.jsp" class="feature-link">
                            <h4>Edit My Profile</h4>
                            <span>Update your personal information and password</span>
                        </a>
                        
                        <% if ("Family Head".equals(user.getRole())) { %>
                            <a href="family_management.jsp" class="feature-link admin-only">
                                <h4>Manage Family</h4>
                                <span>Manage family members, roles, and permissions</span>
                            </a>
                        <% } %>
                        
                        <!-- F102 Category Management -->
                        <% if ("Family Head".equals(user.getRole())) { %>
                            <a href="categories.jsp" class="feature-link admin-only">
                                <h4>Manage Categories</h4>
                                <span>Create and edit expense & income categories</span>
                            </a>
                        <% } else if ("Adult".equals(user.getRole())) { %>
                            <a href="categories.jsp" class="feature-link">
                                <h4>View Categories</h4>
                                <span>Browse available expense & income categories</span>
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