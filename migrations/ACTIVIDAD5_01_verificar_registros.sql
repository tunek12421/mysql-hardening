-- ACTIVIDAD5_01: Verificar registros insertados en las migraciones
-- Verificar que los registros de las migraciones 03, 04 y 05 se insertaron correctamente

USE TiendaDB;

SELECT '=== RESUMEN REGISTROS ===' as seccion;
SELECT 'categoria' as tabla, COUNT(*) as total FROM categoria
UNION SELECT 'proveedor', COUNT(*) FROM proveedor
UNION SELECT 'empleado', COUNT(*) FROM empleado
UNION SELECT 'cliente', COUNT(*) FROM cliente
UNION SELECT 'producto', COUNT(*) FROM producto
UNION SELECT 'venta', COUNT(*) FROM venta
UNION SELECT 'detalle_venta', COUNT(*) FROM detalle_venta
UNION SELECT 'pago', COUNT(*) FROM pago
UNION SELECT 'pedido', COUNT(*) FROM pedido
UNION SELECT 'detalle_pedido', COUNT(*) FROM detalle_pedido
ORDER BY tabla;

SELECT '=== CATEGORIAS ===' as seccion;
SELECT * FROM categoria ORDER BY id_categoria LIMIT 6;

SELECT '=== PROVEEDORES ===' as seccion;
SELECT id_proveedor, nombre, telefono FROM proveedor ORDER BY id_proveedor LIMIT 6;

SELECT '=== EMPLEADOS ===' as seccion;
SELECT id_empleado, nombre_completo, cargo FROM empleado ORDER BY id_empleado LIMIT 6;

SELECT '=== CLIENTES ===' as seccion;
SELECT codigo_cliente, nombre, telefono FROM cliente ORDER BY codigo_cliente LIMIT 6;

SELECT '=== PRODUCTOS ===' as seccion;
SELECT codigo_producto, nombre, precio, stock FROM producto ORDER BY codigo_producto LIMIT 6;

SELECT '=== VENTAS ===' as seccion;
SELECT id_venta, DATE(fecha_hora) as fecha, codigo_cliente, id_empleado FROM venta ORDER BY id_venta LIMIT 6;

SELECT v.id_venta, DATE(v.fecha_hora) as fecha, c.nombre as cliente, e.nombre_completo as empleado
FROM venta v
JOIN cliente c ON v.codigo_cliente = c.codigo_cliente
JOIN empleado e ON v.id_empleado = e.id_empleado
ORDER BY v.id_venta LIMIT 6;

SELECT '=== DETALLES VENTA ===' as seccion;
SELECT id_venta, codigo_producto, cantidad, precio_unitario FROM detalle_venta ORDER BY id_venta, codigo_producto LIMIT 6;

SELECT dv.id_venta, dv.codigo_producto, p.nombre as producto, dv.cantidad, dv.precio_unitario
FROM detalle_venta dv
JOIN producto p ON dv.codigo_producto = p.codigo_producto
ORDER BY dv.id_venta, dv.codigo_producto LIMIT 6;

SELECT '=== PAGOS ===' as seccion;
SELECT id_venta, metodo_pago, monto, fecha_pago FROM pago ORDER BY id_venta LIMIT 6;

SELECT '=== PEDIDOS ===' as seccion;
SELECT id_pedido, fecha_pedido, estado, id_proveedor FROM pedido ORDER BY id_pedido LIMIT 6;

SELECT pe.id_pedido, pe.fecha_pedido, pe.estado, pr.nombre as proveedor
FROM pedido pe
JOIN proveedor pr ON pe.id_proveedor = pr.id_proveedor
ORDER BY pe.id_pedido LIMIT 6;

SELECT '=== DETALLES PEDIDO ===' as seccion;
SELECT id_pedido, codigo_producto, cantidad, precio_unitario FROM detalle_pedido ORDER BY id_pedido, codigo_producto LIMIT 6;

SELECT dp.id_pedido, dp.codigo_producto, p.nombre as producto, dp.cantidad, dp.precio_unitario
FROM detalle_pedido dp
JOIN producto p ON dp.codigo_producto = p.codigo_producto
ORDER BY dp.id_pedido, dp.codigo_producto LIMIT 6;

SELECT '=== PRODUCTOS POR CATEGORIA ===' as seccion;
SELECT c.nombre as categoria, COUNT(p.codigo_producto) as cantidad_productos
FROM categoria c
LEFT JOIN producto p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre
ORDER BY c.id_categoria;