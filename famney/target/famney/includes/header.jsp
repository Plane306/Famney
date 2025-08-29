<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String currentPage = request.getParameter("page");
    if (currentPage == null) {
        currentPage = "dashboard";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " - Famney" : "Famney - Family Fund Management" %></title>
    
    <!-- CSS Framework -->
    <link rel="stylesheet" href="css/famney-theme.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* Consistent theme variables */
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --bg-primary: #f8fafc;
            --bg-card: #ffffff;
            --text-primary: #2d3748;
            --text-secondary: #666;
            --border-color: #e2e8f0;
            --success-color: #48bb78;
            --error-color: #f56565;
            --warning-color: #ed8936;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            margin: 0;
            padding: 0;
        }

        /* Header Styles */
        .app-header {
            background: var(--bg-card);
            border-bottom: 1px solid var(--border-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 2rem;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-decoration: none;
        }

        .family-info {
            display: flex;
            flex-direction: column;
            font-size: 0.875rem;
        }

        .family-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .family-code {
            color: var(--text-secondary);
            font-size: 0.75rem;
        }

        /* Navigation */
        .main-nav {
            display: flex;
            gap: 2rem;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .nav-item a {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            text-decoration: none;
            color: var(--text-secondary);
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-item a:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        .nav-item.active a {
            background: var(--primary-gradient);
            color: white;
        }

        /* User Section */
        .user-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            font-weight: 600;
            font-size: 0.875rem;
        }

        .user-role {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 8px;
            transition: background 0.3s ease;
        }

        .dropdown-btn:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            min-width: 200px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            padding: 0.5rem 0;
            margin-top: 0.5rem;
        }

        .dropdown-content a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-primary);
            text-decoration: none;
            transition: background 0.3s ease;
        }

        .dropdown-content a:hover {
            background: var(--bg-primary);
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .header-content {
                padding: 1rem;
            }

            .main-nav {
                display: none;
            }

            .family-info, .user-info {
                display: none;
            }
        }

        /* Main Content Area */
        .main-content {
            margin-top: 80px;
            min-height: calc(100vh - 80px);
        }
    </style>
</head>
<body>
    <header class="app-header">
        <div class="header-content">
            <!-- Logo & Family Info -->
            <div class="logo-section">
                <a href="main.jsp" class="logo">Famney</a>
                <% if (user != null) { %>
                    <div class="family-info">
                        <div class="family-name"><%= session.getAttribute("familyName") != null ? session.getAttribute("familyName") : "Family Dashboard" %></div>
                        <div class="family-code">Code: <%= session.getAttribute("familyCode") != null ? session.getAttribute("familyCode") : "FAM-XXXX" %></div>
                    </div>
                <% } %>
            </div>

            <!-- Main Navigation -->
            <% if (user != null) { %>
                <nav class="main-nav">
                    <li class="nav-item <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                        <a href="main.jsp"><i class="fas fa-home"></i> Dashboard</a>
                    </li>
                    <li class="nav-item <%= "categories".equals(currentPage) ? "active" : "" %>">
                        <a href="categories.jsp"><i class="fas fa-tags"></i> Categories</a>
                    </li>
                    <li class="nav-item <%= "budget".equals(currentPage) ? "active" : "" %>">
                        <a href="budget.jsp"><i class="fas fa-chart-pie"></i> Budget</a>
                    </li>
                    <li class="nav-item <%= "expenses".equals(currentPage) ? "active" : "" %>">
                        <a href="expenses.jsp"><i class="fas fa-receipt"></i> Expenses</a>
                    </li>
                    <li class="nav-item <%= "income".equals(currentPage) ? "active" : "" %>">
                        <a href="income.jsp"><i class="fas fa-coins"></i> Income</a>
                    </li>
                    <li class="nav-item <%= "savings".equals(currentPage) ? "active" : "" %>">
                        <a href="savings.jsp"><i class="fas fa-piggy-bank"></i> Savings</a>
                    </li>
                    <li class="nav-item <%= "reports".equals(currentPage) ? "active" : "" %>">
                        <a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a>
                    </li>
                </nav>
            <% } %>

            <!-- User Section -->
            <div class="user-section">
                <% if (user != null) { %>
                    <div class="user-info">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-role"><%= user.getRole() %></div>
                    </div>
                    <div class="dropdown">
                        <button class="dropdown-btn">
                            <div class="user-avatar">
                                <%= user.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                        </button>
                        <div class="dropdown-content">
                            <a href="profile.jsp">
                                <i class="fas fa-user"></i> Profile
                            </a>
                            <a href="family_settings.jsp">
                                <i class="fas fa-cog"></i> Family Settings
                            </a>
                            <a href="help.jsp">
                                <i class="fas fa-question-circle"></i> Help
                            </a>
                            <hr style="margin: 0.5rem 0; border: none; border-top: 1px solid var(--border-color);">
                            <a href="LogoutServlet" style="color: var(--error-color);">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div style="display: flex; gap: 1rem;">
                        <a href="login.jsp" class="btn btn-outline">Login</a>
                        <a href="register_family.jsp" class="btn btn-primary">Get Started</a>
                    </div>
                <% } %>
            </div>
        </div>
    </header>

    <!-- Message Display Section -->
    <% 
        String errorMessage = (String) session.getAttribute("errorMessage");
        String successMessage = (String) session.getAttribute("successMessage");
        if (errorMessage != null || successMessage != null) {
    %>
        <div class="message-container" style="margin-top: 80px; padding: 1rem 2rem;">
            <% if (errorMessage != null) { %>
                <div class="message error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            <% } %>
            <% if (successMessage != null) { %>
                <div class="message success-message">
                    <i class="fas fa-check-circle"></i>
                    <%= successMessage %>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>
        </div>
    <% } %>

    <main class="main-content">