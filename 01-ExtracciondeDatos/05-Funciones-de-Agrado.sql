/* funciones de agregado
	COUNT (*)
	COUNT(CAMPO)
	MAX()
	MIN()
	AVG()
	SUM()

	Nota estas funciones por si solas, generan un resultado escalar (solo un registro)
	GROUP BY
	HAVING
*/
SELECT *
FROM Orders;

--siempre llevan alias
SELECT COUNT(*) AS [Numero de ordenes]  --cuenta todos los registros de la tabla
FROM Orders;

SELECT COUNT(shipregion) AS[numero de regiones]
FROM Orders;

SELECT MAX(OrderDate) AS [Ultima fecha de compra]
FROM Orders;

SELECT MAX(UnitPrice) AS [Precio mas alto]
FROM Products;

SELECT MIN(UnitsInStock) AS [Stock Minimo]
FROM Products;

--total de ventas realizadas
SELECT 
ROUND(SUM(UnitPrice * Quantity -(1-Discount)), 2) AS [Total]--no se puede usar una funcion de agregado sin un Group By
FROM [Order Details];

--seleccionar el promedio de ventas

SELECT 
ROUND(AVG(UnitPrice * Quantity -(1-Discount)), 2) AS [Promedio de ventas]
FROM [Order Details];

--seleccionar el numero de ordenes realizadas en alemania
SELECT*
FROM Orders;

SELECT *
FROM Orders
WHERE ShipCountry = 'Germany';

SELECT COUNT(*) AS[Total de ordenes]
FROM Orders
WHERE ShipCountry = 'Germany'
AND CustomerID = 'LEHMS';

SELECT *
FROM Customers;

--Seleccionar la suma de las cantidades vendidas por cada ordenid(agrupadad)

SELECT 
	OrderID,SUM(Quantity) AS [Total Cantidades]
FROM [Order Details]
GROUP BY OrderID;

--seleccionar el numero de productos por categoria
SELECT 
 CategoryID, COUNT (*) AS 'Numero de categoria'
FROM Products
GROUP BY CategoryID;

--obtener el total de pedidos realizados por cada cliente, 
SELECT 
	c.CategoryName AS [Categoria],COUNT(ProductID) AS [Numero de productos]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Beverages','Meat/Poultry')
GROUP BY c.CategoryName;

--obtener el total de pedidos realizados por cada cliente
--obtener el numero total de pedidos que ha atendido cada empleado
--ventas totales por producto
SELECT 
EmployeeID AS [Numero de empleado],
COUNT(*) AS [Total de ordenes]
FROM Orders
GROUP BY EmployeeID
ORDER BY [Total de ordenes] DESC;	

SELECT 
	e.FirstName, e.LastName,
	COUNT(OrderID) AS [Total de ordenes]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY [Total de ordenes] DESC;


SELECT 
	CONCAT(e.FirstName,'' ,e.LastName) AS [Nombre Completo],
	COUNT(OrderID) AS [Total de ordenes]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY [Total de ordenes] DESC;

SELECT od.ProductID,  ROUND (SUM (od.Quantity * od.UnitPrice *(1- Discount)) ,2) AS [Ventas totales]
FROM [Order Details] as od
WHERE ProductID IN (10,2,6)
GROUP BY od.ProductID;

SELECT TOP 1 p.ProductName,  ROUND (SUM (od.Quantity * od.UnitPrice *(1- Discount)) ,2) AS [Ventas totales]
FROM [Order Details] as od
INNER JOIN Products AS p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
Order BY 2 DESC;

SELECT p.ProductName,  ROUND (SUM (od.Quantity * od.UnitPrice *(1- Discount)) ,2) AS [Ventas totales]
FROM [Order Details] as od
INNER JOIN Products AS p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
Order BY 2 DESC;

--calcular cuantos pedidos se realizaron por año
SELECT COUNT(OrderID) AS [Numero de pedidos],
DATEPART(YY,OrderDate) AS [Año]
FROM Orders
GROUP BY DATEPART(YY, OrderDate);
--cuantos productos ofrece cada proveedor

SELECT 
	s.CompanyName AS [Proveedor],
	COUNT (*) AS [Numero de productos]
FROM Products as p
INNER JOIN Suppliers AS s
ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY 2 DESC;

--seleccionar el numero de pedidos por cliente que hayan realizado mas de 10
SELECT	
	c.CompanyName AS [Cliente],
	COUNT(*) AS [Numero de pedidos]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(*) >10;


--seleccionar los empleados que hayan gestionado pedidos por un total superior a 10,000 en ventas
--(mostrar el id del empleado, nombre y total de compras
SELECT
	o.EmployeeID AS [nombre empleado],
	CONCAT(e.FirstName , ' ', e.LastName) AS [Nombre completo],
	ROUND(SUM (od.UnitPrice * od.Quantity * (1- od.Discount)),2) AS [total ventas]
FROM [Order Details] AS od
INNER JOIN Orders AS o
ON od.OrderID = o.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY o.EmployeeID,e.FirstName, e.LastName;
--seleccionar