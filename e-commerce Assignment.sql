drop database if exists e_commerce;

create database if not exists e_commerce;

use e_commerce;
-- ----------------------------
-- Table structure for `customers`
-- ----------------------------
create table customers (
customer_id integer auto_increment primary key,
customername varchar (100) not null,
contactname varchar (100) not null,
address varchar (500),
city varchar(100) not null,
postalcode varchar(500) not null,
country varchar(100)
);

-- ----------------------------
-- Table structure for `employees`
-- ----------------------------
create table employee (
employeeid integer auto_increment primary key,
First_name varchar (100) not null,
last_name varchar (100) not null,
Birthdate varchar (10000),
photo varchar (500) not null,
note varchar (500) not null
);
alter table employee
modify birthdate datetime default null;

alter table employee
modify photo longblob;

-- ----------------------------
-- Table structure for `categories`
-- ----------------------------

create table categories (
categories_id integer auto_increment primary key,
categories_name varchar (100) not null,
description varchar (1000) not null
);

-- ----------------------------
-- Table structure for `orderdetails`
-- ----------------------------

create table Orderdetails (
Orderdetailsid integer auto_increment primary key,
Orderid int,
Productid  int,
Quantity int,
constraint foreign key (orderid) references orders (orderid)
);
-- ----------------------------
-- Table structure for `orders`
-- ----------------------------
create table orders (
Orderid integer auto_increment primary key,
Customerid int(15) not null,
Employeeid int(15) not null,
orderdate varchar(1000) not null,
Shippersid int (50) not null,

constraint foreign key (customerid) references customers (customer_id),
constraint foreign key (employeeid) references employee (employeeid),
constraint foreign key(shippersid) references shippers (shipperid)
);
-- ----------------------------
-- Table structure for `product`
-- ----------------------------
create table products (
Productid integer auto_increment primary key,
productname varchar(100) not null,
supplierid  int,
categoryid int (100) not null,
unit varchar (500) not null,
price decimal(19,4) NOT NULL DEFAULT '0.0000'
);

-- ----------------------------
-- Table structure for `shippers`
-- ----------------------------
create table shippers (
Shipperid integer auto_increment primary key,
Shippername varchar (100) not null,
Phone varchar (24) default null
);

-- ----------------------------
-- Table structure for `suppliers`
-- ----------------------------
create table suppliers (
Supplierid integer auto_increment primary key,
Suppliername varchar (100) not null,
contactname varchar (100) not null,
Address varchar (500) not null,
City varchar (100) not null,
Postalcode varchar (50) not null,
Country varchar (50) not null,
Phone varchar (24) default null
);

-- ----------------------------
-- 1 Select customer name together with each order the customer made
-- ----------------------------
select distinct c.customername, p.productname
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid
order by customername desc;

-- ----------------------------
-- 2 Select orderid together with name of employee who handled the order
-- ----------------------------
select o.orderid, concat(first_name,last_name) as employeename
from orders as o
join employee as e on o.Employeeid = e.employeeid;

-- ----------------------------
-- 3 Select customers who did not placed any order yet
-- ----------------------------
select c.customername, od.Quantity
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
where Quantity = 0;


-- ----------------------------
-- 4 Select orderid together with the name of product
-- ----------------------------
select o.orderid, p.productname 
from products as p
join orderdetails as o on o.Productid =p.Productid;

-- ----------------------------
-- 5 Select product that no one brought
-- ----------------------------
select  p.productname, o.Quantity
from orderdetails as o
join products as p on o.Productid=p.Productid
where Quantity <=0 ;

-- ----------------------------
-- 6 select customer together with the product that he brought
-- ----------------------------
select c.customername, p.productname
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid;



-- ----------------------------
-- 7 select product name togther with the name of corresponding categories
-- ----------------------------
select p.productname, c.categories_name
from products as p
join categories as c on p.categoryid =c.categories_id;


-- ----------------------------
-- 8 select orders together with the shipping company
-- ----------------------------
select o.orderid,s.Shippername
from orders as o
join shippers as s on o.Shippersid = s.Shipperid;

-- ----------------------------
-- 9 select customers with the id greater than 50 together with each order they made
-- ----------------------------
select c.customer_id, p.productname
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid
where customer_id >50;

-- ----------------------------
-- 10 select employee together with orders id greater than 10400
-- ----------------------------
select e.employeeid, o.Orderid
from employee as e
join orders as o on e.employeeid = o.Employeeid
where Orderid > 10400;

-- ----------------------------
-- 11 select most expensive product
-- ----------------------------
select productname,price 
from products
order by price desc
limit 1;
-- ----------------------------
-- 12 select  the second most expensive product
-- ----------------------------
select productname,price from products
order by price desc
limit 1 offset 1;

