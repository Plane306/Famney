package model.dao;

import java.sql.Connection;

/**
 * Stores database configuration for Famney.
 * Base class for database connectivity.
 */
public abstract class DB {
    // Update this path to match your project location
    protected String URL = "jdbc:sqlite:C:/Year 3 First Semester/Advanced Software Development/Github/Famney/famney/database/queries/famney.db";
    protected String driver = "org.sqlite.JDBC";
    protected Connection conn;
}
