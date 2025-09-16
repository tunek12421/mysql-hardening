-- Ejercicio 5: Cree un procedimiento almacenado llamado registrar_venta que:
-- 1. Disminuya el stock de un producto.
-- 2. Inserte una nueva venta.
-- 3. Inserte el detalle de la venta.
-- 4. Confirme la transacción con COMMIT.
USE TiendaDB;

DELIMITER //
CREATE PROCEDURE registrar_venta(
    IN p_codigo_producto VARCHAR(10),
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(8,2),
    IN p_codigo_cliente VARCHAR(10),
    IN p_id_empleado INT
)
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_id_venta INT;

    START TRANSACTION;

    -- 1. Verificar y disminuir stock
    SELECT stock INTO v_stock_actual FROM producto WHERE codigo_producto = p_codigo_producto;

    IF v_stock_actual < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    UPDATE producto
    SET stock = stock - p_cantidad
    WHERE codigo_producto = p_codigo_producto;

    -- 2. Insertar nueva venta
    INSERT INTO venta (fecha_hora, total, codigo_cliente, id_empleado)
    VALUES (NOW(), p_cantidad * p_precio_unitario, p_codigo_cliente, p_id_empleado);

    SET v_id_venta = LAST_INSERT_ID();

    -- 3. Insertar detalle de venta
    INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario)
    VALUES (v_id_venta, p_codigo_producto, p_cantidad, p_precio_unitario);

    -- 4. Confirmar transacción
    COMMIT;

    SELECT v_id_venta as venta_id, 'Venta registrada exitosamente' as resultado;
END//
DELIMITER ;

-- Pruebas
SELECT 'Stock antes de la venta:' as info;
SELECT codigo_producto, stock FROM producto WHERE codigo_producto = 'ELEC-001';

CALL registrar_venta('ELEC-001', 1, 699.99, 'CLI-001', 1);

SELECT 'Stock después de la venta:' as info;
SELECT codigo_producto, stock FROM producto WHERE codigo_producto = 'ELEC-001';

SELECT 'Última venta registrada:' as info;
SELECT v.id_venta, v.total, v.codigo_cliente, dv.codigo_producto, dv.cantidad
FROM venta v
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
ORDER BY v.id_venta DESC LIMIT 1;