CREATE DATABASE bd_triggers;
GO

USE bd_triggers;

CREATE TABLE Productos(
    id INT PRIMARY KEY,
    nombre VARCHAR (50),
    precio DECIMAL (10,2)
)
GO

SELECT * FROM Productos;
GO
--EJERCICIO 1 EVENTO INSERT
CREATE OR ALTER TRIGGER trg_test_insert --aqui se crea el trigger
ON Productos        --TABLA A LA QUE SE ASOCIA EL TRIGGER
AFTER INSERT        --ESTE ES EL EVENTO CON EL QUE SE A A DISPARAR
AS
BEGIN
    SELECT * FROM inserted;
    SELECT * FROM Productos;
END;
GO

--EVALUAR

INSERT INTO Productos (id, nombre,precio)
VALUES(1, 'BACALAO', 300);

INSERT INTO Productos (id, nombre,precio)
VALUES(2, 'REYES', 300);

INSERT INTO Productos (id, nombre,precio)
VALUES(3, 'BICAÑAS', 9570);

INSERT INTO Productos (id, nombre,precio)
VALUES(4, '30X30', 18),
        (5,'CHARANDA',5.50)

INSERT INTO Productos (id, nombre,precio)
VALUES(6, 'Don Peter', 100),
        (7,'Presimuerte', 98)

GO
--EVENTO DELETE

CREATE OR ALTER TRIGGER trg_test_delete
ON Productos
AFTER DELETE
AS
BEGIN
    SELECT * FROM deleted;
    SELECT * FROM inserted;
    SELECT * FROM Productos;
END;

DELETE FROM Productos WHERE id = 2;
GO
--EVENTO UPDATE

CREATE OR ALTER TRIGGER trg_test_update
ON Productos
AFTER UPDATE 
AS
BEGIN
    SELECT * FROM inserted;
    SELECT * FROM deleted;
END;

UPDATE Productos
SET precio = 600
WHERE id = 2;

--realizar un trigger que permita cancelar la operacion si se insertan mas de 
--un registro al mismo tiempo
CREATE TABLE Productos2(
    id INT PRIMARY KEY,
    nombre VARCHAR (50),
    precio DECIMAL (10,2)
)
GO


CREATE OR ALTER TRIGGER trg_un_solo_registro
ON Productos2
AFTER INSERT
AS
BEGIN
        --contar el numero de registros insertados 
        IF (SELECT COUNT(*) FROM inserted) > 1
        BEGIN
            RAISERROR ('SOLO SE PERMITE INSERTAR UN REGISTRO A LA VEZ',16,1);
            ROLLBACK TRANSACTION
        END;
END;
GO

SELECT * FROM Productos2;

INSERT INTO Productos2 (id, nombre,precio)
VALUES(1, 'Don Peter', 100),
VALUES(2,'Presimuerte', 98);
GO
--realiza run trigger qie detecte un cambio en el registro y mande un mensaje qde que 
--el precio se cambio

CREATE OR ALTER TRIGGER trg_validar_cambio
ON Productos2
AFTER UPDATE
AS
BEGIN

IF EXISTS(
        SELECT 1
        FROM inserted AS i
        INNER JOIN
        deleted as d
        ON i.id = d.id 
        WHERE i.precio <> d.precio;
        )
BEGIN
    PRINT 'EL precio fue cambiado';
END;
END;
GO

--un triger que evite que cambie el precio de la tabla de detalleventa
use NORTHWND;
GO

CREATE OR ALTER TRIGGER trg_cambio_precio_no
ON [Detalle Venta]
AFTER UPDATE 