USE Northwind; 
GO 
--------------------------------------------------------

/*
		Task 1.1
*/
CREATE TABLE dbo.Project_AuditLog
    (
        LogID INT IDENTITY(1,1) NOT NULL
                    CONSTRAINT PK_Project_AuditLog PRIMARY KEY,
        TableName VARCHAR(50) NOT NULL,
        ActionPerformed VARCHAR(50) NOT NULL,
        ActionDate DATETIME NOT NULL
                    CONSTRAINT DF_Project_AuditLog_ActionDate DEFAULT (GETDATE())
    );

/*
		Task 1.2
*/
ALTER TABLE dbo.Project_AuditLog
    ADD CONSTRAINT CK_Project_AuditLog_TableName_NotBlank
        CHECK (LEN(LTRIM(RTRIM(TableName))) > 0);

/*
		Task 1.3
*/

-- CREATE TABLE creates a new table; ALTER TABLE changes an existing table's schema.
-- DROP TABLE removes a table and its data, so it should be used carefully.

--------------------------------------------------------

/*
		Task 2.1
*/

SELECT UPPER(ProductName) ProductName,
       UnitPrice,
       CASE WHEN UnitPrice > 50 THEN 'Premium'
            ELSE 'Standard'END PriceCategory
FROM dbo.Products;

/*
		Task 2.2
*/

SELECT  ProductID,
        ProductName,
        CAST(UnitPrice AS DECIMAL(10,2)) UnitPrice,
        UnitsInStock
FROM dbo.Products
WHERE UnitPrice > 20
     AND UnitsInStock > 0
ORDER BY UnitPrice DESC;

/*
		Task 2.3
*/

SELECT  CustomerID,
        CompanyName,
        Region,
        CASE WHEN Region IS NULL THEN 'Missing Region'
             ELSE 'Region: ' + Region END  RegionStatus,
        COALESCE(Region, '(not provided)')  RegionWithDefault
FROM dbo.Customers;

--------------------------------------------------------

/*
		Task 3.1
*/

SELECT City, Country
FROM dbo.Customers
UNION
SELECT City, Country
FROM dbo.Employees;

/*
		Task 3.2
*/

SELECT  c.CategoryName,
        COUNT(p.ProductID) ProductCount
FROM dbo.Categories  c
JOIN dbo.Products p ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) > 10;


/*
		Task 3.3
*/

SELECT  e.EmployeeID,
        e.FirstName + ' ' + e.LastName  EmployeeName,
        CASE WHEN m.EmployeeID IS NULL THEN '(No manager)'
              ELSE m.FirstName + ' ' + m.LastName END AS ManagerName
FROM dbo.Employees e
LEFT JOIN dbo.Employees m ON e.ReportsTo = m.EmployeeID
ORDER BY e.EmployeeID;

/*
		Task 3.4
*/

SELECT City
FROM dbo.Customers
WHERE City IS NOT NULL
INTERSECT
SELECT City
FROM dbo.Employees
WHERE City IS NOT NULL;

--------------------------------------------------------

/*
		Task 4.1
*/

WITH EmpSales AS(
                    SELECT o.EmployeeID,
                           SUM(CONVERT(DECIMAL(19,4), od.Quantity) * od.UnitPrice)  TotalSales
                    FROM dbo.Orders  o
                    JOIN dbo.[Order Details]  od ON od.OrderID = o.OrderID
                    GROUP BY o.EmployeeID
                 )
SELECT e.FirstName,
       es.TotalSales
FROM dbo.Employees e
JOIN EmpSales es ON es.EmployeeID = e.EmployeeID
ORDER BY es.TotalSales DESC;

/*
		Task 4.2
*/

SELECT c.CustomerID
FROM dbo.Customers c
WHERE NOT EXISTS
                ( SELECT 1
                   FROM dbo.Orders o
                    WHERE o.CustomerID = c.CustomerID
                );

/*
		Task 4.3
*/

SELECT  p.ProductID,
        p.ProductName,
        p.CategoryID,
        p.UnitPrice
FROM dbo.Products  p
WHERE p.UnitPrice > ( SELECT AVG(p2.UnitPrice)
                       FROM dbo.Products p2
                        WHERE p2.CategoryID = p.CategoryID
                      );

/*
		Task 4.4
*/

SELECT  ProductID,
        ProductName,
        CategoryID,
        UnitPrice
INTO #TopProducts
FROM dbo.Products
WHERE UnitPrice > 20;

SELECT *
FROM #TopProducts
ORDER BY UnitPrice DESC;

/*
		Task 4.5
*/

DECLARE @TopCategories TABLE
(
    CategoryID   INT NOT NULL,
    CategoryName NVARCHAR(15) NOT NULL,
    ProductCount INT NOT NULL
);

INSERT INTO @TopCategories (CategoryID, CategoryName, ProductCount)
SELECT c.CategoryID,
       c.CategoryName,
       COUNT(p.ProductID)  ProductCount
