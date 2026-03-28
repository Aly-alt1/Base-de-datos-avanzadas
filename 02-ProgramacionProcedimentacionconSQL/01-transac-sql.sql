use NORTHWND
GO
/*===================================Variables=====================================*/

DECLARE @Edad INT 
SET @Edad = 24 --hay que poner un set antes de una variable para asignarle un valor

SELECT @Edad AS Edad
PRINT CONCAT('La edad es: ', '',@Edad)

/*============================Ejercicios con variables=============================*/

/*
1.Declarar una variable llada precio
2.Asignarle el valor de 150
3.Calcular el iva del16%
4.Mostrar el total 
*/

DECLARE @Precio MONEY = 150 --Se le declara un valor inicial 
DECLARE @total MONEY 
SET @total = @Precio * 0.16

SELECT  @total AS Total

/*============================IF/ELSE=============================*/

DECLARE @edad2 INT
SET @edad2 = 18

IF @edad >= 18
BEGIN
    PRINT 'Es mayor de edad'
    PRINT 'Felicidades'
END
ELSE
    PRINT 'Es menor'
/*============================Ejercicios IF/ELSE=============================*/

/*
1.crear una variable calificacion
2.Evaluar si es mayor a 70 imprimir "Aprubatoria", sino "Reprobado"
*/

--TODO: CICLO WHILE

DECLARE @calificacion INT
SET @calificacion = 80

IF @calificacion >= 70
BEGIN
    PRINT 'Aprobatoria'
END
ELSE
    PRINT 'Reprobado'


DECLARE @contador INT;
Declare @contador2 INT = 1;

SET @contador = 1;

WHILE @contador <=5
BEGIN

    WHILE @contador2 <= 5
    BEGIN 
    PRINT CONCAT(@contador, '-', @contador2);
    SET @contador2 = @contador2 + 1
    end;

    SET @contador2 = 1
    SET @contador = @contador + 1
END;
GO

--imprime los numeros del 10 al 1

Declare @numeros INT
SET @numeros = 10
WHILE @numeros >= 1
BEGIN
    PRINT @numeros
    SET @numeros = @numeros - 1
END;


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

/*==================================EJERCICIOS ===================================*/
--CREAR UN STORE PROCEDURE QUE IMPRIMA LA FECHA ACTAL

CREATE OR ALTER PROC sp_FechaActual
AS
BEGIN
    SELECT GETDATE() AS [Fecha actual];
END;
    GO

EXEC sp_FechaActual
GO

CREATE OR ALTER PROC sp_FechaActual_mostrar2
AS
BEGIN
    SELECT CAST(GETDATE() AS DATE) AS [Fecha actual];
END;
    GO

EXEC sp_FechaActual_mostrar2
GO

--crear un store procedure que muestre el nombre de la base de datos actual

CREATE OR ALTER PROC usp_NombreDB_mostrar
AS
BEGIN
    SELECT DB_NAME() AS [nombre db]
END;

EXEC usp_NombreDB_mostrar;