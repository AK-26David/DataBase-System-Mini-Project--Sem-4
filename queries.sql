Find customers who have purchased a specific product:

SELECT DISTINCT c.id, c.name, c.email
FROM Customers c
JOIN OrderTable ot ON c.id = ot.customer_id
JOIN OrderItem oi ON ot.id = oi.order_id
JOIN Product p ON oi.product_id = p.id
WHERE p.name = 'Laptop'; -- Replace 'Laptop' with desired product name


Retrieve the latest order date for each customer:

SELECT c.id, c.name, MAX(ot.order_date) AS latest_order_date
FROM Customers c
LEFT JOIN OrderTable ot ON c.id = ot.customer_id
GROUP BY c.id, c.name;

Calculate the total revenue generated from each product:

SELECT p.id, p.name, SUM(ot.total_amount) AS total_revenue
FROM Product p
LEFT JOIN OrderItem oi ON p.id = oi.product_id
LEFT JOIN OrderTable ot ON oi.order_id = ot.id
GROUP BY p.id, p.name
ORDER BY total_revenue DESC;


Identify customers with incomplete shopping carts (created but not ordered):

SELECT c.id, c.name, c.email
FROM Customers c
JOIN ShoppingCart sc ON c.id = sc.customer_id
LEFT JOIN OrderTable ot ON c.id = ot.customer_id
WHERE ot.customer_id IS NULL;


List customers who have ordered more than once:

SELECT c.id, c.name, c.email, COUNT(ot.id) AS order_count
FROM Customers c
JOIN OrderTable ot ON c.id = ot.customer_id
GROUP BY c.id, c.name, c.email
HAVING COUNT(ot.id) > 1;

Retrieve the top 3 customers with the highest total spending:

SELECT c.id, c.name, c.email, SUM(ot.total_amount) AS total_spent
FROM Customers c
JOIN OrderTable ot ON c.id = ot.customer_id
GROUP BY c.id, c.name, c.email
ORDER BY total_spent DESC
LIMIT 3;

Union of Customer Emails from Orders and Shopping Carts:

SELECT email
FROM Customers
WHERE id IN (
    SELECT customer_id FROM OrderTable
    UNION
    SELECT customer_id FROM ShoppingCart
);


Intersection of Customers who have Ordered and have Items in Shopping Cart:

SELECT id, name, email
FROM Customers
WHERE id IN (
    SELECT customer_id FROM OrderTable
    INTERSECT
    SELECT customer_id FROM ShoppingCart
);


Check if a Product is in Orders:

SELECT *
FROM Product
WHERE id IN (
    SELECT DISTINCT product_id FROM OrderItem
);


Compare Customers who Ordered and have Items in Shopping Cart:

SELECT id, name, email
FROM Customers
WHERE id IN (
    SELECT customer_id FROM OrderTable
)
AND id IN (
    SELECT customer_id FROM ShoppingCart
);

Check if OrderTable is Empty:

SELECT CASE WHEN COUNT(*) > 0 THEN 'Not Empty' ELSE 'Empty' END AS table_status
FROM OrderTable;

Check if a Customer has Empty Shopping Cart:

SELECT id, name, email
FROM Customers
WHERE id NOT IN (
    SELECT DISTINCT customer_id FROM ShoppingCart
);


