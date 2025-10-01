package model.dao;

import java.sql.Connection;

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
