USE Northwind; 
GO 
--------------------------------------------------------

/*
		Task 1.1
*/

CREATE VIEW dbo.vw_UnshippedOrders
AS
SELECT  O.OrderID,
		C.CompanyName,
		S.CompanyName ShippingCompany,
		O.OrderDate
FROM dbo.Orders O
JOIN dbo.Customers C ON O.CustomerID = C.CustomerID
JOIN dbo.Shippers S ON O.ShipVia = S.ShipperID
WHERE O.ShippedDate IS NULL;

/*
		Task 1.2
*/

SELECT *
FROM dbo.vw_UnshippedOrders
ORDER BY OrderDate DESC;

--------------------------------------------------------

/*
		Task 2.1
*/

CREATE FUNCTION dbo.fn_CalculateNetLineTotal
(
    @Quantity SMALLINT,
    @UnitPrice MONEY,
    @Discount REAL
)
RETURNS MONEY
AS
BEGIN
    RETURN (@Quantity * @UnitPrice * (1 - @Discount));
END;

/*
		Task 2.2
*/

SELECT  OD.OrderID,
		OD.ProductID,
		dbo.fn_CalculateNetLineTotal(
						OD.Quantity,
						OD.UnitPrice,
						OD.Discount
		                    )  NetLineTotal
FROM dbo.[Order Details] OD;


--------------------------------------------------------

/*
		Task 3.1 --> 3.3
*/

CREATE PROCEDURE dbo.sp_InsertNewEmployee
    @FirstName NVARCHAR(10),
    @LastName NVARCHAR(20),
    @Title NVARCHAR(30),
    @BirthDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    IF @BirthDate >= GETDATE()
    BEGIN
        PRINT 'Invalid Birth Date: Cannot be in the future';
        RETURN;
    END;

    INSERT INTO dbo.Employees
    (
        FirstName,
        LastName,
        Title,
        BirthDate
    )
    VALUES
    (
        @FirstName,
        @LastName,
        @Title,
        @BirthDate
    );
END;


/*
		Task 3.4
*/
----- A:

EXEC dbo.sp_InsertNewEmployee
    @FirstName = N'John',
    @LastName = N'Doe',
    @Title = N'Sales Representative',
    @BirthDate = '19900101';

----- B:
EXEC dbo.sp_InsertNewEmployee
    @FirstName = N'Jane',
    @LastName = N'Doe',
    @Title = N'Sales Representative',
    @BirthDate = '20500101';