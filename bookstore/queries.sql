/* ================================================
   MySQL Project - Bookstore Database
   ================================================ */

/* ------------------------------
   Query 1: Customer Order Summary
   ------------------------------ */
SELECT 
    c.name, 
    o.order_id, 
    o.order_date, 
    SUM(oi.subtotal) AS Total_price
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON oi.order_id = o.order_id 
GROUP BY o.order_id;



/* ------------------------------
   Query 2: Book Sales by Category
   ------------------------------ */
SELECT 
    b.title, 
    b.category, 
    SUM(oi.quantity) AS total_sold
FROM Books b
JOIN Order_Items oi 
    ON b.book_id = oi.book_id
GROUP BY b.category, b.book_id
ORDER BY total_sold DESC; 



/* ------------------------------
   Stored Procedure: ProcessOrders
   ------------------------------ */
DELIMITER $$

CREATE PROCEDURE ProcessOrders(IN cust_id INT, IN book_id INT, IN qty INT)
BEGIN
   DECLARE book_price DECIMAL(10,2);  
   DECLARE total DECIMAL(10,2); 

   -- Get price of the specific book
   SELECT price INTO book_price
   FROM Books
   WHERE Books.book_id = book_id
   LIMIT 1;  

   -- Calculate total
   SET total = book_price * qty;

   -- Insert order
   INSERT INTO Orders(customer_id, order_date, total_amount, status)
   VALUES (cust_id, NOW(), total, 'Pending');
END$$

DELIMITER ;



/* ------------------------------
   Trigger: Reduce Stock After Order
   ------------------------------ */
DELIMITER $$

CREATE TRIGGER reduce_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
   UPDATE Books
   SET stock = stock - NEW.quantity
   WHERE book_id = NEW.book_id;
END$$

DELIMITER ;



/* ------------------------------
   Transaction Example
   ------------------------------ */
START TRANSACTION;

INSERT INTO Orders(customer_id, order_date, total_amount, status)
VALUES (1, NOW(), 150.00, 'Pending');

INSERT INTO Order_Items(order_id, book_id, quantity, subtotal)
VALUES (LAST_INSERT_ID(), 2, 3, 150.00);

COMMIT;



/* ------------------------------
   Stored Procedure: Update Book Stock (v2)
   ------------------------------ */
DELIMITER //

CREATE PROCEDURE update_book_stock_v2(IN bookID INT, IN qty INT)
BEGIN
    -- Error handler: rollback if any SQL error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transaction failed and rolled back' AS message;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Deduct stock
    UPDATE Books 
    SET stock = stock - qty 
    WHERE book_id = bookID;

    -- Check if stock went below 0
    IF (SELECT stock FROM Books WHERE book_id = bookID) < 0 THEN
        ROLLBACK; -- Undo transaction
        SELECT 'Not enough stock, rollback performed' AS message;
    ELSE
        COMMIT; -- Make changes permanent
        SELECT 'Stock updated successfully' AS message;
    END IF;
END;
//

DELIMITER ;



/* ------------------------------
   Index Creation
   ------------------------------ */
CREATE INDEX idx_coustomer_email ON Customers(email);



/* ------------------------------
   Query Optimization Example
   ------------------------------ */
EXPLAIN 
SELECT * 
FROM Orders 
WHERE customer_id = 5;



/* ------------------------------
   View: Order Summary
   ------------------------------ */
CREATE VIEW OrderSummary AS
SELECT 
    o.order_id,
    c.name,
    o.order_date,
    o.total_amount,
    o.status
FROM Orders o
JOIN Customers c 
    ON o.customer_id = c.customer_id;

SELECT * FROM OrderSummary;



/* ------------------------------
   Function: Calculate Discount
   ------------------------------ */
DELIMITER $$

CREATE FUNCTION Calculate_Discount(amount DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	RETURN amount * 0.10; -- 10% Discount
END$$

DELIMITER ;

-- Function Test
SELECT Calculate_Discount(500);



/* ------------------------------
   User Management
   ------------------------------ */
CREATE USER 'udit'@'localhost' IDENTIFIED BY 'StrongPass123';

GRANT SELECT, INSERT 
ON Bookstore TO 'udit'@'localhost';

REVOKE SELECT 
ON Bookstore FROM 'udit'@'localhost';


