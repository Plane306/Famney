// Made by Muhammad Naufal Farhan Mudofi

package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.File;
import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public abstract class DB {

    protected String URL;
    protected String driver = "org.sqlite.JDBC";
    protected Connection conn;

    public DB() {
        try {
            // Load the SQLite JDBC driver
            Class.forName(driver);

            // Determine database path based on deployment environment
            String azureDbPath = "/home/site/wwwroot/database/famney.db";
            File azureDbFile = new File(azureDbPath);

            if (azureDbFile.exists()) {
                // Azure deployment - use Azure path
                URL = "jdbc:sqlite:" + azureDbPath;
            } else {
                // Local development - extract database from WAR to writable location
                String externalDbPath = extractDatabaseFromWAR();
                URL = "jdbc:sqlite:" + externalDbPath;
            }

        } catch (Exception e) {
            e.printStackTrace(System.err);
            throw new RuntimeException("Failed to initialise database connection!", e);
        }
    }

    /**
     * Extracts database from WAR to external writable location
     * SQLite cannot write to files inside JAR/WAR archives, so database must be extracted
     * to an external location for read-write operations
     */
    private String extractDatabaseFromWAR() throws IOException {
        // Create external database directory in system temp folder
        String tempDir = System.getProperty("java.io.tmpdir");
        File dbDir = new File(tempDir, "famney_db");

        if (!dbDir.exists()) {
            dbDir.mkdirs();
        }

        File externalDb = new File(dbDir, "famney.db");

        // Check if force refresh is enabled (useful for resetting database during development)
        String forceRefresh = System.getProperty("famney.db.refresh", "false");

        // Only extract if database doesn't exist OR force refresh is enabled
        if (!externalDb.exists() || "true".equalsIgnoreCase(forceRefresh)) {
            InputStream dbStream = getClass().getClassLoader().getResourceAsStream("database/famney.db");
            if (dbStream == null) {
                throw new IOException("Database file not found in WAR resources!");
            }

            try (FileOutputStream fos = new FileOutputStream(externalDb)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = dbStream.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            } finally {
                dbStream.close();
            }
        }

        return externalDb.getAbsolutePath();
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
