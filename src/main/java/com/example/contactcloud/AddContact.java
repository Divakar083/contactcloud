package com.example.contactcloud;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.sql.*;

@WebServlet(name = "addContact", value = "/addcontact")
public class AddContact extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Establish database connection
            Connection conn = DatabaseConnection.initializeDatabase();

            // Prepare SQL statement
            String sql = "INSERT INTO contacts (Name, Nickname, ContactNumber, Gender, Location) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // Set parameters
            pstmt.setString(1, request.getParameter("username"));
            pstmt.setString(2, request.getParameter("nickname"));
            pstmt.setString(3, request.getParameter("contact"));
            pstmt.setString(4, request.getParameter("gender"));
            pstmt.setString(5, request.getParameter("location"));

            // Execute the query
            pstmt.executeUpdate();

            // Close the connections
            pstmt.close();
            conn.close();

            // Redirect to index.jsp
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Handle any errors here
            response.getWriter().println("An error occurred: " + e.getMessage());
        }
    }
}