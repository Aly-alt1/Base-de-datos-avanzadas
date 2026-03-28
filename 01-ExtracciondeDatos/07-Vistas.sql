/*
Una vista(view) es una tabla virtual basada en una consulta
sirve para reutilizar logica, simplicficar consulta sy controlar accesos

Existen dos tipos
-vistas almacenas 
-vistas materializadas( SQL SERVER Vistas Indexasas)

Sintaxis:

CREATE/ALTER VIEW vw_nombre
AS
Definicion de la vista
*/
use dbexercises;

--seleccionar todas las ventas por cliente, fecha de venta y estado

--Buenas Practicas
--Nombre de las vistas: vw
--Evitar el 'SELECT *' dentro de la vista
--Si se necesita ordenar hazlo el conrultar la vista

CREATE VIEW vw_ventas_totales
AS
SELECT  v.VentaId,
		v.ClienteId,
		v.FechaVenta,
		v.Estado,
		SUM (dv.Cantidad * dv.PrecioUnit * (1 - dv.Descuento/100)) AS [Total]
FROM Ventas AS v
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
GROUP BY v.VentaId,
		v.ClienteId,
		v.FechaVenta,
		v.Estado;
GO

--Trabajar con la vista
SELECT 
	vt.VentaId, 
	vt.ClienteId, 
	Total,
DATEPART(MONTH, vt.FechaVenta) AS [Mes]
FROM vw_ventas_totales AS vt
INNER JOIN Clientes  AS C
ON vt.ClienteId = c.ClienteId
WHERE DATEPART(MONTH, FechaVenta) = 1
AND Total >= 3130;

SELECT *
FROM DetalleVenta;

SELECT *
FROM Ventas;

SELECT *
FROM Clientes;

SELECT *
FROM Productos;

--Realizar una vista que se llame vw_detalle extendido
--que muestre la venta id, cliente(nombre), producto, categoria(nombre)
--cantidad vendida, precio unitario de la venta, descuento
--y total de cada linea (transaccion)

--en la vista seleccionar 50 lineas ordenadas por la venta id de froma ascendente

SELECT 
	VentaId,ProductoId, Cantidad, PrecioUnit, 
	SUM (dv.Cantidad * dv.PrecioUnit * (1 - dv.Descuento/100)) AS [Total]
FROM DetalleVenta AS dv
INNER JOIN ; 