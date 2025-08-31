<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="java.util.Date"%>

<html>
    <head>
        <title>Sign In - Famney</title>
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
            
            /* Main Container */
            .main-container {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 2rem;
            }
            
            .login-form {
                background: white;
                padding: 3rem;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                max-width: 450px;
                width: 100%;
            }
            
            .form-header {
                text-align: center;
                margin-bottom: 2rem;
            }
            
            .form-header h1 {
                color: #2c3e50;
                font-size: 2.2rem;
                margin-bottom: 0.5rem;
            }
            
            .form-header p {
                color: #7f8c8d;
                font-size: 1.1rem;
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
            
            .form-group input {
                width: 100%;
                padding: 1rem;
                border: 2px solid #ecf0f1;
                border-radius: 10px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fafafa;
            }
            
            .form-group input:focus {
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
            
            .form-links {
                text-align: center;
                margin-top: 1.5rem;
            }
            
            .form-links a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s ease;
                margin: 0 0.5rem;
            }
            
            .form-links a:hover {
                color: #764ba2;
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
                .login-form {
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
        <header class="header">
            <div class="nav-container">
                <a href="index.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <a href="index.jsp">Home</a>
                    <a href="register_family.jsp">Create Family</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="login-form">
                <div class="form-header">
                    <h1>Welcome Back</h1>
                    <p>Sign in to your family account</p>
                </div>
                
                <%
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String errorMessage = request.getParameter("error");
                    
                    // Hardcoded sample users for R0 demo (using full constructor)
                    if (email != null && password != null) {
                        User user = null;
                        Family family = null;
                        
                        // Create family object with full constructor (consistent data)
                        Date now = new Date();
                        family = new Family("FAM001", "FAMNEY-12345", "The Smith Family", "USER001", now, now, true, 4);
                        
                        // Sample hardcoded login credentials using full constructor
                        if ("john@smith.com".equals(email) && "password123".equals(password)) {
                            user = new User("USER001", "john@smith.com", "password123", "John Smith", "Family Head", "FAM001", now, now, now, true);
                        } else if ("jane@smith.com".equals(email) && "password123".equals(password)) {
                            user = new User("USER002", "jane@smith.com", "password123", "Jane Smith", "Adult", "FAM001", now, now, now, true);
                        } else if ("mike@smith.com".equals(email) && "password123".equals(password)) {
                            user = new User("USER003", "mike@smith.com", "password123", "Mike Smith", "Teen", "FAM001", now, now, now, true);
                        } else if ("lucy@smith.com".equals(email) && "password123".equals(password)) {
                            user = new User("USER004", "lucy@smith.com", "password123", "Lucy Smith", "Kid", "FAM001", now, now, now, true);
                        }
                        
                        if (user != null) {
                            // Store in session and redirect
                            session.setAttribute("user", user);
                            session.setAttribute("family", family);
                            response.sendRedirect("main.jsp");
                            return;
                        } else {
                            response.sendRedirect("login.jsp?error=invalid");
                            return;
                        }
                    }
                    
                    if (errorMessage != null) {
                %>
                    <div class="error-message">
                        <% if ("invalid".equals(errorMessage)) { %>
                            Invalid email or password. Please try again.
                        <% } else if ("required".equals(errorMessage)) { %>
                            Please fill in all required fields.
                        <% } else { %>
                            An error occurred. Please try again.
                        <% } %>
                    </div>
                <% } %>
                
                <form action="login.jsp" method="post">
                    <input type="hidden" name="action" value="login">
                    
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" required 
                               placeholder="Enter your email address">
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required 
                               placeholder="Enter your password">
                    </div>
                    
                    <button type="submit" class="btn-primary">Sign In</button>
                </form>
                
                <div class="form-links">
                    <p>Don't have a family account? <a href="register_family.jsp">Create one</a></p>
                    <p>Want to join existing family? <a href="join_family.jsp">Join here</a></p>
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