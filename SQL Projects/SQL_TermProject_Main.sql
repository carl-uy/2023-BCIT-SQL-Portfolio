USE TermProject
GO
/*Data Retrieval*/
--B1
SELECT	OrderID,
		Quantity,
		p.ProductID,
		ReorderLevel,
		s.SupplierID
FROM [TermProject].[dbo].[OrderDetails] o
JOIN [TermProject].[dbo].[Products] p
ON o.ProductID = p.ProductID
JOIN [TermProject].[dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID
WHERE Quantity between 90 and 100
ORDER BY OrderID;
GO
--B2
SELECT	ProductID,
		ProductName,
		EnglishName,
		FORMAT(UnitPrice,'C','en-CA')
FROM [TermProject].[dbo].[Products]
WHERE UnitPrice < 10
ORDER BY ProductID;
GO
--B3
SELECT	CustomerID,
		CompanyName,
		Country,
		Phone
FROM [TermProject].[dbo].[Customers]
WHERE	Country = 'Canada' or 
		Country = 'USA'
ORDER BY CompanyName;
GO
--B4
SELECT	s.SupplierID,
		s.Name,
		ProductName,
		ReorderLevel,
		UnitsInStock
FROM [TermProject].[dbo].[Suppliers] s 
JOIN [TermProject].[dbo].[Products] p
ON  s.SupplierID = p.SupplierID
WHERE	UnitsInStock > ReorderLevel AND
		UnitsInStock <= (ReorderLevel + 10)
ORDER BY ProductName;
GO
--B5
SELECT	CompanyName,
		COUNT(o.orderid) as Amount
FROM [TermProject].[dbo].[Customers] c
JOIN [TermProject].[dbo].[Orders] o
ON c.CustomerID = o.CustomerID
WHERE FORMAT(OrderDate,'yyyy-MM') = '1993-12'
GROUP BY CompanyName
ORDER BY CompanyName;
GO
--B6
SELECT TOP 10
       p.ProductName,
       COUNT(OrderID) AS Amount
FROM [TermProject].[dbo].[OrderDetails] od
JOIN [TermProject].[dbo].[Products] p 
ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Amount DESC;
GO
--B7
SELECT	TOP 10
		p.ProductName,
		SUM(od.Quantity) as Quantity
FROM [TermProject].[dbo].[OrderDetails] od
JOIN [TermProject].[dbo].[Products] p
ON od.ProductID = p.ProductID
GROUP BY ProductName
ORDER BY Quantity desc;
GO
--B8
SELECT	o.OrderID,
		FORMAT(od.UnitPrice,'C','en-CA') as UnitPrice,
		od.Quantity
FROM [TermProject].[dbo].[Orders] o
JOIN [TermProject].[dbo].[OrderDetails] od
ON o.OrderID = od.OrderID
WHERE o.ShipCity = 'Vancouver'
ORDER BY o.OrderID;
GO
--B9
SELECT	c.CustomerID,
		c.CompanyName,
		o.OrderID,
		FORMAT(o.OrderDate,'MMMM dd,yyyy') as OrderDate
FROM [TermProject].[dbo].[Customers] c
JOIN [TermProject].[dbo].[Orders] o
ON o.CustomerID = c.CustomerID
WHERE o.ShippedDate is NULL
ORDER BY c.CustomerID, o.OrderDate;
GO
--B10
SELECT	ProductID,
		ProductName,
		QuantityPerUnit,
		UnitPrice
FROM [TermProject].[dbo].[Products]
WHERE ProductName LIKE '%choc%' or ProductName LIKE '%chock%' OR ProductName LIKE '%schokolade%'
ORDER BY ProductName;
GO
--B11
SELECT LEFT(ProductName, 1) AS Character, COUNT(*) AS Total
FROM [TermProject].[dbo].[Products]
GROUP BY LEFT(ProductName, 1)
HAVING COUNT(*) > 1
ORDER BY Character;
GO
/* Views and Data Modification*/
--C1
USE TermProject;
GO
DROP VIEW IF EXISTS dbo.vProductsUnder10;
GO
CREATE VIEW  dbo.vProductsUnder10
AS
SELECT	p.ProductName,
		FORMAT(p.UnitPrice,'C','en-CA') as UnitPrice,
		s.SupplierID,
		s.Name
FROM [TermProject].[dbo].[Products] p
JOIN [TermProject].[dbo].[Suppliers] s
ON p.SupplierID = s.SupplierID
WHERE p.UnitPrice < 10;
GO
SELECT * FROM [TermProject].[dbo].[vProductsUnder10]
ORDER BY [ProductName];
GO
--C2
USE TermProject;
GO
DROP VIEW IF EXISTS dbo.vOrdersByEmployee;
GO
CREATE VIEW dbo.vOrdersByEmployee
AS
SELECT	e.FirstName + ' '+ e.LastName as 'Name',
		COUNT(o.OrderID) as Orders 
FROM [TermProject].[dbo].[Employees] e
JOIN [TermProject].[dbo].[Orders] o
ON  o.EmployeeID = e.EmployeeID
GROUP BY	e.FirstName, 
			e.LastName;
GO
SELECT * FROM [TermProject].[dbo].[vOrdersByEmployee]
ORDER BY [Orders] DESC;
GO
--C3
UPDATE [TermProject].[dbo].[Customers]
SET Fax = 'Unknown'
WHERE Fax is null;
GO 
SELECT @@ROWCOUNT AS [Rows Affected];
GO
--C4
USE TermProject;
GO
DROP VIEW IF EXISTS dbo.vOrderCost;
GO
CREATE VIEW dbo.vOrderCost
AS 
SELECT	o.OrderID,
		FORMAT(o.OrderDate,'MMMM dd,yyyy') as OrderDate,
		c.CompanyName,
		SUM(od.Quantity * od.UnitPrice) as OrderCost
FROM [TermProject].[dbo].[Orders] o
JOIN [TermProject].[dbo].[Customers] c
ON o.CustomerID = c.CustomerID
JOIN [TermProject].[dbo].[OrderDetails] od
ON od.OrderID = o.OrderID
GROUP BY o.OrderID, o.OrderDate, c.CompanyName;
GO
SELECT TOP(5) [OrderID]
		,[OrderDate]
		,[CompanyName]
		,FORMAT([OrderCost], 'C2') AS [Cost]
	FROM [TermProject].[dbo].[vOrderCost]
	ORDER BY [OrderCost] DESC;
GO
--C5
INSERT INTO [TermProject].[dbo].[Suppliers]
			([SupplierID]
			,[Name])
		VALUES
			(16
			,'Supplier P');
GO
SELECT [SupplierID], [Name] FROM [TermProject].[dbo].[Suppliers]
WHERE [SupplierID] > 10
ORDER BY [SupplierID]
GO 
--C6
UPDATE [TermProject].[dbo].[Products]
SET [UnitPrice] = [UnitPrice] * 1.15
WHERE [UnitPrice] < 5;
GO
SELECT @@ROWCOUNT AS [Rows Affected];
GO
/*Functions, Stored Procedures and Triggers*/
USE TermProject;
GO
--D1
DROP FUNCTION IF EXISTS CustomersByCountry;
GO
CREATE FUNCTION CustomersByCountry (@country NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT CustomerID, CompanyName, City, Address
    FROM termproject.dbo.Customers
    WHERE Country = @country
);
GO
SELECT * FROM [TermProject].[dbo].[CustomersByCountry]('Germany')
ORDER BY [CompanyName] 
GO
--D2
DROP FUNCTION IF EXISTS ProductsInRange;
GO
CREATE FUNCTION ProductsinRange (@price1 int, @price2 int)
RETURNS TABLE
AS
RETURN(
	SELECT ProductID, ProductName, EnglishName, UnitPrice
	FROM [TermProject].[dbo].[Products]
	WHERE UnitPrice >= @price1 
	AND   UnitPrice <= @price2
);
GO
SELECT * FROM [TermProject].[dbo].[ProductsInRange](30, 50)
ORDER BY [UnitPrice];
GO
--D3
DROP PROCEDURE IF EXISTS EmployeeInfo;
GO
CREATE PROCEDURE EmployeeInfo
	@employeeID INT
AS
BEGIN
	SELECT EmployeeID, LastName, FirstName, Address, City, PostalCode, Phone, DATEDIFF(Year, BirthDate,'1994-01-01') as AGE
	FROM [TermProject].[dbo].[Employees]
	WHERE EmployeeID = @employeeID;
END
GO
EXEC [TermProject].[dbo].[EmployeeInfo] 9;
GO
--D4
DROP PROCEDURE IF EXISTS CustomersByCity;
GO
CREATE PROCEDURE CustomersByCity
	@city NVARCHAR(255)
AS
BEGIN
	SELECT CustomerID, CompanyName, Address, Phone 
	FROM [TermProject].[dbo].[Customers]
	WHERE City = @city
	ORDER BY CustomerID;
END
GO
EXEC [TermProject].[dbo].[CustomersByCity] 'London';
GO
--D5
DROP PROCEDURE IF EXISTS UnitPriceByRange;
GO
CREATE PROCEDURE UnitPriceByRange
	@unitprice1 INT,
	@unitprice2 INT
AS
BEGIN
	SELECT ProductID, ProductName, EnglishName, FORMAT(UnitPrice, 'C','en-CA') 
	FROM [TermProject].[dbo].[Products]
	WHERE	UnitPrice >= @unitprice1 AND
			UnitPrice <= @unitprice2;
END
GO
EXEC [TermProject].[dbo].[UnitPriceByRange] 6.00, 12.00;
GO
--D6
DROP PROCEDURE IF EXISTS OrdersByDates;
GO
CREATE PROCEDURE OrdersByDates 
	@start DATE,
	@end DATE
AS
BEGIN
	SELECT OrderID, c.CompanyName as Customer, s.CompanyName as Shipper, FORMAT(o.ShippedDate,'MMMMM dd, yyyy') as ShippedDate
	FROM [TermProject].[dbo].[Orders] o
	JOIN [TermProject].[dbo].[Customers] c
	ON c.CustomerID = o.CustomerID
	JOIN [TermProject].[dbo].[Shippers] s
	ON s.ShipperID = o.ShipperID
	WHERE	o.ShippedDate >= @start AND
			o.ShippedDate <= @end
	ORDER BY ShippedDate;
END
GO
EXEC [TermProject].[dbo].[OrdersByDates] '1991-05-15', '1991-05-31';
GO
--D7
DROP PROCEDURE IF EXISTS ProductsByMonthAndYear;
GO
CREATE PROCEDURE ProductsByMonthAndYear
	@productType NVARCHAR(255),
	@month NVARCHAR(255),
	@year INT
AS
BEGIN
	SELECT DISTINCT p.EnglishName, FORMAT(p.UnitPrice,'C','en-CA'), p.UnitsInStock, s.Name 
	FROM Products p
	JOIN Suppliers s ON p.SupplierID = s.SupplierID
	JOIN OrderDetails od ON od.ProductID = p.ProductID
	JOIN Orders o ON o.OrderID = od.OrderID
	WHERE p.EnglishName LIKE '%' + @productType + '%'
	AND DATENAME(month, OrderDate) = @month
	AND YEAR(o.OrderDate) = @year
	ORDER BY p.EnglishName;
END
GO
EXEC [TermProject].[dbo].[ProductsByMonthAndYear] '%cheese', 'December', 1992;
GO
--D8
DROP PROCEDURE IF EXISTS ReorderQuantity;
GO
CREATE PROCEDURE ReorderQuantity 
 @unitvalue INT
AS
BEGIN
	SELECT p.ProductID, p.ProductName, s.Name, p.UnitsInStock, p.ReorderLevel 
	FROM [TermProject].[dbo].[Products] p
	JOIN [TermProject].[dbo].[Suppliers] s
	ON p.SupplierID = s.SupplierID
	WHERE UnitsInStock - ReorderLevel < @unitvalue
	ORDER BY ProductName;
END
GO
EXEC [TermProject].[dbo].[ReorderQuantity] 5;
GO
--D9
DROP PROCEDURE IF EXISTS ShippingDelay;
GO
CREATE PROCEDURE ShippingDelay
	@cutoffDate DATE
AS
BEGIN
	SELECT	o.OrderID, o.OrderDate, o.RequiredDate, o.ShippedDate,
			c.CompanyName, s.CompanyName,  DATEDIFF(day, RequiredDate, ShippedDate) as DaysDelayedBy
	FROM [TermProject].[dbo].[Orders] o
	JOIN [TermProject].[dbo].[Customers] c
	ON o.CustomerID = c.CustomerID
	JOIN [TermProject].[dbo].[Shippers] s
	ON s.ShipperID = o.ShipperID
	WHERE	OrderDate >= @cutoffDate AND
			o.ShippedDate > o.RequiredDate;
END
GO
EXEC [TermProject].[dbo].[ShippingDelay] '1993-12-01';
GO
--D10
DROP PROCEDURE IF EXISTS DeleteInactiveCustomers;
GO
CREATE PROCEDURE DeleteInactiveCustomers
AS
BEGIN
    DELETE FROM [TermProject].[dbo].[Customers]
    WHERE NOT EXISTS (SELECT 1 FROM [TermProject].[dbo].[Orders] WHERE [TermProject].[dbo].[Orders].CustomerID = [TermProject].[dbo].[Customers].CustomerID);
END
GO
EXEC DeleteInactiveCustomers;
GO
SELECT COUNT(*) AS [ActiveCustomers] FROM [TermProject].[dbo].[Customers];
GO
--D11
USE TermProject;
GO
DROP TRIGGER IF EXISTS InsertShippers;
GO
CREATE TRIGGER dbo.InsertShippers
ON [dbo].[Shippers]
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted i WHERE i.CompanyName IN (SELECT s.CompanyName FROM Shippers s))
	BEGIN
		PRINT 'Attempt to insert an illegal value intercepted';
	END
	ELSE
	BEGIN
		INSERT INTO dbo.Shippers (ShipperID, CompanyName)
		SELECT ShipperID, CompanyName FROM inserted;
	END
