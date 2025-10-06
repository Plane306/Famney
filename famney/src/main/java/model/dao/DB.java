package model.dao;

import java.sql.Connection;

<<<<<<< HEAD
/**
 * Stores database configuration for Famney.
 * Base class for database connectivity.
 */
public abstract class DB {
    // Update this path to match your project location
    protected String URL = "jdbc:sqlite:C:/Users/flyin/Famney/famney/database/famney.db";
    protected String driver = "org.sqlite.JDBC";
    protected Connection conn;
}
=======
// Base class for database configuration
// Stores connection info for SQLite database
public abstract class DB {
    
    // Database file path - update this to match your project location
    protected String URL = "jdbc:sqlite:C:/Users/flyin/Famney/famney/database/famney.db";
    
    // SQLite JDBC driver
    protected String driver = "org.sqlite.JDBC";
    
    // Database connection object
    protected Connection conn;
}
>>>>>>> development
