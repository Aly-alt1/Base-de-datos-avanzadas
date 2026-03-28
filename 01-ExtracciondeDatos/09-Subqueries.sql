CREATE DATABASE bdsubqueries;

USE bdsubqueries;

drop table clientes;
drop table pedidos;
CREATE TABLE clientes (
	id_cliente INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	ciudad VARCHAR (50) NOT NULL
);

CREATE TABLE pedidos (
	id_pedido INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	total money NOT NULL,
	fecha DATE NOT NULL
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (id_cliente)
	REFERENCES clientes (id_cliente)
	ON DELETE CASCADE
);

INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

select * from pedidos;

--Seleccionar el cliente que hizo el pedido mas caro
--subconsulta 
SELECT id_Cliente
FROM pedidos
WHERE total =(SELECT MAX (total) FROM pedidos);

--Consulta principal

SELECT TOP 1 *
FROM pedidos
WHERE id_cliente =(
    SELECT id_cliente
    FROM pedidos
    WHERE total =(SELECT MAX(total)FROM PEDIDOS)
    );

SELECT p.id_pedido, c.nombre,p.total, p.fecha
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente =(
    SELECT id_cliente
    FROM pedidos
    WHERE total =(SELECT MAX(total)FROM PEDIDOS)
    );

SELECT TOP 1 p.id_pedido, c.nombre,p.total, p.fecha, MAX (p.total) AS [Maximo]
FROM pedidos AS p
INNER JOIN
clientes AS c
ON p.id_cliente = c.id_cliente
ORDER BY total DESC;

--seleccionar los pedidos mayores al promedio
SELECT AVG(total)
FROM pedidos;

--consulta principal

SELECT *
FROM pedidos
WHERE total > (
    SELECT AVG(total)
    FROM pedidos
    );


--Mostrar el cliente con menor id
SELECT MIN(id_cliente)
FROM pedidos;

SELECT *
FROM pedidos
WHERE id_cliente = (
    SELECT MIN(id_cliente)
    FROM pedidos
);


SELECT p.id_pedido, c.nombre, p.fecha, p.total
FROM pedidos as p
INNER JOIN
clientes as c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente = (
    SELECT MIN(id_cliente)
    FROM pedidos
);

--Mostrar el ultimo pedido realizado
SELECT MAX(fecha)
FROM pedidos;

--principal
SELECT p.id_pedido, p.fecha, c.nombre, p.total
FROM pedidos as p
INNER JOIN
clientes as c
ON p.id_cliente = c.id_cliente
WHERE fecha = (
    SELECT MAX(fecha)
    FROM pedidos
);

--Mostrar el pedido con el total mas bajo
SELECT MIN(total)
FROM pedidos;

SELECT*
FROM pedidos
WHERE total =(
    SELECT MIN(total)
    FROM pedidos    
);

--seleccionar los pedidos con el nombre dle cliente cuyo total (Freight) sea mayor
--al promedio general de Freight
use NORTHWND;

SELECT AVG(Freight)
FROM Orders;

SELECT o.OrderID, c.CompanyName, o.Freight
FROM Orders as o
INNER JOIN
Customers as c
ON o.CustomerID = c.CustomerID
WHERE o.Freight >(
    SELECT AVG(Freight)
FROM Orders
)
ORDER BY Freight DESC;


--Clientes que han hecho pedidos

use bdsubqueries;

SELECT id_cliente
FROM pedidos;

SELECT *
FROM clientes
WHERE id_cliente IN(
    SELECT id_cliente
FROM pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM clientes as c
INNER JOIN 
pedidos as p
on c.id_cliente = p.id_cliente;

--Seleccionar clientes de CDMX que han hecho pedidos

SELECT id_cliente
FROM clientes;

SELECT *
FROM clientes
WHERE ciudad = 'CDMX'
AND id_cliente IN(
    SELECT id_cliente
    FROM clientes
);

--seleccionar los pedidos de los clientes que viven en cdmx

--sub consulta
SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX';

--consulta
SELECT p.id_cliente, p.fecha, c.ciudad,c.nombre, p.total
FROM pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IN(
    SELECT id_cliente
    FROM clientes
    WHERE ciudad = 'CDMX'
);

--seleccionar todos los clientes que no han hecho pedidos
SELECT id_cliente
FROM pedidos;

SELECT *
FROM clientes
WHERE id_cliente NOT IN(
    SELECT id_cliente
    FROM pedidos
);


SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM clientes AS c
LEFT JOIN pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE p.id_cliente IS NULL;

--Instruccion ANY

--Seleccionar todos los pedidos con un total mayor de algun pedido de luis

SELECT total
FROM pedidos
WHERE id_cliente = 2;

SELECT* 
FROM pedidos
WHERE total > ANY(
SELECT total
FROM pedidos
WHERE id_cliente = 2
);

--seleccionar todos los pedidos en donde sea mayor a algun pedido de ana

SELECT total
FROM pedidos
WHERE id_cliente= 1;

SELECT *
FROM pedidos
WHERE total > ANY(
    SELECT total
    FROM pedidos
    WHERE id_cliente= 1
);