/*
This file contains a script of Transact SQL (T-SQL) command to interact with a database named 'Inventory'.
Requirements:
- SQL Server 2022 is installed and running
- referential integrity is enforced
- The script should be idempotent, meaning it can be run multiple times without causing errors or duplicating data
Details:
- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
- Set the default database to 'Inventory'.
- Create a 'suppliers' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- address: 255 characters, nullable
-- city: 50 characters, not null
-- state: 2 characters, not null
- Create the 'categories' table with a one-to-many relation to the 'suppliers'. Use the following columns:
-- id:  integer, primary key
-- name: 50 characters, not null
-- description:  255 characters, nullable
-- supplier_id: int, foreign key references suppliers(id)
- Create the 'products' table with a one-to-many relation to the 'categories' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- price: decimal (10, 2), not null
-- category_id: int, foreign key references categories(id)
- Populate the 'suppliers' table with sample data.
- Populate the 'categories' table with sample data.
- Populate the 'products' table with sample data.
- Create a view named 'product_list' that displays the following columns:
-- product_id
-- product_name
-- category_name
-- supplier_name
- Create a stored procedure named 'get_product_list' that returns the product list view.
- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
- Create a function that returns the total number of products in a category.
- Create a function that returns the total number of products supplied by a supplier.
*/

-- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Inventory')    
    DROP DATABASE Inventory;
GO

-- Create a new database named 'Inventory'
CREATE DATABASE Inventory;
GO

-- Set the default database to 'Inventory'

USE Inventory;
GO

-- Create a 'suppliers' table
CREATE TABLE suppliers (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL
);

-- Create the 'categories' table with a one-to-many relation to the 'suppliers'
CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Create the 'products' table with a one-to-many relation to the 'categories' table
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    -- Add a column that represents the creation date of the product
    created_at DATETIME DEFAULT GETDATE(),
    -- Add a column that represents the last update date of the product
    updated_at DATETIME DEFAULT GETDATE()
);

-- Populate the 'suppliers' table with sample data
INSERT INTO suppliers (id, name, address, city, state)
VALUES (1, 'Supplier 1', '123 Main St', 'City 1', 'NY'),
       (2, 'Supplier 2', '456 Elm St', 'City 2', 'CA');

-- Populate the 'categories' table with sample data
INSERT INTO categories (id, name, description, supplier_id)
VALUES (1, 'Category 1', 'Category 1 Description', 1),
       (2, 'Category 2', 'Category 2 Description', 2);

-- Populate the 'products' table with sample data
INSERT INTO products (id, name, price, category_id)
VALUES (1, 'Product 1', 10.00, 1),
       (2, 'Product 2', 20.00, 1),
       (3, 'Product 3', 30.00, 2);

-- Create a view named 'product_list' that displays the following columns
CREATE VIEW product_list AS
SELECT p.id AS product_id,
       p.name AS product_name,
       c.name AS category_name,
       s.name AS supplier_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON c.supplier_id = s.id;

-- Create a stored procedure named 'get_product_list' that returns the product list view
CREATE PROCEDURE get_product_list
AS
BEGIN
    SELECT * FROM product_list;
END;

-- Create a trigger that updates the 'products' table when a 'categories' record is deleted
CREATE TRIGGER update_products_on_category_delete
ON categories
AFTER DELETE
AS
BEGIN
    DELETE FROM products
    WHERE category_id IN (SELECT id FROM deleted);
END;

-- Create a function that returns the total number of products in a category
CREATE FUNCTION get_total_products_in_category (@category_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*)
    FROM products
    WHERE category_id = @category_id;
    RETURN @total_products;
END;