FROM dbo.Categories  c
JOIN dbo.Products  p ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) > 10;

SELECT *
FROM @TopCategories
ORDER BY ProductCount DESC;

/*
		Task 4.6
*/

-- #Temp is a local temporary table, normally visible only to the current session
-- (and nested scopes that can access it). ##Temp is global and can be visible to
-- other sessions while it exists. In a shared student/server environment, global
-- temp tables risk name collisions, unintended cross-session access, and timing issues.

--------------------------------------------------------

/*
		Task 5.1
*/

CREATE VIEW dbo.vw_CustomerOrderSummary
AS
    SELECT c.CustomerID,
           c.CompanyName,
            COUNT(o.OrderID) NumberOfOrders
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CompanyName;


SELECT *
FROM dbo.vw_CustomerOrderSummary
ORDER BY NumberOfOrders DESC;


/*
		Task 5.2
*/

CREATE PROCEDURE dbo.sp_GetCustomerOrders
    @CustomerID NCHAR(5)
AS
BEGIN

    SELECT *
    FROM dbo.Orders
    WHERE CustomerID = @CustomerID;
END;

------

EXEC dbo.sp_GetCustomerOrders @CustomerID = N'ALFKI';

/*
		Task 5.3
*/

CREATE FUNCTION dbo.fn_GetCustomerOrderCount
(
    @CustomerID NCHAR(5)
)
RETURNS INT
AS
BEGIN
    DECLARE @OrderCount INT;

    SELECT @OrderCount = COUNT(*)
    FROM dbo.Orders
    WHERE CustomerID = @CustomerID;

    RETURN COALESCE(@OrderCount, 0);
END;

----

SELECT
    N'ALFKI'  CustomerID,
    dbo.fn_GetCustomerOrderCount(N'ALFKI')  OrderCount;

/*
		Task 5.4
*/

-- A normal view stores a query definition; it generally does not store the result set.
-- An indexed view in SQL Server can physically maintain its indexed result; other
-- database systems may use materialized views refreshed by a defined strategy.
-- These structures can speed up frequently reused expensive summaries, but they
-- add storage and write/maintenance cost. Refresh/maintenance behavior must be planned.

--------------------------------------------------------

/*
		Task 6.1 To 6.3
*/
BEGIN TRY
    BEGIN TRANSACTION;

    SAVE TRANSACTION BeforePriceUpdate;

    UPDATE dbo.Products
    SET UnitPrice = UnitPrice + 5
    WHERE ProductID = 1;

    SELECT 1 / 0 AS IntentionalDivideByZero;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        'Transaction rolled back; the price update should not persist.' AS Resolution;
END CATCH;



SELECT ProductID, ProductName, UnitPrice
FROM dbo.Products
WHERE ProductID = 1;


/*
		Task 6.4
*/

-- ACID: Atomicity (all or nothing), Consistency (valid state), Isolation (concurrent
-- transactions are controlled), Durability (committed changes persist).
-- Blocking: one session waits for another session's incompatible lock to be released.
-- Deadlock: sessions wait on each other in a cycle; SQL Server chooses a victim to roll back.
-- Do not deliberately create a deadlock in this assignment.

--------------------------------------------------------

/*
		Task 7.1
*/

CREATE TRIGGER dbo.trg_AuditProducts
ON dbo.Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Project_AuditLog (TableName, ActionPerformed)
    SELECT 'Products', 'Product Updated'
    FROM inserted;
END;

/*
		Task 7.2
*/

CREATE TRIGGER dbo.trg_AuditProducts_Delete
ON dbo.Products
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Project_AuditLog (TableName, ActionPerformed)
    SELECT 'Products', 'Product Deleted'
    FROM deleted;
END;

/*
		Task 7.3
*/

-- Keep triggers small and controlled because they run as part of the triggering
-- statement and can increase latency or cause failures to propagate to that statement.
-- Trigger behavior is implicit, which can make debugging and maintenance harder.
-- Use set-based logic over inserted/deleted; never assume a statement affects one row.
-- Task 7.4 — An INSTEAD OF trigger can validate or redirect INSERT/UPDATE/DELETE
-- operations issued against a view, for example a view spanning multiple base tables.
--------------------------------------------------------

/*
		Task 8.1
*/

CREATE TABLE #Staging_Shippers
(
    ShipperID   INT NOT NULL,
    CompanyName NVARCHAR(50) NOT NULL
);

INSERT INTO #Staging_Shippers (ShipperID, CompanyName)
VALUES
    (1, N'Speedy Express V2'),
    (4, N'Global Logistics');

/*
		Task 8.2
*/

MERGE dbo.Shippers AS Target
USING #Staging_Shippers AS Source
    ON Target.ShipperID = Source.ShipperID
WHEN MATCHED
    AND (Target.CompanyName <> Source.CompanyName
         OR Target.CompanyName IS NULL)
    THEN UPDATE
        SET CompanyName = Source.CompanyName
