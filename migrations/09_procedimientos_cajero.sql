START TRANSACTION;

-- CAJERO: Procedimiento para registrar venta completa en una sola operacion
-- Automatiza el proceso de venta + detalle + pago para el cajero
DELIMITER //
CREATE PROCEDURE RegistrarVentaCompleta(
    IN p_codigo_cliente VARCHAR(10),    -- Cliente que compra
    IN p_id_empleado INT,               -- Empleado que atiende
    IN p_codigo_producto VARCHAR(10),   -- Producto vendido
    IN p_cantidad INT,                  -- Cantidad vendida
    IN p_metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia')  -- Como paga
)
BEGIN
    DECLARE v_id_venta INT;
    DECLARE v_precio_unitario DECIMAL(8,2);
    DECLARE v_total DECIMAL(10,2);

    -- Obtener precio actual del producto
    SELECT precio INTO v_precio_unitario FROM producto WHERE codigo_producto = p_codigo_producto;
    SET v_total = v_precio_unitario * p_cantidad;

    -- Crear la venta
    INSERT INTO venta (codigo_cliente, id_empleado, total) VALUES (p_codigo_cliente, p_id_empleado, v_total);
    SET v_id_venta = LAST_INSERT_ID();

    -- Agregar detalle de venta (triggers actualizaran stock automaticamente)
    INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario)
    VALUES (v_id_venta, p_codigo_producto, p_cantidad, v_precio_unitario);

    -- Registrar el pago
    INSERT INTO pago (metodo_pago, monto, id_venta) VALUES (p_metodo_pago, v_total, v_id_venta);
END//
DELIMITER ;

COMMIT;

SELECT 'Procedimiento RegistrarVentaCompleta creado exitosamente' as status;
