# Store Procedure

## Fundamentos

1 ¿Que es un store procedure?

Es un bloque de codigo SQL guardado dentro de la base de datos (**un objeto de la BD**) que puede ejecutarse cuando se necesite

Es similar a una a una funcion o metodo en programacion:

Ventajas
1. Reutilizacion de codigo
2.Mejor Rendimiento
3.Mejor seguridad(evitar la inyeccion SQL)
4.Centralizacion de la loqgica del negocio
5.Menos trafico entre la aplicacion y el servidor

```sql
/* ============================STORE PROCEDURE================================*/

CREATE OR ALTER PROCEDURE usp_mensaje_saludar
AS
BEGIN
    PRINT 'Hola mundo Transact SQL-3' 
END;
GO

EXECUTE usp_mensaje_saludar;
GO

EXEC usp_mensaje_saludar
GO

DROP PROC usp_mensaje_saludar;

```

## 2.Parametros en Store Procedures

Los parametros permiten enviar datos a los sp
```sql

--Store procedure

CREATE DATABASE bdstored;

USE bdstored;
GO

--imprime los numeros del 1 al 10
CREATE OR ALTER PROC spu_persona_saludar
    @nombre VARCHAR(50)
--parametro de entrada
AS
BEGIN
    PRINT  'Hola, ' + @nombre;
END;
GO

EXEC spu_persona_saludar 'Arcadio';
EXEC spu_persona_saludar 'Roberta';
EXEC spu_persona_saludar 'Monico';
EXEC spu_persona_saludar 'Luisa';
GO

SELECT CustomerID, CompanyName, City, Country
INTO customers
FROM
    NORTHWND.dbo.Customers;

SELECT *
FROM customers;
GO

--Realizar un store que reciba un parametro de un cliente en particular y lo muestre
CREATE OR ALTER PROC spu_cliente_consultarporid
    @Id CHAR(10)
AS
BEGIN
    SELECT CustomerID as [Numero],
        CompanyName as [Cliente],
        City as [Ciudad],
        Country  as [Pais]
    FROM customers
    WHERE CustomerID = @Id;
END;

EXEC spu_cliente_consultarporid 'ANTONT';
GO

/*
SELECT * FROM customers
WHERE EXISTS (SELECT 1
FROM customers
WHERE CustomerID = 'ANTONT');   

DECLARE @valor INT
SET @valor = (SELECT 1
FROM customers
WHERE CustomerID = 'ANTON');

IF @valor = 1
BEGIN
    PRINT 'Existe';
END
ELSE
BEGIN
    PRINT 'No existe';
END;
GO
*/

CREATE OR ALTER PROC spu_cliente_consultarporid2
    @Id CHAR(10)
AS
BEGIN
    IF LEN(@Id) > 5
        BEGIN
        RAISERROR ('El ID del cliente debe ser menor o igual a 5',10,2)
        --THROW 5001, 'El numero de cliente debe ser menor o igual a 5',1;
        RETURN;
        END

    IF EXISTS (SELECT 1
    FROM customers
    WHERE CustomerID = @Id)
    BEGIN
        SELECT CustomerID as [Numero],
            CompanyName as [Cliente],
            City as [Ciudad],
            Country  as [Pais]
        FROM customers
        WHERE CustomerID = @Id;
        RETURN;
    END
        PRINT 'EL cliente no existe ';
END;

EXEC spu_cliente_consultarporid2 @Id ='ANTON';

DECLARE @Id2 AS CHAR(10) = (SELECT CustomerID FROM customers WHERE CustomerID = 'ANTON');

EXEC spu_cliente_consultarporid2  @Id2;

DECLARE @Id3 AS CHAR(10);

SELECT @Id3= (SELECT CustomerId FROM customers WHERE CustomerID = 'ANTON');

EXEC spu_cliente_consultarporid2  @Id3;

```

3.PARAMETROS OUTPUT

Los parameyros OUTPUT decuelven valores al usuario
```SQL
CREATE OR ALTER PROC spu_operacion_sumar
    @a INT,
    @b as INT,
    @resultado INT OUTPUT
AS
BEGIN
    SET @resultado = @a + @b;
END;

--utilizar la variable de salida
DECLARE @res INT ;
EXEC spu_operacion_sumar 4,5, @res OUTPUT;
SELECT @res AS [SUMA];
GO
```

