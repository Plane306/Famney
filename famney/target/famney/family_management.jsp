<%@ page import="model.User"%>
<%@ page import="model.Family"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<html>
    <head>
        <title>Manage Family - Famney</title>
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
            
            .family-info {
                background: #f8f9fa;
                padding: 1.5rem;
                border-radius: 15px;
                margin-bottom: 2rem;
                border-left: 5px solid #667eea;
            }
            
            .family-info h3 {
                color: #2c3e50;
                margin-bottom: 0.5rem;
            }
            
            .family-info p {
                color: #6c757d;
                margin-bottom: 0.3rem;
            }
            
            .members-section h2 {
                color: #2c3e50;
                margin-bottom: 1.5rem;
                font-size: 1.8rem;
            }
            
            .members-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            }
            
            .members-table thead {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .members-table th,
            .members-table td {
                padding: 1.2rem;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
            }
            
            .members-table th {
                font-weight: 600;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .members-table tbody tr:hover {
                background: #f8f9fa;
                transition: background 0.3s ease;
            }
            
            .member-name {
                font-weight: 600;
                color: #2c3e50;
            }
            
            .member-role {
                display: inline-block;
                padding: 0.3rem 0.8rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .role-family-head { background: #d1ecf1; color: #0c5460; }
            .role-adult { background: #d4edda; color: #155724; }
            .role-teen { background: #fff3cd; color: #856404; }
            .role-kid { background: #f8d7da; color: #721c24; }
            
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
            
            .btn-remove {
                background: #dc3545;
                color: white;
            }
            
            .btn-remove:hover {
                background: #c82333;
                transform: translateY(-1px);
            }
            
            .role-select {
                padding: 0.3rem 0.5rem;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 0.8rem;
                margin-right: 0.5rem;
            }
            
            .role-select:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .btn-back {
                display: inline-block;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                padding: 1rem 2rem;
                border: none;
                border-radius: 10px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                margin-top: 2rem;
            }
            
            .btn-back:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
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
            
            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
                color: #6c757d;
            }
            
            .empty-state h3 {
                margin-bottom: 1rem;
                color: #495057;
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
                .management-card {
                    margin: 1rem;
                    padding: 2rem;
                }
                
                .members-table th,
                .members-table td {
                    padding: 0.8rem 0.5rem;
                    font-size: 0.9rem;
                }
                
                .action-buttons {
                    flex-direction: column;
                    gap: 0.3rem;
                }
                
                .btn-small {
                    width: 100%;
                }
                
                .nav-menu {
                    gap: 1rem;
                }
            }
        </style>
    </head>
    
    <body>
        <%
            // Check if user is logged in and is Family Head
            User user = (User) session.getAttribute("user");
            Family family = (Family) session.getAttribute("family");
            
            if (user == null || family == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Only Family Head can access this page
            if (!"Family Head".equals(user.getRole())) {
                response.sendRedirect("main.jsp");
                return;
            }
            
            // Handle actions
            String action = request.getParameter("action");
            String successMessage = "";
            
            // Hardcoded sample for family members
            List<User> familyMembers = new ArrayList<>();
            
            User member1 = new User("john@smith.com", "password123", "John Smith", "Family Head", "FAM001");
            member1.setUserId("USER001");
            
            User member2 = new User("jane@smith.com", "password123", "Jane Smith", "Adult", "FAM001");
            member2.setUserId("USER002");
            
            User member3 = new User("mike@smith.com", "password123", "Mike Smith", "Teen", "FAM001");
            member3.setUserId("USER003");
            
            User member4 = new User("lucy@smith.com", "password123", "Lucy Smith", "Kid", "FAM001");
            member4.setUserId("USER004");
            
            familyMembers.add(member1);
            familyMembers.add(member2);
            familyMembers.add(member3);
            familyMembers.add(member4);
            
            // Handle role change action
            if (action != null && action.equals("change_role")) {
                String memberId = request.getParameter("memberId");
                String newRole = request.getParameter("newRole");
                
                if (memberId != null && newRole != null) {
                    // Find and update member role
                    for (User member : familyMembers) {
                        if (member.getUserId().equals(memberId)) {
                            member.setRole(newRole);
                            successMessage = "Member role updated successfully!";
                            break;
                        }
                    }
                }
            }
            
            // Handle remove member action
            if (action != null && action.equals("remove")) {
                String memberId = request.getParameter("memberId");
                
                if (memberId != null) {
                    // Remove from list
                    familyMembers.removeIf(member -> member.getUserId().equals(memberId));
                    successMessage = "Member removed from family successfully!";
                }
            }
        %>
        
        <header class="header">
            <div class="nav-container">
                <a href="index.jsp" class="logo">Famney</a>
                <nav class="nav-menu">
                    <span>Family Head: <%= user.getFullName() %></span>
                    <a href="main.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </nav>
            </div>
        </header>
        
        <div class="main-container">
            <div class="management-card">
                <div class="page-header">
                    <h1>Family Management</h1>
                    <p>Manage your family members and their roles</p>
                </div>
                
                <div class="family-info">
                    <h3><%= family.getFamilyName() %> Family</h3>
                    <p><strong>Family Code:</strong> <%= family.getFamilyCode() %></p>
                    <p><strong>Total Members:</strong> <%= familyMembers.size() %></p>
                    <p><strong>Created:</strong> <%= family.getCreatedDate() != null ? family.getCreatedDate().toString() : "Recently" %></p>
                </div>
                
                <% if (!successMessage.isEmpty()) { %>
                    <div class="success-message">
                        <%= successMessage %>
                    </div>
                <% } %>
                
                <div class="members-section">
                    <h2>Family Members</h2>
                    
                    <% if (familyMembers.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No family members found</h3>
                            <p>Invite family members using your family code: <strong><%= family.getFamilyCode() %></strong></p>
                        </div>
                    <% } else { %>
                        <table class="members-table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Joined</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User member : familyMembers) { %>
                                    <tr>
                                        <td class="member-name"><%= member.getFullName() %></td>
                                        <td><%= member.getEmail() %></td>
                                        <td>
                                            <span class="member-role role-<%= member.getRole().toLowerCase().replace(" ", "-") %>">
                                                <%= member.getRole() %>
                                            </span>
                                        </td>
                                        <td>
                                            <%= member.getJoinDate() != null ? member.getJoinDate().toString() : "Recently" %>
                                        </td>
                                        <td>
                                            <% if (member.getUserId().equals(user.getUserId())) { %>
                                                <span style="color: #6c757d; font-style: italic;">You</span>
                                            <% } else { %>
                                                <div class="action-buttons">
                                                    <!-- Role Change Form -->
                                                    <form action="family_management.jsp" method="post" style="display: inline-flex; align-items: center; gap: 0.5rem;">
                                                        <input type="hidden" name="action" value="change_role">
                                                        <input type="hidden" name="memberId" value="<%= member.getUserId() %>">
                                                        <select name="newRole" class="role-select">
                                                            <option value="Adult" <%= "Adult".equals(member.getRole()) ? "selected" : "" %>>Adult</option>
                                                            <option value="Teen" <%= "Teen".equals(member.getRole()) ? "selected" : "" %>>Teen</option>
                                                            <option value="Kid" <%= "Kid".equals(member.getRole()) ? "selected" : "" %>>Kid</option>
                                                        </select>
                                                        <button type="submit" class="btn-small btn-edit">Update</button>
                                                    </form>
                                                    
                                                    <!-- Remove Member Form -->
                                                    <form action="family_management.jsp" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="memberId" value="<%= member.getUserId() %>">
                                                        <button type="submit" class="btn-small btn-remove" 
                                                                onclick="return confirm('Are you sure you want to remove <%= member.getFullName() %> from the family?')">
                                                            Remove
                                                        </button>
                                                    </form>
                                                </div>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
                
                <div style="text-align: center;">
                    <a href="main.jsp" class="btn-back">Back to Dashboard</a>
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