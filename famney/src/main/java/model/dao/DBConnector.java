package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Manages database connections for Famney.
 * Handles opening and closing database connections.
 */
public class DBConnector extends DB {

    // Constructor loads SQLite driver and establishes connection
    public DBConnector() throws ClassNotFoundException, SQLException {
        Class.forName(driver);
        conn = DriverManager.getConnection(URL);
    }

    // Returns the active database connection
    public Connection openConnection() {
        return this.conn;
    }

    // Closes the database connection
    public void closeConnection() throws SQLException {
        this.conn.close();
    }
}
