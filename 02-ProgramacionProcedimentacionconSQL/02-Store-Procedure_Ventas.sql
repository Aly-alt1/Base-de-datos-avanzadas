USE bdEejm;
GO


CREATE TABLE Producto (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY, 
    Nombre VARCHAR(100),
    Precio DECIMAL(10, 2),
    Existencia INT
);

CREATE TABLE Cliente (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY, -- Agregado IDENTITY
    Nombre VARCHAR(100),
    Pais VARCHAR(50),
    Ciudad VARCHAR(50)
);

CREATE TABLE Venta (
    IdVenta INT IDENTITY(1,1) PRIMARY KEY, 
    Fecha DATETIME DEFAULT GETDATE(),
    IdCliente INT,
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE DetalleVenta (
    IdVenta INT, 
    IdProducto INT,
    PrecioVenta DECIMAL(10, 2),
    Cantidad INT,
    PRIMARY KEY (IdVenta, IdProducto),
    CONSTRAINT FK_Detalle_Venta FOREIGN KEY (IdVenta) REFERENCES Venta(IdVenta),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);
GO

-- Stored Procedure
CREATE OR ALTER PROCEDURE usp_InsertarVenta
    @idCliente INT,
    @idproducto INT,
    @cantidad INT
AS 
BEGIN
    DECLARE @existencia INT, @precioProducto DECIMAL(10,2), @idVentaGenerada INT;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE IdCliente = @idCliente)
            THROW 50001, 'EL CLIENTE NO EXISTE', 1;

        IF NOT EXISTS (SELECT 1 FROM Producto WHERE IdProducto = @idproducto)
            THROW 50002, 'EL PRODUCTO NO EXISTE', 1;

        SELECT @existencia = Existencia, @precioProducto = Precio 
        FROM Producto WHERE IdProducto = @idproducto;

        IF @existencia < @cantidad
            THROW 50003, 'STOCK INSUFICIENTE', 1;
    --VALIDAR QUE EL PRODUCTO EXISTE
    --VERIFICAR EL STOCK CON LA CANTIDAD SOLICITADA
        BEGIN TRANSACTION
        --INSECION VENTAS
    --VERIFICR EL PRECIO DE PRODUCTO
   
            INSERT INTO Venta (Fecha, IdCliente) VALUES (GETDATE(), @idCliente);
            SET @idVentaGenerada = SCOPE_IDENTITY();
 --INSERTAR EN DETALLEVENTAS
            INSERT INTO DetalleVenta (IdVenta, IdProducto, PrecioVenta, Cantidad)
            VALUES (@idVentaGenerada, @idproducto, @precioProducto, @cantidad);
 --ACTUALIZAR STOCK EN PRODUCTO
            UPDATE Producto SET Existencia = Existencia - @cantidad WHERE IdProducto = @idproducto;
        COMMIT;
        
        PRINT 'Venta procesada con el ID: ' + CAST(@idVentaGenerada AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error en la inserción: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Carga de datos
INSERT INTO Cliente (Nombre, Pais, Ciudad) VALUES 
('Ana Martínez', 'México', 'CDMX'),
('Luis Fernández', 'España', 'Madrid'),
('Carla Gómez', 'Argentina', 'Buenos Aires');

INSERT INTO Producto (Nombre, Precio, Existencia) VALUES 
('Laptop Dell XPS', 1500.00, 10),
('Mouse Inalámbrico', 25.50, 50),
('Monitor 27 pulg', 300.00, 15);
GO


-- Ejecución del SP 
EXEC usp_InsertarVenta
 @idCliente = 1, 
 @idproducto = 1, 
 @cantidad = 2;

EXEC usp_InsertarVenta 
@idCliente = 2, 
@idproducto = 2, 
@cantidad = 2;

EXEC usp_InsertarVenta 
@idCliente = 3, 
@idproducto = 3, 
@cantidad = 8;

SELECT * FROM Cliente;
SELECT * FROM Venta;
SELECT * FROM DetalleVenta;
SELECT * FROM Producto;