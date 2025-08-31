<%@ page import="model.User"%>
<%@ page import="model.Family"%>

<html>
    <head>
        <title>Welcome to Your Family - Famney</title>
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
            
            .nav-menu span {
                color: white;
                padding: 0.5rem 1rem;
                font-weight: 600;
                opacity: 0.9;
            }
            
            /* Main Content */
            .main-container {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 3rem 2rem;
            }
            
            .success-card {
                background: white;
                padding: 3rem;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 600px;
                text-align: center;
            }
            
            .success-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #4caf50, #2e7d32);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 2rem;
                font-size: 2.5rem;
                color: white;
                font-weight: bold;
            }
            
            .success-card h1 {
                color: #2c3e50;
                font-size: 2.2rem;
                margin-bottom: 1rem;
                font-weight: 300;
            }
            
            .success-card p {
                color: #666;
                font-size: 1.1rem;
                line-height: 1.6;
                margin-bottom: 2rem;
            }
            
            .family-info {
                background: #f8f9fa;
                padding: 2rem;
                border-radius: 15px;
                margin: 2rem 0;
            }
            
            .family-info h3 {
                color: #2c3e50;
                margin-bottom: 1rem;
                font-size: 1.3rem;
            }
            
            .info-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 0.8rem;
                padding: 0.5rem 0;
                border-bottom: 1px solid #e1e8ed;
            }
            
            .info-item:last-child {
                border-bottom: none;
            }
            
            .info-label {
                font-weight: 600;
                color: #2c3e50;
            }
            
            .info-value {
                color: #666;
                font-weight: 500;
            }
            
            .family-code-highlight {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 1rem;
                border-radius: 10px;
                font-family: monospace;
                font-size: 1.2rem;
                font-weight: bold;
                letter-spacing: 1px;
                margin: 1.5rem 0;
            }
            
            .code-instruction {
                background: #fff3cd;
                color: #856404;
                padding: 1rem;
                border-radius: 10px;
                border-left: 4px solid #ffc107;
                margin-bottom: 2rem;
                text-align: left;
            }
            
            .code-instruction h4 {
                margin-bottom: 0.5rem;
                color: #856404;
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 1rem 2rem;
                border: none;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin: 0.5rem;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            }
            
            .btn-secondary {
                background: transparent;
                color: #667eea;
                padding: 1rem 2rem;
                border: 2px solid #667eea;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin: 0.5rem;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn-secondary:hover {
                background: #667eea;
                color: white;
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
                .success-card {
                    margin: 1rem;
                    padding: 2rem;
                }
                
                .info-item {
                    flex-direction: column;
                    gap: 0.5rem;
                }
                
                .nav-menu {
                    gap: 1rem;
                }
            }
        </style>
    </head>
    
    <body>
        <%
            // Security check (prevent direct URL access)
            String action = request.getParameter("action");
            boolean isNewFamily = "create_family".equals(action);
            boolean isJoinFamily = "join_family".equals(action);
            
            // Redirect if accessed directly without form submission
            if (action == null || (!isNewFamily && !isJoinFamily)) {
                response.sendRedirect("index.jsp");
                return;
            }
            
            // Hardcoded sample data for R0 prototype demonstration
            String familyName = "The Smith Family";
            String fullName = isNewFamily ? "John Smith" : "Jane Smith";
            String email = isNewFamily ? "john@smith.com" : "jane@smith.com";
            String familyCode = "FAMNEY-12345";
            String role = isNewFamily ? "Family Head" : "Adult";
            
            // Store sample user in session for demo
            User sampleUser = new User(email, "password123", fullName, role, "FAM001");
            Family sampleFamily = new Family(familyCode, familyName, "john@smith.com");
            session.setAttribute("user", sampleUser);
            session.setAttribute("family", sampleFamily);
        %>
        
        <header class="header">
            <div class="nav-container">
                <a href="index.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <span>Welcome, <%= fullName %></span>
                    <a href="main.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="success-card">
                <div class="success-icon">&check;</div>
                
                <% if (isNewFamily) { %>
                    <h1>Family Account Created Successfully!</h1>
                    <p>Congratulations! You've successfully created your family financial management account. You're now ready to start tracking expenses, managing budgets, and achieving your savings goals together.</p>
                <% } else { %>
                    <h1>Welcome to the Family!</h1>
                    <p>You've successfully joined <%= sampleFamily.getFamilyName() %>. You now have access to your family's financial dashboard and can start contributing to your shared financial goals.</p>
                <% } %>
                
                <div class="family-info">
                    <h3>Your Account Details</h3>
                    <div class="info-item">
                        <span class="info-label">Family Name:</span>
                        <span class="info-value"><%= sampleFamily.getFamilyName() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Your Name:</span>
                        <span class="info-value"><%= sampleUser.getFullName() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= sampleUser.getEmail() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Role:</span>
                        <span class="info-value"><%= sampleUser.getRole() %></span>
                    </div>
                </div>
                
                <% if (isNewFamily) { %>
                    <div class="code-instruction">
                        <h4>Your Family Code</h4>
                        <p>Share this code with family members so they can join your family fund.</p>
                    </div>
                    
                    <div class="family-code-highlight">
                        <%= sampleFamily.getFamilyCode() %>
                    </div>
                <% } %>
                
                <div style="margin-top: 2rem;">
                    <a href="main.jsp" class="btn-primary">Go to Dashboard</a>
                    <% if (isNewFamily) { %>
                        <a href="categories.jsp" class="btn-secondary">Set Up Categories</a>
                    <% } else { %>
                        <a href="edit_profile.jsp" class="btn-secondary">Edit Profile</a>
                    <% } %>
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