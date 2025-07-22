-- creating table books 
DROP TABLE IF EXISTS BOOKS;

CREATE TABLE BOOKS (
	BOOK_ID SERIAL PRIMARY KEY,
	TITLE VARCHAR(100),
	AUTHOR VARCHAR(100),
	GENRE VARCHAR(100),
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);

SELECT
	*
FROM
	BOOKS;

-- creating table customers 
DROP TABLE IF EXISTS CUSTOMERS;

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	NAME VARCHAR(100),
	EMAIL VARCHAR(100),
	PHONE VARCHAR(15),
	CITY VARCHAR(50),
	COUNTRY VARCHAR(150)
);

SELECT
	*
FROM
	CUSTOMERS;

---- creating table orders
DROP TABLE IF EXISTS ORDERS;

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);

SELECT
	*
FROM
	ORDERS;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT
	*
FROM
	BOOKS
WHERE
	PUBLISHED_YEAR > '1950';

-- 3) List all customers from the Canada:
SELECT
	*
FROM
	CUSTOMERS
WHERE
	COUNTRY = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT
	*
FROM
	ORDERS
WHERE
	ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT
	SUM(STOCK) AS TOTAL_BOOKS
FROM
	BOOKS;

-- 6) Find the details of the most expensive book:
SELECT
	*
FROM
	BOOKS
WHERE
	PRICE = (
		SELECT
			MAX(PRICE)
		FROM
			BOOKS
	);

--or 
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT
	*
FROM
	ORDERS
WHERE
	QUANTITY > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT
	GENRE
FROM
	BOOKS;

-- 10) Find the book with the lowest stock:
SELECT
	*
FROM
	BOOKS
ORDER BY
	STOCK
LIMIT
	1;

-- 11) Calculate the total revenue generated from all orders:
SELECT
	*
FROM
	ORDERS;

SELECT
	SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM
	ORDERS;

-- Advance Questions : 
-- 1) Retrieve the total number of books sold for each genre:
SELECT
	*
FROM
	BOOKS;

SELECT
	B.GENRE,
	SUM(O.QUANTITY)
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	B.GENRE;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT
	AVG(PRICE) AS AVG_PRICE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
	-- 3) List customers who have placed at least 2 orders:
SELECT
	CUSTOMER_ID,
	COUNT(ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS
GROUP BY
	CUSTOMER_ID
HAVING
	COUNT(ORDER_ID) >= 2;

-- (Optional) To get customer names instead of just IDs:
SELECT
	O.CUSTOMER_ID,
	C.NAME,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	O.CUSTOMER_ID,
	C.NAME
HAVING
	COUNT(ORDER_ID) >= 2;

-- 4) Find the most frequently ordered book:
SELECT
	BOOK_ID,
	COUNT(ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS
GROUP BY
	BOOK_ID
ORDER BY
	ORDER_COUNT DESC
LIMIT
	1;

---- (Optional) To get book names instead of just IDs:
SELECT
	O.BOOK_ID,
	B.TITLE,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	O.BOOK_ID,
	B.TITLE
ORDER BY
	ORDER_COUNT DESC
LIMIT
	1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT
	B.AUTHOR,
	SUM(O.QUANTITY) AS TOTAL_BOOK_SOLD
FROM
	BOOKS B
	JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.AUTHOR;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT
	C.CITY,
	TOTAL_AMOUNT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE
	O.TOTAL_AMOUNT > 30;

-- 8) Find the customer who spent the most on orders:
SELECT
	C.CUSTOMER_ID,
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
	C.CUSTOMER_ID,
	C.NAME
ORDER BY
	TOTAL_SPENT DESC
LIMIT
	1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT
	B.BOOK_ID,
	B.TITLE,
	B.STOCK,
	COALESCE(SUM(O.QUANTITY), 0) AS ORDER_QUANTITY,
	B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_QUANTITY
FROM
	BOOKS B
	LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.BOOK_ID;