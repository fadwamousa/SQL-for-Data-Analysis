CREATE TABLE Manufacturers (
  Code INTEGER PRIMARY KEY,
  Name VARCHAR(255) NOT NULL
);

---------------------------------------------------------------------
CREATE TABLE Products (
  Code INTEGER,
  Name VARCHAR(255) NOT NULL ,
  Price DECIMAL NOT NULL ,
  Manufacturer INTEGER NOT NULL,
  PRIMARY KEY (Code), 
  FOREIGN KEY (Manufacturer) REFERENCES Manufacturers(Code)
) 
---------------------------------------------------------------------
INSERT INTO Manufacturers(Code,Name) VALUES(1,'Sony');
INSERT INTO Manufacturers(Code,Name) VALUES(2,'Creative Labs');
INSERT INTO Manufacturers(Code,Name) VALUES(3,'Hewlett-Packard');
INSERT INTO Manufacturers(Code,Name) VALUES(4,'Iomega');
INSERT INTO Manufacturers(Code,Name) VALUES(5,'Fujitsu');
INSERT INTO Manufacturers(Code,Name) VALUES(6,'Winchester');

INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(1,'Hard drive',240,5);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(2,'Memory',120,6);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(3,'ZIP drive',150,4);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(4,'Floppy disk',5,6);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(5,'Monitor',240,1);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(6,'DVD drive',180,2);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(7,'CD drive',90,2);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(8,'Printer',270,3);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(9,'Toner cartridge',66,3);
INSERT INTO Products(Code,Name,Price,Manufacturer) VALUES(10,'DVD burner',180,2);
--------------------------------------------------------------------------------------
-- 1.1 Select the names of all the products in the store.
select Name from Products
---------------------------------------------------------------------------------------------
-- 1.2 Select the names and the prices of all the products in the store.
select Name,Price from Products
---------------------------------------------------------------------------------------------------
-- 1.3 Select the name of the products with a price less than or equal to $200.
select name,price from Products
where price <= 200
-----------------------------------------------------------------------------------------------
-- 1.4 Select all the products with a price between $60 and $120.
select * from Products where price between 60 and 120
---------------------------------------------------------------------------------------------
-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select name,price * 100 as Price_Cents from Products
----------------------------------------------------------------------------------------------
-- 1.6 Compute the average price of all the products.
select avg(price) from Products
-----------------------------------------------------------------------------------------------
-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
select * from Products

select avg(price) from Products where Manufacturer = 2
------------------------------------------------------------------------------------------------
-- 1.8 Compute the number of products with a price larger than or equal to $180.
select count(*) from Products where price >= 180
---------------------------------------------------------------------------------------------
--1.9 Select the name and price of all products 
--with a price larger than or equal to $180, 
--and sort first by price (in descending order), 
--and then by name (in ascending order).

select name,price from Products
where Price >= 180
order by price desc,name asc
-----------------------------------------------------------------------------------------
--1.10 Select all the data from the products, 
--including all the data for each product's manufacturer

select count(*),Products.Name from Products
inner join Manufacturers
on Manufacturers.Code = Products.Manufacturer
group by Manufacturers.Code,Products.Name

select * from Manufacturers
----------------------------------------------------------------------------------------------------
--1.11 Select the product name, price, and manufacturer name of all the products.
select Products.Name,Products.Price,Manufacturers.Name from Products
inner join Manufacturers
on Manufacturers.Code = Products.Manufacturer
-------------------------------------------------------------------------------------------
--1.12 Select the average price of each manufacturer's products, 
--showing only the manufacturer's code
select avg(price) as Price,Manufacturers.Code,Manufacturers.Name from Products
inner join Manufacturers
on Manufacturers.Code = Products.Manufacturer
group by Manufacturers.Code,Manufacturers.Name 

SELECT AVG(Price), Manufacturer
    FROM Products
GROUP BY Manufacturer;
-----------------------------------------------------------------------------------------------
--1.14 Select the names of manufacturer whose products have an average price 
--larger than or equal to $150.

select Manufacturers.Code,Manufacturers.Name from Products
inner join Manufacturers
on Manufacturers.Code = Products.Manufacturer
group by Manufacturers.Code,Manufacturers.Name
having avg(price) >150

-------------------------------------------------------------------------------------------
-- 1.15 Select the name and price of the cheapest product.
select top(1)name,Price from Products
order by price asc

select name,price from Products
where price = (select min(price) from Products)
-------------------------------------------------------------------------------------------------
--1.16 Select the name of each manufacturer along with the name and price 
--of its most expensive product

select * from (
select Products.Name as PN,
       Products.Price,
	   Manufacturers.Name as MN,
	   DENSE_RANK() over(order by Products.Price desc) as DR
FROM Products
inner join Manufacturers
on Manufacturers.Code = Products.Manufacturer
) as t
--order by Products.Price DESC
where DR <=2
-----------------------------------------------------------------------------

--1.17 Add a new product: Loudspeakers, $70, manufacturer 2
insert into Products values(11,'LoudSpeaker',70,2)
select * from Products

--1.18 Update the name of product 8 to "Laser Printer"
update Products set name = 'Laser Printer' where Products.Code=8
-------------------------------------------------------------------------------------------------------
--- 1.19 Apply a 10% discount to all products
update products
set price=price*0.9;
-----------------------------------------------------------------------------------------------------
---- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120
update products
set price=price*0.9
where price >= 120
-------------------------------------------------------------------------------------------------------