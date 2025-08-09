SELECT * FROM books	
SELECT * FROM branch	
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

-- PROJECT TASKS

-- CRUD OPERATIONS 

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO	 books(isbn,
					book_title,	
					category,	
					rental_price,	
					status,
					author,
					publisher)
VALUES('978-1-60129-456-2',
      'To Kill a Mockingbird',
       'Classic',
       6.00,
       'yes',
       'Harper Lee',
       'J.B. Lippincott & Co.')

SELECT * FROM books
WHERE isbn='978-1-60129-456-2'
SELECT * FROM books


-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address='125 Oak St'
WHERE member_id='C103'
SELECT * FROM members


-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE
FROM issued_status
WHERE issued_id='IS121'
SELECT * FROM issued_status

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM issued_status
WHERE issued_emp_id='E104'

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_emp_id
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1


-- CTAS(Create Table AS Select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_counts
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(*) AS total_count
FROM books AS b
INNER JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.book_title,b.isbn;


-- Data Analysis & Findings
-- The following SQL queries were used to address specific questions:

-- Task 7. Retrieve All Books in a Specific Category:

SELECT *
FROM books
WHERE category='Fiction';

-- Task 8: Find Total Rental Income by Category:

SELECT 
	b.category,
	SUM(b.rental_price),
	COUNT(issued_id)
FROM books AS b
INNER JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category

--Task 9: List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

--Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT e1.*,
	   e2.emp_name AS manager_name,
	   bh.manager_id
FROM branch AS bh
INNER JOIN employees AS e1
ON e1.branch_id = bh.branch_id
INNER JOIN employees AS e2
ON e2.emp_id=bh.manager_id


-- Task 11 Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE expensive_books 
AS
SELECT *
FROM books
WHERE rental_price>7.00;


SELECT * FROM expensive_books


--Task 12 Retrieve the List of Books Not Yet Returned

SELECT *
FROM issued_status AS i
LEFT JOIN return_status AS r
ON r.issued_id = i.issued_id
WHERE r.return_id IS NULL


-- Advanced Queries

SELECT * FROM books	
SELECT * FROM branch	
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM members
SELECT * FROM return_status

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.  

SELECT 
	m.member_id,
	m.member_name,
	b.book_title,
	i.issued_date,
	(CURRENT_DATE-i.issued_date) as overdue
FROM members AS m
JOIN issued_status AS i
ON m.member_id = i.issued_member_id
JOIN books AS b
ON b.isbn=i.issued_book_isbn
LEFT JOIN return_status AS r
ON r.issued_id=i.issued_id
WHERE r.return_date IS NULL AND (CURRENT_DATE-i.issued_date)>30


-- Task 14: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

CREATE TABLE branch_reports
AS
SELECT 
	br.branch_id,
	COUNT(ist.issued_id) AS No_of_Books_issued,
	COUNT(rt.return_id) AS no_of_books_returned,
	SUM(bk.rental_price) AS revenue_generated
FROM branch as br
INNER JOIN
employees AS e
ON br.branch_id=e.branch_id
INNER JOIN
issued_status AS ist
ON ist.issued_emp_id=e.emp_id
LEFT JOIN 
return_status AS rt
ON rt.issued_id=ist.issued_id
INNER JOIN
books AS bk
ON bk.isbn=ist.issued_book_isbn
GROUP BY br.branch_id;

SELECT * 
FROM branch_reports



-- Task 15: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.



CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;






