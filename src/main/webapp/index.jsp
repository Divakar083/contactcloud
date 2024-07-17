<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.contactcloud.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Cloud</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #121212;
            color: #e0e0e0;
        }
        .header {
            background: linear-gradient(to right, #1e1e1e, #2a2a2a);
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: #FF9000;
        }
        .add-contact-btn {
            background-color: #FF9000;
            color: #121212;
            border: none;
            padding: 0.7rem 1.2rem;
            border-radius: 2rem;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .add-contact-btn:hover {
            background-color: #FFB040;
            transform: translateY(-2px);
        }
        .container {
            max-width: 90rem;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .add-contact-form {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #2a2a2a, #1e1e1e);
            padding: 2rem;
            border-radius: 1rem;
            z-index: 1001;
            display: none;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            width: 24rem;
        }
        .add-contact-form input {
            width: 100%;
            padding: 0.8rem;
            margin: 0.8rem 0;
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 0.5rem;
            font-size: 1rem;
            color: #e0e0e0;
            transition: all 0.3s ease;
        }
        .add-contact-form input:focus {
            outline: none;
            border-color: #FF9000;
        }
        .add-contact-form input[type="submit"] {
            background-color: #FF9000;
            color: #121212;
            cursor: pointer;
            font-weight: 500;
            border: none;
            transition: all 0.3s ease;
        }
        .add-contact-form input[type="submit"]:hover {
            background-color: #FFB040;
        }
        .contacts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(20rem, 1fr));
            gap: 2rem;
        }
        .contact-card {
            background: linear-gradient(135deg, rgba(30, 30, 30, 0.8), rgba(20, 20, 20, 0.8));
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }
        .contact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.3);
        }
        .contact-image {
            width: 8rem;
            height: 8rem;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 3rem;
            color: #121212;
            background-color: #FF9000;
            margin: 2rem auto 1rem;
        }
        .contact-info {
            padding: 1.5rem;
            text-align: center;
        }
        .contact-card h3 {
            margin: 0 0 0.5rem;
            font-size: 1.4rem;
            font-weight: 700;
            color: #FF9000;
        }
        .contact-card .nickname {
            font-size: 1.2rem;
            font-weight: 500;
            color: #e0e0e0;
            margin-bottom: 0.5rem;
        }
        .contact-card .full-name {
            font-size: 1rem;
            color: #9a9a9a;
            margin-bottom: 1rem;
        }
        .contact-card p {
            margin: 0 0 0.5rem;
            font-size: 1rem;
            color: #e0e0e0;
        }
        .delete-btn, .copy-btn {
            background-color: #FF4B4B;
            color: #121212;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        .copy-btn {
            background-color: #00C896;
            margin-right: 0.5rem;
        }
        .delete-btn:hover, .copy-btn:hover {
            transform: translateY(-2px);
        }
        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            cursor: pointer;
            color: #9ca3af;
            transition: all 0.3s ease;
        }
        .close-btn:hover {
            color: #FF9000;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">Contact Cloud</div>
    <button class="add-contact-btn" onclick="toggleForm()">Add Contact</button>
</div>

<div class="container">
    <div class="add-contact-form" id="addContactForm">
        <span class="close-btn" onclick="toggleForm()">&times;</span>
        <form method="post" action="addcontact">
            <input type="text" required name="username" placeholder="Enter Name">
            <input type="text" name="nickname" required placeholder="Enter Nickname">
            <input type="text" name="gender" required placeholder="Enter Gender (Male/Female)">
            <input type="text" name="location" required placeholder="Enter Location">
            <input type="number" name="contact" required placeholder="Enter Phone Number">
            <input type="submit" value="Add Contact">
        </form>
    </div>

    <div class="contacts-grid">
        <%
            try {
                Connection conn = DatabaseConnection.initializeDatabase();
                Statement stmt = conn.createStatement();
                String sql = "SELECT * FROM contacts";
                ResultSet rs = stmt.executeQuery(sql);

                while(rs.next()) {
                    String gender = rs.getString("Gender").toLowerCase();
                    String iconClass = gender.equals("male") ? "fas fa-user" : "fas fa-user-alt";
        %>
        <div class="contact-card">
            <div class="contact-image">
                <i class="<%= iconClass %>"></i>
            </div>
            <div class="contact-info">
                <div class="nickname"><%= rs.getString("Nickname") %></div>
                <div class="full-name"><%= rs.getString("Name") %></div>
                <p><strong>Contact:</strong> <%= rs.getString("ContactNumber") %></p>
                <p><strong>Gender:</strong> <%= rs.getString("Gender") %></p>
                <p><strong>Location:</strong> <%= rs.getString("Location") %></p>
                <button class="copy-btn" onclick="copyToClipboard('<%= rs.getString("ContactNumber") %>')">Copy Number</button>
                <form method="post" action="deletecontact" style="display: inline;">
                    <input type="hidden" name="contactNumber" value="<%= rs.getString("ContactNumber") %>">
                    <input type="submit" value="Delete" class="delete-btn">
                </form>
            </div>
        </div>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
    </div>
</div>

<script>
    function toggleForm() {
        const form = document.getElementById('addContactForm');
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }

    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(function() {
            alert('Contact number copied to clipboard');
        }, function(err) {
            console.error('Could not copy text: ', err);
        });
    }
</script>
</body>
</html>