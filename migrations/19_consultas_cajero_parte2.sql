START TRANSACTION;

-- CAJERO - CONSULTAS PDF PARTE 2
-- Usuario: cajero, Password: cajero123

-- 1. Registrar una venta completa (usando procedimiento existente)
CALL RegistrarVentaCompleta('CLI-001', 1, 'AUT-001', 2, 'efectivo');

-- 2. Registrar un pago asociado a una venta (individual)
INSERT INTO venta (codigo_cliente, id_empleado, total) VALUES ('CLI-002', 1, 0.00);
SET @nueva_venta = LAST_INSERT_ID();
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) 
VALUES (@nueva_venta, 'HOGAR-002', 1, 15.50);
INSERT INTO pago (metodo_pago, monto, id_venta) VALUES ('tarjeta', 15.50, @nueva_venta);

-- 3. Consultar clientes registrados
SELECT codigo_cliente, nombre, correo_electronico, telefono 
FROM cliente 
ORDER BY nombre;

-- 4. Consultar productos disponibles en stock
SELECT p.codigo_producto, p.nombre, p.precio, p.stock, c.nombre as categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.stock > 0
ORDER BY c.nombre, p.nombre;

COMMIT;

SELECT 'Consultas de CAJERO ejecutadas exitosamente - PDF Parte 2' as status;