END
GO

INSERT INTO [TermProject].[dbo].[Shippers] (ShipperID, CompanyName)
VALUES (4, 'Federal Shipping');
GO
SELECT * FROM [TermProject].[dbo].[Shippers];
GO

INSERT INTO [TermProject].[dbo].[Shippers] (ShipperID, CompanyName)
VALUES (5, 'On-Time Delivery');
GO
SELECT * FROM [TermProject].[dbo].[Shippers];
GO
--D12
USE TermProject;
GO
DROP TRIGGER IF EXISTS CheckQuantity;
GO
CREATE TRIGGER CheckQuantity ON OrderDetails
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT od.OrderID, od.ProductID
        FROM OrderDetails od
        JOIN Products p ON od.ProductID = p.ProductID
        JOIN inserted i ON od.OrderID = i.OrderID AND od.ProductID = i.ProductID
        WHERE p.UnitsInStock < i.Quantity
    )
    BEGIN
        RAISERROR('Ordered quantity exceeds available stock', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE od
        SET Quantity = i.Quantity
        FROM OrderDetails od
        JOIN inserted i ON od.OrderID = i.OrderID AND od.ProductID = i.ProductID;
    END
END;
GO
UPDATE [TermProject].[dbo].[OrderDetails]
SET [Quantity] = 50
WHERE [OrderID] = 10044 AND [ProductID] = 77;
GO
SELECT [Quantity] FROM [TermProject].[dbo].[OrderDetails]
WHERE [OrderID] = 10044 AND [ProductID] = 77
GO
UPDATE [TermProject].[dbo].[OrderDetails]
SET [Quantity] = 30
WHERE [OrderID] = 10044 AND [ProductID] = 77;
GO
SELECT [Quantity] FROM [TermProject].[dbo].[OrderDetails]
WHERE [OrderID] = 10044 AND [ProductID] = 77
GO