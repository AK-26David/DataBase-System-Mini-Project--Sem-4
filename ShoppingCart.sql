
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
VALUES (1, 'Laptop', 799.99, 15);

-- Sample data for Customer table
INSERT INTO Customers (id, name, email)
VALUES (1, 'John Doe', 'john.doe@example.com');

-- Sample data for ShoppingCart table
INSERT INTO ShoppingCart (id, customer_id, creation_date)
VALUES (1, 1, SYSDATE);

-- Sample data for CartItem table
INSERT INTO CartItem (id, cart_id, product_id, quantity)
VALUES (1, 1, 1, 1);

-- Sample data for OrderTable table
INSERT INTO OrderTable (id, customer_id, order_date, total_amount)
VALUES (1, 1, SYSDATE, 799.99);

-- Sample data for OrderItem table
INSERT INTO OrderItem (id, order_id, product_id, quantity)
VALUES (1, 1, 1, 1);