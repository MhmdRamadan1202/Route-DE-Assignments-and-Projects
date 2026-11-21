USE Northwind; 
GO 
--------------------------------------------------------

/*
		Task 1.1
*/

UPDATE dbo.Products
SET UnitPrice=UnitPrice*1.1
WHERE CategoryID=8;

/*
		Task 1.2
*/

INSERT INTO dbo.Shippers(CompanyName,Phone)
VALUES('FastTrack Delivery','(503) 555-1234');

/*
		Task 1.3
*/

DELETE FROM dbo.Shippers
WHERE CompanyName='FastTrack Delivery';

--------------------------------------------------------

/*
		Task 2.1
*/

SELECT UPPER(ContactName) FullName,
	   STUFF(Phone, 1, 4, '****') Phone
FROM dbo.Customers;

/*
		Task 2.2
*/

SELECT  OrderID,
	    CustomerID,
		DATEDIFF(DAY,OrderDate,ShippedDate) ProcessingDays
FROM dbo.Orders 
WHERE ShipCountry='France';

----------------

SELECT SUM(DATEDIFF(DAY,OrderDate,ShippedDate)) ProcessingDays
FROM dbo.Orders O
WHERE ShipCountry='France';

/*
 In this task, what was required wasn't clear, So I selected ProcessingDays For Each order 
 And made another query to select Total ProcessingDays for all orers on france.
*/

/*
		Task 2.3
*/

SELECT SUBSTRING(ContactName, 1, CHARINDEX(' ', ContactName) - 1)  FirstName
FROM dbo.Customers;

--------------------------------------------------------

/*
		Task 3.1
*/

SELECT
    ProductID,
    SUM(Quantity * UnitPrice * (1 - Discount))  TotalRevenue
FROM dbo.[Order Details]
GROUP BY ProductID;

/*
		Task 3.2
*/

SELECT
    C.CategoryName,
    COUNT(P.ProductID)  ProductCount
FROM Categories C
LEFT JOIN Products P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName;

/*
		Task 3.3
*/

SELECT CustomerID
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 15;