-- Ejercicio 7: Cree un procedimiento almacenado llamado registrar_proveedor_pedido que:
-- 1. Inserte un nuevo proveedor válido.
-- 2. Cree un SAVEPOINT.
-- 3. Intente insertar un pedido con un proveedor inexistente.
-- 4. Revierta solo el error con ROLLBACK TO SAVEPOINT.
-- 5. Confirme los datos válidos con COMMIT.
USE TiendaDB;

DELIMITER //
CREATE PROCEDURE registrar_proveedor_pedido()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK TO SAVEPOINT sp_antes_pedido;
        SELECT 'Error en pedido - Revirtiendo solo el pedido, manteniendo proveedor' as resultado;
        COMMIT;
    END;

    START TRANSACTION;

    -- 1. Insertar proveedor válido
    INSERT INTO proveedor (nombre, telefono, direccion, correo_electronico)
    VALUES ('Nuevo Proveedor Test', '555-1234', 'Calle Nueva 456', 'nuevo@test.com');

    SELECT 'Proveedor insertado correctamente' as paso1;

    -- 2. Crear SAVEPOINT
    SAVEPOINT sp_antes_pedido;

    -- 3. Intentar insertar pedido con proveedor inexistente
    INSERT INTO pedido (fecha_pedido, estado, id_proveedor)
    VALUES (CURDATE(), 'pendiente', 999999);

    -- Si llega aquí, no hubo error
    COMMIT;
    SELECT 'Ambas operaciones exitosas' as resultado;
END//
DELIMITER ;

-- Pruebas
SELECT 'Proveedores antes:' as info;
SELECT COUNT(*) as total_proveedores FROM proveedor;

SELECT 'Pedidos antes:' as info;
SELECT COUNT(*) as total_pedidos FROM pedido;

CALL registrar_proveedor_pedido();

SELECT 'Proveedores después:' as info;
SELECT COUNT(*) as total_proveedores FROM proveedor;

SELECT 'Último proveedor insertado:' as info;
SELECT id_proveedor, nombre FROM proveedor ORDER BY id_proveedor DESC LIMIT 1;

SELECT 'Pedidos después:' as info;
SELECT COUNT(*) as total_pedidos FROM pedido;