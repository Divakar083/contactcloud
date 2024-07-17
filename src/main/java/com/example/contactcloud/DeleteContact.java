package com.example.contactcloud;


import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.sql.*;

@WebServlet(name = "deleteContact", value = "/deletecontact")
public class DeleteContact extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contactNumber = request.getParameter("contactNumber");

        try {
            // Establish database connection
            Connection conn = DatabaseConnection.initializeDatabase();

            // Prepare SQL statement
            String sql = "DELETE FROM contacts WHERE ContactNumber = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // Set parameter
            pstmt.setString(1, contactNumber);

            // Execute the query
            pstmt.executeUpdate();

            // Close the connections
            pstmt.close();
            conn.close();

            // Redirect back to index.jsp
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Handle any errors here
            response.getWriter().println("An error occurred: " + e.getMessage());
        }
    }
}