import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.List;

import model.SavingsGoal;
import model.dao.SavingsGoalManager;

public class SavingsGoalTest {

    private SavingsGoalManager mgr;
    private Connection conn;

    @BeforeEach
    public void setUp() throws Exception {
        Class.forName("org.sqlite.JDBC");
        String dbPath = "C:/Year 3 First Semester/Advanced Software Development/Github/Famney/famney/database/queries/famney.db";
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        mgr = new SavingsGoalManager(conn);
    }

    @AfterEach
    public void tearDown() throws Exception {
        if (conn != null) {
            conn.close();
        }
    }

    @Test
    public void testAddToGoal() throws Exception {
        SavingsGoal goal = new SavingsGoal("goal2", "family2", "Save for Vacation", 3000.0, null, "user2");
        mgr.createGoal(goal);

        boolean result = mgr.addToSavingsGoal("goal2", 500.0);
        assertTrue(result, "Adding to goal should succeed");
    }

    @Test
    public void testListGoals() throws Exception {
        SavingsGoal goal1 = new SavingsGoal("goal3", "family3", "Save for House", 10000.0, null, "user3");
        SavingsGoal goal2 = new SavingsGoal("goal4", "family3", "Save for Emergency", 2000.0, null, "user3");
        mgr.createGoal(goal1);
        mgr.createGoal(goal2);

        List<SavingsGoal> goals = mgr.listGoals("family3");
        assertEquals(2, goals.size(), "There should be 2 goals for the family");
    }
}