package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.nio.file.Paths;

public abstract class DB {

    protected String URL;
    protected String driver = "org.sqlite.JDBC";
    protected Connection conn;

    public DB() {
        try {
            // Load the SQLite JDBC driver
            Class.forName(driver);

            // Use an external database path (not inside resources)
            // This folder should persist across deployments, e.g., /home/site/wwwroot/database/
            String dbPath = Paths.get("database", "famney.db").toAbsolutePath().toString();
            URL = "jdbc:sqlite:" + dbPath;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize database connection!", e);
        }
    }

    // Method to open connection
    protected void connect() throws SQLException {
        if (conn == null || conn.isClosed()) {
            conn = DriverManager.getConnection(URL);
        }
    }

    // Method to close connection
    protected void disconnect() throws SQLException {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    }
}
