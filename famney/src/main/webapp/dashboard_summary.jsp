<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="model.User" %>
<%@ page import="model.Family" %>

<%
    // Ensure user is logged in
    User user = (User) session.getAttribute("user");
    Family family = (Family) session.getAttribute("family");

    if (user == null || family == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Dashboard data from servlet
    Map<String, Object> dashboardData = (Map<String, Object>) request.getAttribute("dashboardData");
    if (dashboardData == null) {
        dashboardData = new HashMap<>();
    }

    // Monthly summary
    Map<String, Object> summary = new HashMap<>();
    if (dashboardData.get("monthlySummary") instanceof Map) {
        summary = (Map<String, Object>) dashboardData.get("monthlySummary");
    }

    // Top categories
    List<Map<String, Object>> topCategories = null;
    if (dashboardData.get("topCategories") instanceof List) {
        topCategories = (List<Map<String, Object>>) dashboardData.get("topCategories");
    }

    // Financial trend
    List<Map<String, Object>> trend = null;
    if (dashboardData.get("financialTrend") instanceof List) {
        trend = (List<Map<String, Object>>) dashboardData.get("financialTrend");
    }

    // Recent transactions
    List<Map<String, Object>> recent = null;
    if (dashboardData.get("recentTransactions") instanceof List) {
        recent = (List<Map<String, Object>>) dashboardData.get("recentTransactions");
    }

    // Month/Year for display
    Calendar cal = Calendar.getInstance();
    int currentMonth = cal.get(Calendar.MONTH) + 1; 
    int currentYear = cal.get(Calendar.YEAR);

    String[] monthNames = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
    Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
    int selectedM = (selectedMonth != null) ? selectedMonth : currentMonth;
    Integer selectedYear = (Integer) request.getAttribute("selectedYear");
    int selectedY = (selectedYear != null) ? selectedYear : currentYear;



    // Build JS arrays for Chart.js
    StringBuilder labels = new StringBuilder("[");
    StringBuilder incomeData = new StringBuilder("[");
    StringBuilder expensesData = new StringBuilder("[");
    if (trend != null) {
        for (int i = 0; i < trend.size(); i++) {
            Map<String, Object> t = trend.get(i);
            labels.append("'").append(t.get("month")).append("/").append(t.get("year")).append("'");
            incomeData.append(t.get("income"));
            expensesData.append(t.get("expenses"));
            if (i < trend.size() - 1) {
                labels.append(",");
                incomeData.append(",");
                expensesData.append(",");
            }
        }
    }
    labels.append("]");
    incomeData.append("]");
    expensesData.append("]");
%>
<html>
    <head>
        <title>Dashboard - Famney</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f7fa;
            }

            /* Header */
            .header {
                background: #2c3e50;
                padding: 1rem 0;
                color: white;
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
                text-decoration: none;
                color: white;
            }

            .nav-menu a,
            .nav-menu span {
                color: white;
                text-decoration: none;
                margin-left: 1rem;
            }

            .main-container {
                padding: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }

            .card {
                border-radius: 15px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                padding: 1rem;
            }

            .dashboard-title {
                font-weight: 600;
                margin-bottom: 1rem;
            }

            footer.footer {
                margin-top: 2rem;
                padding: 1rem;
                text-align: center;
                background: #2c3e50;
                color: white;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
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
            <div class="mb-3">
                <h4>Dashboard for <%= monthNames[selectedM - 1] %> <%= selectedY %></h4>
            </div>

            <!-- Month/Year Selection Form (Auto-submit + Loading Spinner) -->
            <div class="mb-4 position-relative">
                <!-- Overlay Spinner -->
                <div id="loadingOverlay" 
                    style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
                            background:rgba(255,255,255,0.8); z-index:9999; 
                            align-items:center; justify-content:center;">
                    <div class="spinner-border text-primary" role="status" style="width:3rem; height:3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>

                <form method="get" action="DashboardServlet" id="monthYearForm" class="row g-3 align-items-end">
                    <div class="col-auto">
                        <label for="monthSelect" class="form-label text-black fw-semibold">Month</label>
                        <select name="month" id="monthSelect" class="form-select" onchange="autoSubmitForm()">
                            <%
                                for (int i = 0; i < 12; i++) {
                                    int monthValue = i + 1; // 1..12
                                    String sel = (selectedM == monthValue) ? "selected" : "";
                            %>
                                    <option value="<%= monthValue %>" <%= sel %>><%= monthNames[i] %></option>
                            <%
                                }
                            %>

                        </select>
                    </div>
                    <div class="col-auto">
                        <label for="yearSelect" class="form-label text-black fw-semibold">Year</label>
                        <select name="year" id="yearSelect" class="form-select" onchange="autoSubmitForm()">
                            <%
                                for (int y = currentYear - 5; y <= currentYear + 1; y++) {
                                    String sel = (selectedY == y) ? "selected" : "";
                            %>
                                <option value="<%= y %>" <%= sel %>><%= y %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </form>
            </div>

            <script>
                function autoSubmitForm() {
                    const overlay = document.getElementById('loadingOverlay');
                    overlay.style.display = 'flex';
                    document.getElementById('monthYearForm').submit();
                }
            </script>


            <!-- Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <h6>Total Income</h6>
                        <h4 class="text-success">$<%= summary.get("totalIncome") != null ? summary.get("totalIncome") : " -" %></h4>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <h6>Total Expenses</h6>
                        <h4 class="text-danger">$<%= summary.get("totalExpenses") != null ? summary.get("totalExpenses") : " -" %></h4>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <h6>Net Savings</h6>
                        <h4 class="text-primary">$<%= summary.get("netSavings") != null ? summary.get("netSavings") : " -" %></h4>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <h6>Savings Rate</h6>
                        <h4 class="text-info">
                            <%
                                Object rateObj = summary.get("savingsRate");
                                if (rateObj instanceof Number) {
                                    out.print(String.format("%.1f", ((Number) rateObj).doubleValue()) + "%");
                                } else {
                                    out.print("- %");
                                }
                            %>
                        </h4>
                    </div>
                </div>
            </div>

            <!-- Trend Chart -->
            <div class="card mb-4">
                <h5 class="dashboard-title">Income vs Expenses (Last 6 Months)</h5>
                <canvas id="trendChart"></canvas>
            </div>

            <!-- Top Categories Table -->
            <div class="card mb-4">
                <h5 class="dashboard-title">Top Spending Categories</h5>
                <table class="table table-striped table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Category</th>
                            <th>Amount ($)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (topCategories != null && !topCategories.isEmpty()) {
                                for (Map<String, Object> cat : topCategories) {
                        %>
                                    <tr>
                                        <td><%= cat.get("categoryName") %></td>
                                        <td><%= cat.get("totalSpent") %></td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr><td colspan="2" class="text-center text-muted">No data available</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Recent Transactions Table -->
            <div class="card mb-4">
                <h5 class="dashboard-title">Recent Transactions</h5>
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Description</th>
                            <th>Category</th>
                            <th>Amount ($)</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (recent != null && !recent.isEmpty()) {
                                for (Map<String, Object> txn : recent) {
                        %>
                                    <tr>
                                        <td><%= txn.get("description") %></td>
                                        <td><%= txn.get("categoryName") %></td>
                                        <td><%= txn.get("amount") %></td>
                                        <td><%= txn.get("date") %></td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr><td colspan="4" class="text-center text-muted">No recent transactions</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Chart.js Script -->
        <script>
            const labels = <%= labels %>;
            const income = <%= incomeData %>;
            const expenses = <%= expensesData %>;

            new Chart(document.getElementById('trendChart'), {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        { label: 'Income', data: income, borderColor: 'rgba(75, 192, 192, 1)', tension: 0.3, fill: false },
                        { label: 'Expenses', data: expenses, borderColor: 'rgba(255, 99, 132, 1)', tension: 0.3, fill: false }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'bottom' } },
                    scales: { y: { beginAtZero: true } }
                }
            });
        </script>

        <footer class="footer">
            &copy; 2025 Famney - Family Financial Management System
        </footer>

    </body>
</html>
