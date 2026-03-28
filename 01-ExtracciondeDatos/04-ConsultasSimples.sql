--Consultas Simples
use NORTHWND

-- Seleccionar cada una de las tablas 
SELECT *
FROM Customers;
go

SELECT *
FROM Employees;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

SELECT *
FROM Shippers;

SELECT *
FROM Suppliers;

SELECT *
FROM Products;

--Proyeccion de la tabla

SELECT ProductName, UnitsInStock, UnitPrice
FROM Products;

--Alias de columnas

SELECT ProductName AS NombreProducto, --siempre debe de llevar AS
UnitsInStock 'Unidades Medida' , 
UnitPrice AS [Precio Unitario] 
FROM Products;

--Campo calculado y alias de tabla

SELECT 
	[Order Details].OrderID AS [Numero de Orden], 
	Products.ProductID AS [Numero de producto], 
	ProductName AS 'Nombre de producto',
	Quantity Cantidad,
	Products.UnitPrice AS precio, 
	(Quantity *	[Order Details].UnitPrice) AS subtotal
FROM [Order Details] --Izquierda
INNER JOIN --no importa a direccion de la tabla, son los que coinciden del mismo tipo fk(donde esta la n), pk
Products --derecha
ON Products.ProductID = [Order Details].ProductID;


SELECT 
	od.OrderID AS [Numero de Orden], 
	pr.ProductID AS [Numero de producto], 
	ProductName AS 'Nombre de producto',
	Quantity Cantidad,
	od.UnitPrice AS precio, 
	(Quantity * od.UnitPrice) AS subtotal
FROM [Order Details] as od --Izquierda
INNER JOIN --no importa a direccion de la tabla, son los que coinciden del mismo tipo fk(donde esta la n), pk
Products as pr --derecha
ON pr.ProductID = od.ProductID;

-- Operadores Relacionales (<, >, <=, >=, =, != o <>)
-- Mostrar todos los productos mayores a 20

SELECT 
	ProductName AS [Nombre Producto],
	QuantityPerUnit AS [Descripcion],
	UnitPrice AS [Precio]
FROM Products
WHERE UnitPrice > 20;

--Seleccionar todos los clientes que no sean de Mexico
SELECT *
FROM Customers
WHERE Country = 'Mexico';

--Seleccionr todos aquellas ordenes realizadas en 1997
SELECT 
	OrderID AS [Numero de Orden],
	OrderDate AS [Fecha de orden],
	YEAR(OrderDate) AS [Año con Year],
	DATEPART(YEAR,OrderDate) AS [Año con DatePart]
FROM Orders
WHERE YEAR(OrderDate) = 1997;


SELECT 
	OrderID AS [Numero de Orden],
	OrderDate AS [Fecha de orden],
	YEAR(OrderDate) AS [Año con Year],
	DATEPART(YEAR,OrderDate) AS [Año con DatePart],
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATEPART(WEEKDAY, OrderDate) AS [Nombre Dia Semana]
FROM Orders
WHERE YEAR(OrderDate) = 1997;

set Language Spanish
SELECT 
	OrderID AS [Numero de Orden],
	OrderDate AS [Fecha de orden],
	YEAR(OrderDate) AS [Año con Year],
	DATEPART(YEAR,OrderDate) AS [Año con DatePart],
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Nombre Dia Semana]
FROM Orders
WHERE YEAR(OrderDate) = 1997;

--Operadores logicos (AND, OR, NOT)

--seleccionar los productos que tengan un precio mayor a 20
--y un stock mayor a 30

SELECT 
	ProductID AS [Numero Producto],
	ProductName AS [Nombre del Producto],
	UnitsInStock AS [Existencia],
	UnitPrice AS [Precio],
	(UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products
WHERE UnitPrice > 20
AND UnitsInStock <30;

--seleccionar a los clientes de estados unidos o canada

SELECT 
	CustomerID, 
	CompanyName,
	City,
	Country
FROM Customers
WHERE Country = 'USA' 
OR Country = 'Canada';

--seleccionar los clientes de brazil, rio de janeiro, y que tengan region

SELECT *
FROM Customers
WHERE Country = 'Brazil'
AND City = 'Rio de Janeiro'
AND Region IS NOT NULL;


--Operador IN
--Seleccionar todos los clientes de estados unidos, alemania y francia

SELECT *
FROM Customers
WHERE Country ='USA'
OR Country= 'Germany'
OR Country = 'France'
ORDER BY Country;

--con IN
SELECT *
FROM Customers
WHERE Country IN ('USA','Germany', 'France')
ORDER BY Country DESC; --de la U a F, sin esta es de F a U

--Seleccionar los nombres de tres categorias especificas
SELECT CategoryName
FROM Categories
WHERE CategoryName In('Produce','Seafood','Condiments');

--Seleccionar los pedidos de tres empleados en especifico
SELECT e.EmployeeID, 
CONCAT(e.FirstName, e.LastName) AS [Full name],
o.OrderDate
FROM Orders AS o
JOIN Employees e
ON o.EmployeeID = e.EmployeeID
WHERE e.employeeID IN ('5','3','1')
ORDER BY 2 DESC;

--Seleccionar todos los clientes que no sean de alemania, mexico y argentina

SELECT * 
FROM Customers
WHERE Country NOT IN ('Germany','Mexico','Argentina')
ORDER BY Country;

--Operador between

--seleccionar todos los productos que su precio este entre
-- 10 y 30

SELECT 
 ProductName,
 UnitPrice AS [precio]
FROM Products
WHERE UnitPrice >= 10 
AND UnitPrice <= 30
ORDER BY [precio] DESC;

--con between
SELECT 
 ProductName,
 UnitPrice AS [precio]
FROM Products
WHERE UnitPrice BETWEEN 10 AND 30
ORDER BY [precio] DESC;

--Seleccionar todas las ordenes de 1995 a 1997
SELECT *
FROM Orders
WHERE DATEPART(YEAR,OrderDate) BETWEEN 1995 AND 1997;

--Seleccionar todos los productos que no esten en un precio entre 10 y 20

SELECT *
FROM Products
WHERE UnitPrice NOT BETWEEN 10 AND 20;

--Operador like
--WLIDCARDS (%, _ , [] ,[^],)

--Seleccionar todos los clientes en donde su nombre comience con 'a'
SELECT *
FROM Customers
WHERE ContactName LIKE 'A%';

--Seleccionar todos los clientes de una ciudad que comienza con 'L', 
--siguido de cualquier caracter, despues nd y que termine con dos caracteres cualesquiera

SELECT *
FROM Customers
WHERE City LIKE 'L_nd__';

--Seleccionar todos los clientes que su nombre termine con a

SELECT *
FROM Customers
WHERE CompanyName LIKE '%a';