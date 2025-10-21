package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.nio.file.Paths;
import java.io.File;
import java.net.URL;

public abstract class DB {

    protected String URL;
    protected String driver = "org.sqlite.JDBC";
    protected Connection conn;

    public DB() {
        try {
            // Load the SQLite JDBC driver
            Class.forName(driver);

            // Determine database path
            String azureDbPath = "/home/site/wwwroot/database/famney.db";
            URL dbResource = getClass().getClassLoader().getResource("database/famney.db");

            File dbFile = new File(azureDbPath);
            if (dbFile.exists()) {
                URL = "jdbc:sqlite:" + azureDbPath;
            } else {
                URL = "jdbc:sqlite:" + Paths.get(dbResource.toURI()).toString();
            }

            System.out.println("DB URL set to: " + URL);

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
