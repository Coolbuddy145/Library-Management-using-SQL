-- Library Management Syatem 

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
















































