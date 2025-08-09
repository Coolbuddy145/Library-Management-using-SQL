# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/Coolbuddy145/Library-Management-using-SQL/blob/f041dd186d162df4d4f1034d3b64213afd38a412/Lib_img.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/Coolbuddy145/Library-Management-using-SQL/blob/ad1a4f8c8200c77b7288ffd5e81e48a372e8d2fd/ERD.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE Library_Database;



-- Creating Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
					branch_id VARCHAR(10) PRIMARY KEY, 	
					manager_id	VARCHAR(10),
					branch_address VARCHAR(50),	
					contact_no VARCHAR(20)
);



-- Creating Employees Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
						emp_id	VARCHAR(10) PRIMARY KEY,
						emp_name VARCHAR(20),	
						position VARCHAR(25),	
						salary	INT,
						branch_id VARCHAR(10)
)

-- Creating Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books(
					isbn VARCHAR(20) PRIMARY KEY,
					book_title VARCHAR(80),	
					category VARCHAR(20),	
					rental_price FLOAT,	
					status VARCHAR(10),
					author VARCHAR(40),
					publisher VARCHAR(55)

) 

-- Creating Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members(
					  member_id	VARCHAR(10) PRIMARY KEY,
					  member_name VARCHAR(25),	
					  member_address VARCHAR(35),	
					  reg_date DATE
)


-- Creating Issued_Status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
							issued_id VARCHAR(10) PRIMARY KEY,	
							issued_member_id VARCHAR(10),	
							issued_book_name VARCHAR(80),	
							issued_date DATE,
							issued_book_isbn VARCHAR(30),	
							issued_emp_id VARCHAR(10)

) 

-- Creating Return_Status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
							return_id VARCHAR(10) PRIMARY KEY,	
							issued_id VARCHAR(10),	
							return_book_name VARCHAR(80),  	
							return_date	DATE,
							return_book_isbn VARCHAR(20)
)


-- Adding Foreign Keys

ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_status_members  
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id)


ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_status_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn)

	
ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_status_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id)


ALTER TABLE return_status
ADD CONSTRAINT fk_return_status_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id)


ALTER TABLE employees
ADD CONSTRAINT fk_employees_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
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
       'J.B. Lippincott & Co.');
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address='125 Oak St'
WHERE member_id='C103'
SELECT * FROM members;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE
FROM issued_status
WHERE issued_id='IS121'
SELECT * FROM issued_status;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT *
FROM issued_status
WHERE issued_emp_id='E104';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT issued_emp_id
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1;

```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
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
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT *
FROM books
WHERE category='Fiction';

```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	b.category,
	SUM(b.rental_price),
	COUNT(issued_id)
FROM books AS b
INNER JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT e1.*,
	   e2.emp_name AS manager_name,
	   bh.manager_id
FROM branch AS bh
INNER JOIN employees AS e1
ON e1.branch_id = bh.branch_id
INNER JOIN employees AS e2
ON e2.emp_id=bh.manager_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE expensive_books 
AS
SELECT *
FROM books
WHERE rental_price>7.00;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT *
FROM issued_status AS i
LEFT JOIN return_status AS r
ON r.issued_id = i.issued_id
WHERE r.return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
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
WHERE r.return_date IS NULL AND (CURRENT_DATE-i.issued_date)>30;
```



**Task 14: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
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
```

**Task 15: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

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

```






## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


