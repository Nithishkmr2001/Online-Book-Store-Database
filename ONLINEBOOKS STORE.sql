-- creating a database --

create schema OnlineBookStore;
use onlinebookstore;
-----------------------------------------------------------------------------------------------------------------------------------------------------
  -- creating  tables --
  
  -- 1. creating users table --
create table Users(
user_id int primary key,
name varchar (255),
email varchar(255) not null,
password varchar(255) not null,
phone varchar(25),
address text,
role enum('Customer','Admin') not null);
  
-- 2.creating categories table --
create table Categories(
category_id int primary key,
category_name varchar(255) not null);
  
-- 3.creating Books table --
create table Books(
book_id int primary key,
title varchar(255) not null,
author varchar(255),
price numeric(10,2),
stock_quantity int,
category_id int,
description text,
publisher varchar(255),
publish_year year,
foreign key(category_id) references Categories(category_id));
  
-- 4.creating Orders table --
create table Orders(order_id int primary key,
user_id int,
order_date date,
total_amount numeric(10,2),
status enum('Pending','Shipped','Delivered','Cancelled') not null,
foreign key (user_id) references Users(user_id));
  
-- 5.creating Order items table --
create table Order_items(order_item_id int primary key,
order_id int,
book_id int,
quantity int,
subtotal numeric(10,2),
foreign key (order_id) references Orders(order_id),
foreign key (book_id) references Books(book_id));
  
-- 6.creating Payments table --
create table Payments(payment_id int primary key,
order_id int,
payment_date date,
payment_method enum('Credit card','Paypal','Debit card','Bitcoin') not null,
status enum('Successful','Failed','Pending') not null,
foreign key(order_id)references Orders(order_id));
  
-- 7.creating review table --
create table Reviews(review_id int primary key,
user_id int,
book_id int,
rating int check(rating between 1 and 5),
comments text,
review_date date,
foreign key(user_id) references Users(user_id),
foreign key(book_id) references Books(book_id));
--------------------------------------------------------------------------------------------------------------------------------------------------- 
  -- inserted values to the tables using table data import wizard --
----------------------------------------------------------------------------------------------------------------------------------------------------
-- creating view for book details:
create view Book_details as 
select Books.book_id,Books.title,Books.author,Books.price,Books.stock_quantity,Categories.category_name
from Books join Categories on Books.category_id = Categories.category_id order by rand() limit 10;  

select category_name,count(category_name) as Total from Book_details group by Category_name ;

-- view for customer order histoy:
create view customer_order_history as 
select Users.user_id,Users.name as customer_name,Orders.order_id,Orders.order_date,
Orders.total_amount,Orders.status 
from Users join Orders on Users.user_id= Orders.user_id;

select sum(total_amount) as Total_Amount ,customer_name,status,user_id from customer_order_history 
where status='Delivered'and total_amount between 485 and 490 group by order_id limit 10;

-- books under category fiction
create view fiction_books as
select Books.book_id,Books.title,Categories.category_name
from Books join categories on Books.category_id=categories.category_id
where Categories.category_name = 'Fiction' order by rand(Books.title) limit 5 ;

select distinct title as Books_Title from fiction_books;


-- view for customer order histoy by Customer_name:
create view Orders_by_Customername as
select*from customer_order_history where customer_name="Mary Rogers";
---------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- Stored Procedures --
 -- stored procedures in single tables with [IN Parameters] --
 -- getting orders of customer using user id
 delimiter //
 create procedure get_customer_orderdetails(in user_id int)
 begin
	select Orders.order_id,Orders.order_date,Orders.total_amount
    from Orders where Orders.user_id=user_id ;
    end //
    delimiter ;
 call get_customer_orderdetails(888);


-- stored procedures in  multiple tables with [IN Parameters] --

delimiter //
 create procedure get_customerorder_name(in customer_id int)
 begin
	select Orders.order_id,Orders.order_date,Orders.total_amount,Users.name
    from Orders join Users on Orders.user_id = Users.user_id
    where Orders.user_id= customer_id;
     end //
    delimiter ;
call get_customerorder_name(99);
drop procedure get_customerorder_name;

-- stored procedure adding new book to the table
delimiter //
create procedure add_book(in book_id int,in title varchar(255),
in author varchar(255), in price numeric(10,2), in stock_quantity int,
in category_id int, in description text,in publisher varchar(255),
in publish_year year) 
begin 
insert into Books(book_id,title,author,price,stock_quantity,category_id,description,publisher,publish_year)
values(book_id,title,author,price,stock_quantity,category_id,description,publisher,publish_year);
end//
delimiter ;
call add_book(1002, 'The Great Gatsby', 'F. Scott Fitzgerald', 15.99, 50, 2, 'A classic novel set in the Jazz Age.', 'Scribner', 1925);


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
