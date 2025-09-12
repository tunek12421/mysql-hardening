START TRANSACTION;

-- CAJERO: Consultar productos disponibles (requiere JOIN con categoria)
SELECT p.codigo_producto, p.nombre, p.precio, p.stock, c.nombre as categoria
FROM producto p 
JOIN categoria c ON p.id_categoria = c.id_categoria 
WHERE p.stock > 0;

-- CAJERO: Buscar informacion del cliente antes de registrar venta
SELECT codigo_cliente, nombre, correo_electronico, telefono 
FROM cliente 
WHERE codigo_cliente = 'CLI-001';

-- CAJERO: Registrar nueva venta (total se calcula automaticamente por triggers)
INSERT INTO venta (codigo_cliente, id_empleado, total) 
VALUES ('CLI-001', 1, 0.00);

-- Guardar ID de venta para las siguientes operaciones
SET @venta_id = LAST_INSERT_ID();

-- CAJERO: Registrar detalle de venta (que productos se vendieron)
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) 
VALUES (@venta_id, 'AUT-001', 2, 25.99);

-- CAJERO: Registrar como pago el cliente (metodo y monto)
INSERT INTO pago (metodo_pago, monto, id_venta) 
VALUES ('efectivo', 51.98, @venta_id);

COMMIT;

SELECT 'Consultas de cajero ejecutadas exitosamente' as status;