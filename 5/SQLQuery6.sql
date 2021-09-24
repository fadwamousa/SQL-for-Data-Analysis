CREATE TABLE Pieces (
 Code INTEGER PRIMARY KEY NOT NULL,
 Name TEXT NOT NULL
 );
CREATE TABLE Providers (
 Code VARCHAR(40) 
 PRIMARY KEY NOT NULL,  
 Name TEXT NOT NULL 
 );
CREATE TABLE Provides (
 Piece INTEGER, 
 FOREIGN KEY (Piece) REFERENCES Pieces(Code),
 Provider VARCHAR(40), 
 FOREIGN KEY (Provider) REFERENCES Providers(Code),  
 Price INTEGER NOT NULL,
 PRIMARY KEY(Piece, Provider) 
 );
 
-- alternative one for SQLite
  /* 
 CREATE TABLE Provides (
 Piece INTEGER,
 Provider VARCHAR(40),  
 Price INTEGER NOT NULL,
 PRIMARY KEY(Piece, Provider) 
 );
 */
 
 
INSERT INTO Providers(Code, Name) VALUES('HAL','Clarke Enterprises');
INSERT INTO Providers(Code, Name) VALUES('RBT','Susan Calvin Corp.');
INSERT INTO Providers(Code, Name) VALUES('TNBC','Skellington Supplies');

INSERT INTO Pieces(Code, Name) VALUES(1,'Sprocket');
INSERT INTO Pieces(Code, Name) VALUES(2,'Screw');
INSERT INTO Pieces(Code, Name) VALUES(3,'Nut');
INSERT INTO Pieces(Code, Name) VALUES(4,'Bolt');

INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'HAL',10);
INSERT INTO Provides(Piece, Provider, Price) VALUES(1,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'HAL',20);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'RBT',15);
INSERT INTO Provides(Piece, Provider, Price) VALUES(2,'TNBC',14);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'RBT',50);
INSERT INTO Provides(Piece, Provider, Price) VALUES(3,'TNBC',45);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'HAL',5);
INSERT INTO Provides(Piece, Provider, Price) VALUES(4,'RBT',7);
------------------------------------------------------------------------
-- 5.1 Select the name of all the pieces. 
select name from Pieces
------------------------------------------------------------------------
-- 5.2  Select all the providers' data. 
select * from Providers

-------------------------------------------------------------------------
-- 5.3 Obtain the average price of each piece 
--(show only the piece code and the average price).
select * from Pieces
select * from Provides
-----------------------------------
select Piece,avg(price) as Price_of_Pieces from Provides
group by Piece
-----------------------------------------
-- 5.4  Obtain the names of all providers who supply piece 1.

select * from Providers
select * from Provides


select Providers.Name 
from Providers join Provides
on Providers.Code = Provides.Provider
where Provides.Piece = 1;


select name from Providers
where Providers.Code in (select Provider from Provides 
                          where Piece = 1)


----------------------------------------------------
-- 5.5 Select the name of 
--pieces provided by provider with code "HAL".
select * from Pieces
select * from providers
select * from Provides

select name from Pieces 
inner join Provides 
on Provides.Piece = Pieces.Code
where Provides.Provider = 'HAL'

select name from Pieces
where Pieces.Code in (select Piece 
                      from Provides 
					  where Provides.Provider = 'HAL')

---------------------------------------------------------



select * from (
select Pieces.name as PieceN,
       Providers.Name AS ProviderNR,
	   Provides.Price AS Price,
	   DENSE_RANK() over(order by Price DESC) as DR
from Pieces inner join Provides
on Pieces.Code = Provides.Piece
inner join Providers
on Provides.Provider = Providers.Code) as T
where DR = 1


--------------------------------------------------------
select Top(1) Pieces.name as PieceN,
       Providers.Name AS ProviderNR,
	   Provides.Price AS Price,
	   DENSE_RANK() over(order by Price DESC) as DR
from Pieces inner join Provides
on Pieces.Code = Provides.Piece
inner join Providers
on Provides.Provider = Providers.Code
order by Price DESC
-------------------------------------------------------------
-- 5.8 Increase all prices by one cent.

select * from Provides
update Provides
set Price = Price + 1





