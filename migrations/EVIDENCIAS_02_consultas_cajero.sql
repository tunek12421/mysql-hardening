-- =================================================================
-- EVIDENCIAS PDF PARTE 2 - PUNTO 3: CONSULTAS DEL CAJERO
-- =================================================================
-- EJECUTAR COMO: mysql -u cajero -pcajero123 TiendaDB < EVIDENCIAS_02_consultas_cajero.sql

SELECT '=== CONSULTAS DEL CAJERO ===' as EVIDENCIA;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- CONSULTA 1: Registrar una venta (usando procedimiento)
SELECT '1. REGISTRAR VENTA COMPLETA - Procedimiento almacenado' as CONSULTA;
CALL RegistrarVentaCompleta('CLI-004', 2, 'ELEC-001', 1, 'tarjeta');
SELECT 'Venta registrada exitosamente' as RESULTADO;

-- CONSULTA 2: Registrar un pago individual
SELECT '2. REGISTRAR PAGO INDIVIDUAL' as CONSULTA;
INSERT INTO venta (codigo_cliente, id_empleado, total) VALUES ('CLI-005', 2, 0.00);
SET @venta_nueva = LAST_INSERT_ID();
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) 
VALUES (@venta_nueva, 'BEL-001', 2, 32.99);
INSERT INTO pago (metodo_pago, monto, id_venta) VALUES ('efectivo', 65.98, @venta_nueva);
SELECT 'Pago registrado exitosamente' as RESULTADO;

-- CONSULTA 3: Consultar clientes registrados
SELECT '3. CLIENTES REGISTRADOS' as CONSULTA;
SELECT codigo_cliente, nombre, correo_electronico, telefono 
FROM cliente 
ORDER BY nombre
LIMIT 5;

-- CONSULTA 4: Consultar productos disponibles en stock
SELECT '4. PRODUCTOS DISPONIBLES EN STOCK' as CONSULTA;
SELECT p.codigo_producto, p.nombre, p.precio, p.stock, c.nombre as categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.stock > 0
ORDER BY p.stock DESC
LIMIT 5;

SELECT 'EVIDENCIA COMPLETADA - Todas las consultas del cajero ejecutadas' as RESULTADO;