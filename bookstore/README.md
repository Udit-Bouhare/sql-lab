📚 Bookstore Management System (MySQL Project)
📖 Overview

This project implements a Bookstore Management Database in MySQL.
It includes a complete schema, sample data, and advanced SQL features such as views, procedures, triggers, transactions, indexing, and functions.

🗄️ Features

Database Schema: Books, Customers, Orders, Order_Items, Admins

Sample Data: Preloaded for testing queries

Stored Procedures: Order processing, stock updates with rollback handling

Triggers: Auto stock deduction after purchase

Functions: Discount calculation

Transactions: Safe inserts with commit/rollback

Views: Order summary with customer details

Indexes: Faster queries on customer emails

⚙️ How to Run

Clone this repository

Open MySQL and run:

SOURCE schema.sql;
SOURCE procedures.sql;
SOURCE queries.sql;


Use sample queries to test the database

📊 Example Queries

Get order summary by customer

Get top-selling books by category

Check stock before/after placing an order

Apply discount using a custom SQL function

🚀 Future Enhancements

Reporting queries (sales, revenue, customers)

Integration with front-end (PHP/Python/Node.js)

Advanced role-based access

👉 This project demonstrates real-world database design & management skills with MySQL.
