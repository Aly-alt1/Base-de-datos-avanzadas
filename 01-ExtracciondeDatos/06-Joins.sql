USE NORTHWND; 

SELECT TOP 0 CategoryID, CategoryName
INTO categoriesnew
FROM Categories;


ALTER TABLE categoriesnew
ADD CONSTRAINT pk_categories_new
PRIMARY KEY (Categoryid);

SELECT TOP 0 productid, ProductName, CategoryID
INTO productsnew
FROM Products;


ALTER TABLE productsnew
ADD CONSTRAINT pk_products_new
PRIMARY KEY (productid);

ALTER TABLE productsnew
ADD CONSTRAINT fk_products_categories2
FOREIGN KEY (categoryid)
REFERENCES categoriesnew (categoryid)
ON DELETE CASCADE;

INSERT INTO categoriesnew
VALUES
('C1'),
('C2'),
('C3'),
('C4');

INSERT INTO productsnew
VALUES
('P1', 1),
('P2', 1),
('P3', 2),
('P4', 2),
('P5', 4),
('P6', NULL);

SELECT*
FROM categoriesnew;

SELECT *
FROM productsnew;

SELECT* 
FROM categoriesnew AS c
INNER JOIN
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT* 
FROM categoriesnew AS c
LEFT JOIN
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE ProductID is NULL;

SELECT* 
FROM categoriesnew AS c
RIGHT JOIN
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT* 
FROM categoriesnew AS c
RIGHT JOIN
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE c.CategoryID is NULL;

SELECT* 
FROM productsnew AS p
LEFT JOIN
categoriesnew AS c
ON p.CategoryID = c.CategoryID;


SELECT TOP 0
CategoryID AS [Numero],
CategoryName AS[Nombre],
[Description] AS [Descripcion]
INTO categories_nuevas
FROM Categories;

ALTER TABLE categories_nuevas
ADD CONSTRAINT pk_categorias_nuevas
PRIMARY KEY ([Numero]);

SELECT *
FROM categories_nuevas;

INSERT INTO Categories
VALUES  ('Ropa', 'Ropa de paca' ,NULL),
		('Linea Blanca','Ropa de robin' , NULL);

SELECT *
FROM Categories AS c
LEFT JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero;

INSERT INTO categories_nuevas
SELECT c.CategoryName, c.Description
FROM Categories AS c
LEFT JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero is null;

SELECT *
FROM Categories;

SELECT *
FROM categories_nuevas;

SELECT c.CategoryName, c.Description
FROM Categories AS c
LEFT JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero is null;


INSERT INTO Categories
VALUES  ('Bebidas', 'Bebidas Corrientes' ,NULL),
		('Deportes','para los que pierden' , NULL);

SELECT 
UPPER (c.CategoryName),UPPER (c.Description)
FROM Categories AS c
LEFT JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero is null;

INSERT INTO categories_nuevas
SELECT 
UPPER (c.CategoryName) AS [Categories],
UPPER (CAST (c.Description AS varchar)) AS [Descripcion]
FROM Categories AS c
LEFT JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL;

SELECT *
FROM categories_nuevas;

SELECT*
FROM Categories AS c
INNER JOIN categories_nuevas AS cn
ON c.CategoryID = cn.Numero;

DELETE FROM categories_nuevas;

--reinicia los identity (cuando las tablas tienen integridad referencial
-- sino utilizar truncate)

DBCC CHECkIDENT('categories_nuevas', RESEED,0);

--el trunkate elimina los datos de la tabla al igual que el delete, pero 
--solamente funciona sino tiene itegdridad refrencial
--ademas reinicia los identity
TRUNCATE TABLE categories_nuevas;

--FULL JOIN
SELECT *
FROM categoriesnew AS c
FULL JOIN
productsnew AS p
ON c.CategoryID = p.CategoryID;

--CROSS JOIN
SELECT *
FROM categoriesnew AS c
CROSS JOIN
productsnew AS p;