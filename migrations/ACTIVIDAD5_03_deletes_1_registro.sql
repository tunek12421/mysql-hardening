-- ACTIVIDAD5_03: Eliminar 1 registro por tabla
-- IMPORTANTE: Eliminar primero registros dependientes para evitar errores de FK
USE TiendaDB;

SELECT '=== ELIMINANDO REGISTROS ===' as accion;

-- 1. Eliminar de tablas dependientes primero (respetando foreign keys)
SELECT 'Eliminando 1 detalle de pedido...' as mensaje;
DELETE FROM detalle_pedido WHERE id_pedido = 10 AND codigo_producto = 'MAS-001' LIMIT 1;

SELECT 'Eliminando 1 detalle de venta...' as mensaje;
DELETE FROM detalle_venta WHERE id_venta = 10 LIMIT 1;

SELECT 'Eliminando 1 pago...' as mensaje;
DELETE FROM pago WHERE id_venta = 10 LIMIT 1;

-- 2. Eliminar de tablas principales
SELECT 'Eliminando 1 venta...' as mensaje;
DELETE FROM venta WHERE id_venta = 10 LIMIT 1;

SELECT 'Eliminando 1 pedido...' as mensaje;
DELETE FROM pedido WHERE id_pedido = 10 LIMIT 1;

-- 3. Eliminar de tablas maestras
SELECT 'Eliminando 1 producto...' as mensaje;
DELETE FROM producto WHERE codigo_producto = 'MAS-002' LIMIT 1;

SELECT 'Eliminando 1 cliente...' as mensaje;
DELETE FROM cliente WHERE codigo_cliente = 'CLI-010' LIMIT 1;

SELECT 'Eliminando 1 empleado...' as mensaje;
DELETE FROM empleado WHERE id_empleado = 10 LIMIT 1;

SELECT 'Eliminando 1 proveedor...' as mensaje;
DELETE FROM proveedor WHERE id_proveedor = 10 LIMIT 1;

-- 4. Eliminar de tablas de referencia (categorías al final)
SELECT 'Eliminando 1 categoría...' as mensaje;
DELETE FROM categoria WHERE id_categoria = 20 LIMIT 1;

SELECT '=== ELIMINACIONES COMPLETADAS ===' as resultado;
SELECT 'Se eliminó 1 registro de cada tabla respetando dependencias' as mensaje;