DROP DATABASE star;
CREATE DATABASE star;
\c star;

CREATE TABLE fact_table (
employee_number INTEGER REFERENCES employee_logs(employee_number),
office_code INTEGER REFERENCES office_logs(office_code),
customer_number INTEGER REFERENCES customer_logs(customer_number),
order_number INTEGER REFERENCES order_logs(order_number),
sales_rep_employee_number INTEGER REFERENCES employee_logs(employee_number),
product_code VARCHAR REFERENCES product_logs(product_code),
quantity_in_stock INTEGER,
buy_price FLOAT,
_m_s_r_p FLOAT,
quantity_ordered INTEGER NOT NULL,
price_each FLOAT NOT NULL,
order_line_number INTEGER,
credit_limit INTEGER,
profit FLOAT,
revenue FLOAT, 
margin FLOAT,
day INTEGER,
quarter INTEGER
);


CREATE TABLE employee_logs (
employee_number INTEGER PRIMARY KEY,
last_name VARCHAR NOT NULL,
first_name VARCHAR NOT NULL,
reports_to VARCHAR,
job_title VARCHAR
);

CREATE TABLE office_logs (
office_code INTEGER PRIMARY KEY,
city VARCHAR NOT NULL,
state VARCHAR,
country VARCHAR NOT NULL,
);

CREATE TABLE order_logs (
order_number INTEGER PRIMARY KEY,
status VARCHAR,
comments VARCHAR,
required_date DATE,
shipped_date DATE,
order_date DATE,
order_quarter INTEGER,
order_day INTEGER
);

CREATE TABLE customer_logs (
customer_number INTEGER PRIMARY KEY,
customer_name VARCHAR NOT NULL,
contact_last_name VARCHAR,
contact_first_name VARCHAR,
city VARCHAR,
state VARCHAR,
country VARCHAR,
);

CREATE TABLE product_logs (
product_code VARCHAR PRIMARY KEY,
product_line VARCHAR NOT NULL,
product_name VARCHAR,
product_scale VARCHAR,
product_vendor VARCHAR,
html_description VARCHAR
);
