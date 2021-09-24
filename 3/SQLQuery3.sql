CREATE TABLE Warehouses (
   Code INTEGER NOT NULL,
   Location VARCHAR(255) NOT NULL ,
   Capacity INTEGER NOT NULL,
   PRIMARY KEY (Code)
 );
CREATE TABLE Boxes (
    Code CHAR(4) NOT NULL,
    Contents VARCHAR(255) NOT NULL ,
    Value REAL NOT NULL ,
    Warehouse INTEGER NOT NULL,
    PRIMARY KEY (Code),
    FOREIGN KEY (Warehouse) REFERENCES Warehouses(Code)
 ) 
 
  INSERT INTO Warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);
 
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('0MN7','Rocks',180,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4H8P','Rocks',250,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4RT3','Scissors',190,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('7G3H','Rocks',200,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8JN6','Papers',75,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8Y6U','Papers',50,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('9J6F','Papers',175,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('LL08','Rocks',140,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P0H6','Scissors',125,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P2T6','Scissors',150,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('TU55','Papers',90,5);

 ----------------------------------------------------------------------------------------------------------------------
 --3.1 Select all warehouses.
 select * from Warehouses
 -------------------------------------------------------------------------------------------------------
 ----3.2 Select all boxes with a value larger than $150.
 select * from Boxes where boxes.Value > 150
 -------------------------------------------------------------------------------------------------------
 ----3.3 Select all distinct contents in all the boxes.
 select distinct * from Boxes
 -----------------------------------------------------------------------------------------------------
 ----3.4 Select the average value of all the boxes.
 select avg(value) from Boxes
 -------------------------------------------------------------------------------------------------------
 --3.5 Select the warehouse code and the average value of the boxes in each warehouse.
 select Warehouses.Code,avg(value) as Mean
 from Boxes inner join Warehouses
 on Warehouses.Code = Boxes.Warehouse
 group by Warehouses.Code
 ----------------------------------------------------------------------------------------------------------
 --3.6 Same as previous exercise, but select only those warehouses 
 --where the average value of the boxes is greater than 150.
 select Warehouses.Code,avg(value) as Mean
 from Boxes inner join Warehouses
 on Warehouses.Code = Boxes.Warehouse
 group by Warehouses.Code
 having avg(value) > 150

 ----------------------------------------------------------------------------------------------------
 --3.7 Select the code of each box, along with the name of the city the box is located in.
 select boxes.Code,Location from Boxes
inner join Warehouses
on Warehouses.Code = Boxes.Warehouse
------------------------
--3.8 Select the warehouse codes, along with the number of boxes in each warehouse.
select Warehouses.Code as Warehouse,count(*) as numbe_of_boxes from Boxes
inner join Warehouses 
on Warehouses.Code = Boxes.Warehouse
group by Warehouses.Code

---------------------------------------------------------------------------------------
--3.9 Select the codes of all warehouses that are saturated 
--(a warehouse is saturated if the number of boxes in it is 
--larger than the warehouse's capacity).

select Warehouses.Code as Code,count(*) as number_of_boxes from Warehouses 
inner join Boxes
on Warehouses.Code = Boxes.Warehouse
group by  Warehouses.Code,Warehouses.Capacity
having count(*) > Warehouses.Capacity


SELECT Code
   FROM Warehouses
   WHERE Capacity <
   (
     SELECT COUNT(*)
       FROM Boxes
       WHERE Warehouse = Warehouses.Code
   );

----------------------------------------------------------------
--3.10 Select the codes of all the boxes located in Chicago.
select * from Boxes
select boxes.code from boxes
inner join Warehouses
on Warehouses.Code = Boxes.Warehouse
where Warehouses.Location like '%Chicago%'
----------------------------------------------
 SELECT Code
   FROM Boxes
   WHERE Warehouse IN
   (
     SELECT Code
       FROM Warehouses
       WHERE Location = 'Chicago'
   );

-------------------------------------------------------------------------------------
---3.14 Remove all boxes with a value lower than $100.
delete from Boxes where Value < 100
-----------------------------------------------------------------------------------------
--- 3.15 Remove all boxes from saturated warehouses.
--(a warehouse is saturated if the number of boxes in it is 
--larger than the warehouse's capacity)


delete from boxes
where warehouse in
(
SELECT Code
   FROM Warehouses
   WHERE Capacity <
   (
     SELECT COUNT(*)
       FROM Boxes
       WHERE Warehouse = Warehouses.Code
   )
);

-------------------------------------------------------------
--- 3.16 Add Index for column "Warehouse" in table "boxes"

create nonClustered index WareIndex
on Boxes(Warehouse) --NameTable(NameColumn)

--Print all the existing indexes
select *  from sys.indexes

select *  from sys.indexes where name = 'WareIndex'


---- 3.18 Remove (drop) the index you added just
DROP INDEX WareIndex;--MYSQL
DROP INDEX  WareIndex ON boxes  --sql





