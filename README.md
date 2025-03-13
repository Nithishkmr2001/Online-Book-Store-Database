# Online Bookstore Database

## Overview

The **Online Bookstore Database** is a structured SQL schema designed to manage an e-commerce platform for books. It supports user management, book inventory, orders, payments, and reviews.

## Database Schema

### Tables

- **Users**: Stores customer and admin information.
- **Categories**: Defines book categories.
- **Books**: Contains book details.
- **Orders**: Tracks customer orders.
- **Order_Items**: Links books to orders.
- **Payments**: Handles payment transactions.
- **Reviews**: Stores user reviews and ratings.

## Setup Instructions

### Prerequisites

- MySQL installed on your system.
- A MySQL database management tool ( MySQL Workbench).

### Installation Steps

1. Open MySQL and create a new database and Tables

2. Verify that all tables are created
 
3. Import or insert the provided data into the database
  

## Usage

- Add users, books, and categories using SQL `INSERT` commands.
- Place orders and manage transactions.
- Store and retrieve customer reviews.

### Example Queries

**Retrieve all books in stock:**
```sql
SELECT * FROM Books WHERE stock_quantity > 0;
```

**Get all orders placed by a user:**
```sql
SELECT * FROM Orders WHERE user_id = 1;
```

**Find reviews for a specific book:**
```sql
SELECT * FROM Reviews WHERE book_id = 10;
```

## Views

### Book Details View
```sql
CREATE VIEW Book_details AS 
SELECT Books.book_id, Books.title, Books.author, Books.price, Books.stock_quantity, Categories.category_name 
FROM Books 
JOIN Categories ON Books.category_id = Categories.category_id 
ORDER BY RAND() LIMIT 10;
```

### Customer Order History View
```sql
CREATE VIEW customer_order_history AS 
SELECT Users.user_id, Users.name AS customer_name, Orders.order_id, Orders.order_date, 
Orders.total_amount, Orders.status 
FROM Users 
JOIN Orders ON Users.user_id = Orders.user_id;
```

### Fiction Books View
```sql
CREATE VIEW fiction_books AS 
SELECT Books.book_id, Books.title, Categories.category_name 
FROM Books 
JOIN Categories ON Books.category_id = Categories.category_id 
WHERE Categories.category_name = 'Fiction' ORDER BY RAND() LIMIT 5;
```

## Stored Procedures

### Get Customer Order Details using user id
```sql
DELIMITER //
CREATE PROCEDURE get_customer_orderdetails(IN user_id INT)
BEGIN
    SELECT Orders.order_id, Orders.order_date, Orders.total_amount
    FROM Orders WHERE Orders.user_id = user_id;
END //
DELIMITER ;
```
**Usage:**
```sql
CALL get_customer_orderdetails(888);
```

### Get Customer Order with Name
```sql
DELIMITER //
CREATE PROCEDURE get_customerorder_name(IN customer_id INT)
BEGIN
    SELECT Orders.order_id, Orders.order_date, Orders.total_amount, Users.name
    FROM Orders 
    JOIN Users ON Orders.user_id = Users.user_id
    WHERE Orders.user_id = customer_id;
END //
DELIMITER ;
```
**Usage:**
```sql
CALL get_customerorder_name(99);
```

### Add a New Book
```sql
DELIMITER //
CREATE PROCEDURE add_book(IN book_id INT, IN title VARCHAR(255), IN author VARCHAR(255), IN price NUMERIC(10,2), 
IN stock_quantity INT, IN category_id INT, IN description TEXT, IN publisher VARCHAR(255), IN publish_year YEAR)
BEGIN 
    INSERT INTO Books(book_id, title, author, price, stock_quantity, category_id, description, publisher, publish_year)
    VALUES (book_id, title, author, price, stock_quantity, category_id, description, publisher, publish_year);
END //
DELIMITER ;
```
**Usage:**
```sql
CALL add_book(1002, 'The Great Gatsby', 'F. Scott Fitzgerald', 15.99, 50, 2, 'A classic novel set in the Jazz Age.', 'Scribner', 1925);
```