WHEN NOT MATCHED BY TARGET
    THEN INSERT (ShipperID, CompanyName)
         VALUES (Source.ShipperID, Source.CompanyName);


SELECT ShipperID, CompanyName
FROM dbo.Shippers
ORDER BY ShipperID;

/*
		Task 8.3
*/

DECLARE @Watermark DATETIME = '1997-01-01T00:00:00';

SELECT *
FROM dbo.Orders
WHERE OrderDate > @Watermark
ORDER BY OrderDate, OrderID;

/*
		Task 8.4
*/

SELECT
    Target.ShipperID,
    Target.CompanyName
FROM dbo.Shippers AS Target
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Staging_Shippers AS Source
    WHERE Source.ShipperID = Target.ShipperID
);

-- Soft Delete: retain the row and mark it inactive/deleted (for example, IsDeleted = 1).
-- Hard Delete: physically remove the row from the table.
-- Delete handling must be explicitly controlled because an incomplete staging extract
-- could otherwise cause valid target records to be deleted.

/*
		Task 8.5
*/

-- Idempotency: matching on a stable key and updating/inserting only as needed
-- lets the same complete source snapshot be applied repeatedly without duplicate keys.
-- For a true production incremental pipeline, define snapshot completeness, watermark
-- persistence, retry behavior, and concurrency guarantees explicitly.
--------------------------------------------------------

/*
		Task 9.1
*/

SELECT CategoryID,
        ProductName,
        UnitPrice,
        RANK() OVER (PARTITION BY CategoryID 
                        ORDER BY UnitPrice DESC)  PriceRank,
        DENSE_RANK() OVER (PARTITION BY CategoryID 
                            ORDER BY UnitPrice DESC)  DensePriceRank
FROM dbo.Products
ORDER BY CategoryID, 
         UnitPrice DESC;

/*
		Task 9.2
*/

SELECT OrderID,
       CustomerID,
       OrderDate,
       LAG(OrderDate) OVER (PARTITION BY CustomerID 
                            ORDER BY OrderDate, OrderID)  PreviousOrderDate
FROM dbo.Orders
ORDER BY CustomerID, 
         OrderDate, 
         OrderID;

/*
		Task 9.3
*/

WITH RankedOrders AS
(
    SELECT o.*,
           ROW_NUMBER() OVER  (PARTITION BY CustomerID 
                                    ORDER BY OrderDate DESC, OrderID DESC)  rn
    FROM dbo.Orders  o
)
SELECT *
FROM RankedOrders
WHERE rn = 1
ORDER BY CustomerID;

/*
		Task 9.4
*/

SELECT ProductID,
       ProductName,
       UnitPrice,
       NTILE(4) OVER (ORDER BY UnitPrice DESC, ProductID)  PriceQuartile
FROM dbo.Products
ORDER BY PriceQuartile,
         UnitPrice DESC;

/*
		Task 9.5
*/

SELECT  OrderID,
        OrderDate,
        Freight,
        SUM(COALESCE(Freight, 0)) OVER(ORDER BY OrderDate, OrderID
                                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RunningTotalFreight
FROM dbo.Orders
ORDER BY OrderDate, 
         OrderID;
--------------------------------------------------------

/*
		Task 10.1
*/

BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
        ON dbo.Orders (CustomerID)
        INCLUDE (OrderDate, Freight);
END;

/*
		Task 10.2
*/

SELECT OrderID
FROM dbo.Orders
WHERE OrderDate >= '19970101'
  AND OrderDate <  '19980101';

/*
		Task 10.3
*/

-- Enable Include Actual Execution Plan (Ctrl+M in SSMS), then execute each query separately:
-- A) SELECT OrderID FROM dbo.Orders WHERE YEAR(OrderDate) = 1997;
-- B) SELECT OrderID FROM dbo.Orders
--    WHERE OrderDate >= '19970101' AND OrderDate < '19980101';
-- Compare Scan, Seek, and Lookup operators. The optimizer may choose a scan because
-- Northwind is small; report what the actual plan shows rather than assuming a seek.


/*
		Task 10.4
*/

UPDATE STATISTICS dbo.Orders;

-- Statistics describe data distribution/cardinality and help the optimizer estimate
-- row counts and choose an efficient plan. Out-of-date statistics can lead to poor choices.


/*
		Task 10.5
*/
-- B-Tree: balanced tree structure used by common SQL Server rowstore indexes.
-- Selectivity: how effectively a predicate narrows rows; highly selective predicates
-- match a small fraction of the table.
-- Clustered index: defines the rowstore's leaf-level data order/structure by its key.
-- Nonclustered index: separate index structure containing keys and row locators/includes.
-- Composite index: index on multiple key columns; key order affects useful access patterns.

/*
		Task 10.6
*/

-- Orders.OrderDate is a suitable candidate for date-based partitioning in a large system.
-- Partitioning by date can enable partition elimination when queries filter on the
-- partitioning key, allowing SQL Server to access only relevant partitions. Partitioning
-- does not automatically make every query faster and requires suitable design/maintenance.