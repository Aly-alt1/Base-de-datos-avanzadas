## El esquema se compone de 4 tablas principales:

Producto: Un maestro de artículos que incluye precios y stock

Cliente: Un directorio de compradores

Venta: La cabecera de la transacción (quién realizó la compra y cuándo)

DetalleVenta: Un registro de los productos vendidos en cada transacción

## Explicación del Código (Store Procedure)
El procedimiento usp_InsertarVenta está diseñado para manejar errores y transacciones

##1. Parámetros de Entrada
Recibe tres valores clave: @idCliente, @idproducto y @cantidad

2. Validaciones Previas (Manejo de Excepciones)
el código utiliza THROW para detener la ejecución si:

El cliente no existe (Error 50001)

El producto no existe (Error 50002)

El stock es insuficiente (Error 50003)

3. La Transacción
Se emplea un bloque BEGIN TRANSACTION para garantizar que los siguientes tres pasos se realicen como una unidad indivisible:

Inserción en Venta: Crea el encabezado y captura el ID generado con SCOPE_IDENTITY()

Inserción en DetalleVenta: Registra el producto vendido utilizando el precio del maestro de productos

Actualización de Stock: Ejecuta un UPDATE restando la cantidad vendida en la tabla Producto

4. Control de Errores (TRY...CATCH)
COMMIT: Si todo sale bien, los cambios se hacen permanentes

ROLLBACK: Si ocurre algún error durante la transacción, se revierten todos los cambios 

```sql

CREATE OR ALTER PROCEDURE usp_InsertarVenta
    @idCliente INT,
    @idproducto INT,
    @cantidad INT
AS 
BEGIN
    DECLARE @existencia INT,
     @precioProducto DECIMAL(10,2), 
     @idVentaGenerada INT;

    BEGIN TRY
        -- 1. VALIDACIONES DE INTEGRIDAD
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE IdCliente = @idCliente)
            THROW 50001, 'EL CLIENTE NO EXISTE', 1;

        IF NOT EXISTS (SELECT 1 FROM Producto WHERE IdProducto = @idproducto)
            THROW 50002, 'EL PRODUCTO NO EXISTE', 1;

        -- Obtener datos actuales del producto
        SELECT @existencia = Existencia, @precioProducto = Precio 
        FROM Producto WHERE IdProducto = @idproducto;

        -- 2. VALIDACIÓN DE STOCK
        IF @existencia < @cantidad
            THROW 50003, 'STOCK INSUFICIENTE', 1;

        -- 3. PROCESAMIENTO DE LA TRANSACCIÓN
        BEGIN TRANSACTION
            -- Insertarventa
            INSERT INTO Venta (Fecha, IdCliente) VALUES (GETDATE(), @idCliente);
            SET @idVentaGenerada = SCOPE_IDENTITY();

            -- Insertar detalle de venta
            INSERT INTO DetalleVenta (IdVenta, IdProducto, PrecioVenta, Cantidad)
            VALUES (@idVentaGenerada, @idproducto, @precioProducto, @cantidad);

            -- Actualizar inventario
            UPDATE Producto SET Existencia = Existencia - @cantidad 
            WHERE IdProducto = @idproducto;
        COMMIT;
        
        PRINT 'Venta procesada con éxito. ID Generado: ' + CAST(@idVentaGenerada AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        -- Si hubo un error y hay una transacción activa se deshace
        IF @@TRANCOUNT > 0 ROLLBACK;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error detectado: ' + @ErrorMessage;
    END CATCH
END;
GO
```
