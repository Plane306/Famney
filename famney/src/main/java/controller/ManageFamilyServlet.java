package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import model.dao.UserManager;
import model.dao.FamilyManager;

// Handles family member management actions by Family Head
// Supports role changes and member removal
@WebServlet("/ManageFamilyServlet")
public class ManageFamilyServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is Family Head
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (!"Family Head".equals(currentUser.getRole())) {
            session.setAttribute("errorMessage", "Only Family Head can manage members");
            response.sendRedirect("main.jsp");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            session.setAttribute("errorMessage", "Invalid action");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        try {
            // Get DAO managers from session
            UserManager userManager = (UserManager) session.getAttribute("userManager");
            FamilyManager familyManager = (FamilyManager) session.getAttribute("familyManager");
            
            if (userManager == null || familyManager == null) {
                session.setAttribute("errorMessage", "System error. Please try again");
                response.sendRedirect("family_management.jsp");
                return;
            }
            
            // Handle different actions
            if ("change_role".equals(action)) {
                handleRoleChange(request, response, session, userManager, currentUser);
                
            } else if ("remove_member".equals(action)) {
                handleRemoveMember(request, response, session, userManager, familyManager, currentUser);
                
            } else {
                session.setAttribute("errorMessage", "Unknown action");
                response.sendRedirect("family_management.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred. Please try again");
            response.sendRedirect("family_management.jsp");
        }
    }
    
    // Handle role change for family member
    private void handleRoleChange(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, UserManager userManager, User currentUser)
            throws Exception {
        
        String memberId = request.getParameter("memberId");
        String newRole = request.getParameter("newRole");
        
        // Validate inputs
        if (memberId == null || newRole == null) {
            session.setAttribute("errorMessage", "Missing required information");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        // Cannot change own role
        if (memberId.equals(currentUser.getUserId())) {
            session.setAttribute("errorMessage", "Cannot change your own role");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        // Validate new role
        UserValidator validator = new UserValidator();
        if (!validator.validateRole(newRole) || "Family Head".equals(newRole)) {
            session.setAttribute("errorMessage", "Invalid role selection");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        // Update role in database
        boolean updated = userManager.updateUserRole(memberId, newRole);
        
        if (updated) {
            session.setAttribute("successMessage", "Member role updated successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to update role. Please try again");
        }
        
        response.sendRedirect("family_management.jsp");
    }
    
    // Handle member removal from family
    private void handleRemoveMember(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session, UserManager userManager,
                                    FamilyManager familyManager, User currentUser)
            throws Exception {
        
        String memberId = request.getParameter("memberId");
        
        // Validate input
        if (memberId == null) {
            session.setAttribute("errorMessage", "Missing member information");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        // Cannot remove self
        if (memberId.equals(currentUser.getUserId())) {
            session.setAttribute("errorMessage", "Cannot remove yourself from the family");
            response.sendRedirect("family_management.jsp");
            return;
        }
        
        // Remove member (soft delete)
        boolean removed = userManager.deleteUser(memberId);
        
        if (removed) {
            // Decrement family member count
            familyManager.decrementMemberCount(currentUser.getFamilyId());
            
            session.setAttribute("successMessage", "Member removed from family successfully");
        } else {
            session.setAttribute("errorMessage", "Failed to remove member. Please try again");
        }
        
        response.sendRedirect("family_management.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to management page
        response.sendRedirect("family_management.jsp");
    }
}