4- Logica dentro del SP

Puedes usar :

-IF
-IF/ELSE
-WHILE
-VARIABLES
-CASE

```sql
    /*=============================Logica dentro del SP========================
Crear un SP que Evalue la edad de una persona
*/

CREATE OR ALTER PROC usp_persona_evaluarEdad
    @edad INT
AS
BEGIN 
    IF @edad>= 18 AND @edad <= 45
    BEGIN
        PRINT 'Eres un adulto sin pension'
        PRINT 'Ya merito'
    END

    ELSE

    BEGIN
    PRINT 'Eres menor de edad'
    END
END;
GO

EXEC usp_persona_evaluarEdad 22;
EXEC usp_persona_evaluarEdad 17;
GO

CREATE OR ALTER PROC usp_Valores_Imprimir
    @N AS INT

AS
    BEGIN
    IF @N <=0
    BEGIN
        PRINT 'ERROR: Valor de N no valido'
        RETURN
    END
    DECLARE @i AS INT 
    DECLARE @j INT= 1
    SET @i = 1

    WHILE (@i <= @N)
    BEGIN
       WHILE (@j<=10)
       BEGIN
            PRINT CONCAT(@i, ' * ', @j, ' = ', @i*@j , CHAR(13) + CHAR(10) );
            SET @j = @j + 1;
       END
       SET @i = @i + 1;
       SET @j = 1;
       END
    END;
GO

EXECUTE usp_Valores_Imprimir 10;
GO
/*========================CASE========================
Sirve para evaluar condiciones como un switch o un if multiple
*/

CREATE OR ALTER PROC usp_Calificacion_Evaluar
    @calificacion INT
AS
BEGIN
    SELECT
    CASE
        WHEN @calificacion >= 90 THEN 'Excelente'
        WHEN @calificacion >=70 THEN 'Aprobado'
        WHEN @calificacion >= 60 THEN 'Regular'

        ELSE 'No Acreditado'
    END AS Resultado;
END;
GO

--Ejecutar
EXEC usp_Calificacion_Evaluar 89;
GO

USE NORTHWND;
GO

SELECT MAX(UnitPrice), min(UnitPrice)
FROM [Order Details];

GO

SELECT ProductID, UnitPrice,
    CASE 
    WHEN UnitPrice = 200 THEN 'CARO'
    WHEN UnitPrice = 100 THEN 'BARATO'
    ELSE 'NORMAL'
    END AS [CATEGORIA]
FROM Products
GO
--SP que calcule las ventas pero con rango

CREATE OR ALTER PROC usp_comision_ventas
    @idCliente NCHAR (10)
AS
BEGIN
    IF LEN(@idCliente) > 5
    BEGIN
        PRINT 'El tamaño dle id del cliente debe ser de 5'
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM customers WHERE CustomerID = @idCliente)
    BEGIN
        PRINT 'El cliente no existe'
        RETURN;
    END

DECLARE @comision DECIMAL (10,2);
DECLARE @total MONEY
SET @total = (SELECT (UnitPrice * Quantity) 
    FROM [Order Details] AS od
    INNER JOIN Orders AS o
    On o.OrderID = od.OrderID
    WHERE o.CustomerID = @idCliente    
    )

    BEGIN
        SET @comision =
            CASE
                WHEN @total >= 19000 THEN 5000
                WHEN @total > = 15000 THEN 2000
                WHEN @total >= 10000 THEN 1000
                ELSE 500
            END;
        PRINT CONCAT ('Total Ventas: ', @total, CHAR(13)+CHAR(10), 'Comision: ', @comision,
        'Ventas mas comision: '+@total)

-- SET @comision = 
-- CASE WHEN 



END;
GO

SELECT o.CustomerID, SUM(od.Quantity * od.UnitPrice) AS [Total Ventas]
FROM [Order Details] AS od
INNER JOIN Orders AS o 
ON od.OrderID = o.OrderID
GROUP BY o.CustomerID
```

## Stored procedure con inserts Update y Delete

Los SP para madejo de un CRUD

-CREATE (Insert)
-READ (Select)
-UPDATE (Update)
-DELETE (Delete)
