#Fundamentos Programables

1. ¿Que es la parte rogramable de T-SQL

Es todo lo que perite:
-Usar variables
-Control del flujo
-Crear procedimientos Almacenados (Store Procedure)
-Manejar Errores
-Crear Funciones
-Usar transacciones
-Disparadores (Triggers)

Nota: Es convertir SQL en un lenguaje casi como c/java pero dentro del engine

2.Variables
Una variable almacena un valor temporal


'''
use Northwind
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

/*============================Ejercicios con variables=============================*/
'''

3.IF-ELSE
Permite ejecutar codigo segun una condicion

4. WHILE

'''
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
'''

## Procedimientos almacenados (Store Procedures)

5.  ¿Que es un store procedure?

Es un bloque de codigo guardado en la base de datos que se puede ejecutar cuando se necesite

'''sql
CREATE PROCEDURE usp_objeto_accion
[Parametros] --entrecorchete es opcional
AS
BEGIN
---BODY
END
-----------
CREATE PROC usp_objeto_accion
[Parametros] --entrecorchete es opcional
AS
BEGIN
---BODY
END
-------------
CREATE OR ALTER PROCEDURE usp_objeto_accion
[Parametros] --entrecorchete es opcional
AS
BEGIN
---BODY
END
'''