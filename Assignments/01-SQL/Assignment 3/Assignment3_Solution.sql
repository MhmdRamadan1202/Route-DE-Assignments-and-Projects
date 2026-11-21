USE Northwind; 
GO 
--------------------------------------------------------

/*
		Task 1.1
*/

SELECT C.CustomerID,
       C.CompanyName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;


/*
		Task 1.2
*/

SELECT City CityList
FROM Customers
UNION
SELECT City
FROM Employees;

/*
		Task 1.3
*/

SELECT CONCAT(E.FirstName, ' ', E.LastName)  EmployeeName,
       CONCAT(M.FirstName, ' ', M.LastName)  ManagerName
FROM Employees E
LEFT JOIN Employees M ON E.ReportsTo = M.EmployeeID;

--------------------------------------------------------

/*
		Task 2.1
*/

SELECT ProductID,
       ProductName,
       UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice)
                   FROM Products);

/*
		Task 2.2
*/

SELECT C.CustomerID,
       C.CompanyName,
    ( SELECT MAX(O.OrderDate)
      FROM Orders AS O
      WHERE O.CustomerID = C.CustomerID )  LatestOrderDate
FROM Customers  C;


--------------------------------------------------------
/*

3.2 Extend the exact logic from Task 3.1: In your main SELECT statement, add a calculated column named
'PriceDifference' that subtracts the 'AvgCategoryPrice' (retrieved from the CTE) from the product's actual
'UnitPrice'.*/


/*
		Task 3.1
*/

WITH CategoryAverages AS
                        ( SELECT  CategoryID,
                                  AVG(UnitPrice)  AvgCategoryPrice
                          FROM Products
                          GROUP BY CategoryID
                        )
SELECT
    P.ProductName,
    C.CategoryName,
    P.UnitPrice,
    CA.AvgCategoryPrice
FROM Products P
JOIN CategoryAverages CA ON P.CategoryID = CA.CategoryID
JOIN Categories C ON P.CategoryID = C.CategoryID;


/*
		Task 3.2
*/

WITH CategoryAverages AS
                        ( SELECT CategoryID,
                                 AVG(UnitPrice) AvgCategoryPrice
                           FROM Products
                           GROUP BY CategoryID
                        )
SELECT
    P.ProductName,
    C.CategoryName,
    P.UnitPrice,
    CA.AvgCategoryPrice,
    P.UnitPrice - CA.AvgCategoryPrice PriceDifference
FROM Products P
JOIN CategoryAverages CA ON P.CategoryID = CA.CategoryID
JOIN Categories C ON P.CategoryID = C.CategoryID;