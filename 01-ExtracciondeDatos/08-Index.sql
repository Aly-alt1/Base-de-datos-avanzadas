use SalesDB;

--crear una tabla como una copia de customers
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1;

--crear a Clustered Index on Sales.DBCustomers usando customerID

CREATE CLUSTERED INDEX idx_Customers_CustomerID
ON Sales.DBCustomers (customerID);