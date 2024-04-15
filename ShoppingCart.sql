
drop table OrderItem;
drop table OrderTable;
drop table CartItem;
drop table ShoppingCart;
drop table Customers;
drop table Product;


CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE ShoppingCart (
    id INT PRIMARY KEY,
    customer_id INT,
    creation_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

CREATE TABLE CartItem (
    id INT PRIMARY KEY,
    cart_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (cart_id) REFERENCES ShoppingCart(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);

CREATE TABLE OrderTable (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

CREATE TABLE OrderItem (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES OrderTable(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);

-- Sample data for Product table
INSERT INTO Product (id, name, price, quantity)
INSERT INTO VALUES (1, 'Laptop', 799.99, 15);
INSERT INTO VALUES (2, 'Smartphone', 489.90, 25);
INSERT INTO VALUES (3, 'Tablet', 299.50, 20);
INSERT INTO VALUES (4, 'Mouse', 25.00, 50);
INSERT INTO VALUES (5, 'Keyboard', 49.99, 30);
INSERT INTO VALUES (6, 'Headphones', 79.99, 40);


-- Sample data for Customer table
INSERT INTO Customers (id, name, email)
INSERT INTO VALUES (1, 'John Doe', 'john.doe@example.com');
INSERT INTO VALUES (2, 'Jane Smith', 'jane.smith@example.com');
INSERT INTO VALUES (3, 'Michael Johnson', 'michael.johnson@example.com');
INSERT INTO VALUES (4, 'Emily Brown', 'emily.brown@example.com');
INSERT INTO VALUES (5, 'Chris Wilson', 'chris.wilson@example.com');


-- Sample data for ShoppingCart table
INSERT INTO ShoppingCart (id, customer_id, creation_date)
INSERT INTO VALUES (1, 1, SYSDATE);
INSERT INTO VALUES (2, 2, SYSDATE);
INSERT INTO VALUES (3, 3, SYSDATE);
INSERT INTO VALUES (4, 4, SYSDATE);
INSERT INTO VALUES (5, 5, SYSDATE);


-- Sample data for CartItem table
INSERT INTO CartItem (id, cart_id, product_id, quantity)
INSERT INTO VALUES (1, 1, 1, 1);
INSERT INTO VALUES (2, 1, 2, 2);
INSERT INTO VALUES (3, 1, 3, 1);
INSERT INTO VALUES (4, 2, 4, 3);
INSERT INTO VALUES (5, 2, 5, 1);
INSERT INTO VALUES (6, 3, 1, 2);
INSERT INTO VALUES (7, 3, 4, 1);
INSERT INTO VALUES (8, 4, 2, 1);
INSERT INTO VALUES (9, 5, 3, 2);
INSERT INTO VALUES (10, 5, 5, 1);


-- Sample data for OrderTable table
INSERT INTO OrderTable (id, customer_id, order_date, total_amount)
INSERT INTO VALUES (1, 1, SYSDATE, 799.99);
INSERT INTO VALUES (2, 2, SYSDATE, 999.99);
INSERT INTO VALUES (3, 3, SYSDATE, 499.98);
INSERT INTO VALUES (4, 4, SYSDATE, 99.99);
INSERT INTO VALUES (5, 5, SYSDATE, 149.97);


-- Sample data for OrderItem table
INSERT INTO OrderItem (id, order_id, product_id, quantity)
INSERT INTO VALUES (1, 1, 1, 1);
INSERT INTO VALUES (2, 1, 2, 2);
INSERT INTO VALUES (3, 1, 3, 1);
INSERT INTO VALUES (4, 2, 4, 3);
INSERT INTO VALUES (5, 2, 5, 1);
INSERT INTO VALUES (6, 3, 1, 2);
INSERT INTO VALUES (7, 3, 4, 1);
INSERT INTO VALUES (8, 4, 2, 1);
INSERT INTO VALUES (9, 5, 3, 2);
INSERT INTO VALUES (10, 5, 5, 1);