-- ----------------------------
-- 13 select the name and price of each product,sort the result by price decreasing order
-- ----------------------------
select productname,price
from products
order by price desc;

-- ----------------------------
-- 14 select 5 most expensive product
-- ----------------------------
select productname,price from products
order by price desc
limit 5;

-- ----------------------------
-- 15 select most expensive product without the most expensive in the final 4 product
-- ----------------------------
select productname,price from products
order by price desc
limit 72 offset 4; 

-- ----------------------------
-- 16 select the name of the cheapest product(only name) without using limit and offset 
-- ----------------------------

-- ----------------------------
-- 17 select name of the cheapest product(only name) using subquery
-- ----------------------------
select productname from products
where price = (
select min(price)
from products
);
-- ----------------------------
-- 18 select number of employee with lastname that start with "D"
-- ----------------------------
select count(last_name)
from employee
where last_name like "D%";

-- ----------------------------
-- 19 Select customer name togther with the numbers of orders made by the corresponding customer,sort the result by the number of orders by decending order
-- ----------------------------
 select c.customername, od.quantity
 from customers as c
 join orders as o on c.customer_id = o.Customerid
 inner join orderdetails as od on od.Orderid = o.Orderid
 order by Quantity desc;

-- ----------------------------
-- 20 add up the price of all products
-- ----------------------------
select sum(price) from products;

-- ----------------------------
-- 21 select orderid together with the total price of that order.order the result by total price of order in increasing order 
-- ----------------------------
select o.Orderid, p.price
from products as p
join orderdetails as o on o.Productid = p.Productid
order by price asc;

-- ----------------------------
-- 22 select customer who spend the most money 
-- ----------------------------
select customername, p.price
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid
order by price desc
limit 1;
 - ----------------------------
-- 23  select customer who spend the most money and lives in canada
-- ----------------------------
select c.customername,c.country, p.price
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid
where country like "%canada%"
order by PRICE desc
limit 1;


-- ----------------------------
-- 25 select shipper together with the total price of proceed orders
-- ----------------------------
select s.Shippername, p.price
from shippers as s
join orders as o on o.Shippersid = s.Shipperid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on p.Productid = od.Productid
order by price desc;
 
- ----------------------------
-- 1 Total numer of product so far
-- ----------------------------
select sum(Quantity) from orderdetails;

- ----------------------------
-- 2 Total revenue so far
-- ----------------------------
select sum(price) from products;

- ----------------------------
-- 3 total unique products sold on category
-- ----------------------------
select count(categories_name) from categories;

- ----------------------------
-- 4 Total number of purchase transaction from customer
-- ----------------------------
select sum(Quantity) from orderdetails;

- ----------------------------
-- 5 compare orders made between 2022 and 2023
-- ----------------------------
select *
from orders
where year(orderdate) = 2022 or year(orderdate) = 2023;

- ----------------------------
-- 6 What is total number of customers, compare those that have made travsaction and those that have not 
-- ----------------------------
select count(customer_id) from customers;

- ----------------------------
-- 7 Who are the top 5 customers with the highest purchase value
-- ----------------------------
select c.customername,p.price
from customers as c
join orders as o on c.customer_id = o.Customerid
join orderdetails as od on od.Orderid = o.Orderid
join products as p on od.Productid = p.Productid
order by price desc
limit 5;

- ----------------------------
-- 8 Top 5 best selling product
-- ----------------------------
select productname from products
order by price desc
limit 5; 

- ----------------------------
-- 9 What is the transaction value per month
-- ----------------------------
 select distinct month(o.orderdate) As month, sum(p.price) As totalprice
 from orders as o
 join orderdetails as od on o.Orderid = od.Orderid
 join products as p on p.Productid = od.Productid
 group by month(o.orderdate);
 
 
 
- ----------------------------
-- 10 Best selling  product categories
-- ----------------------------
select c.categories_name as productcategory , count( Quantity) as Quantity
from products as p
join orderdetails as od on p.Productid =p.Productid
join categories as c on c.categories_id = p.categoryid
group by categories_name
order by Quantity desc;
- ----------------------------
-- 11 Buyers who have transacted more than two times 
-- ----------------------------


- ----------------------------
-- 12 select the second most expensive product  
-- ----------------------------
select productname, price
from products
order by price desc
limit 1 offset 1;
- ----------------------------
-- 13 select name and price of each product, sort the result by price in decreasing order
-- ----------------------------
select productname, price
from products
order by price desc;
- ----------------------------
-- 14 select 5 most expensive product
-- ----------------------------
select productname, price
from products
order by price desc
limit 5;