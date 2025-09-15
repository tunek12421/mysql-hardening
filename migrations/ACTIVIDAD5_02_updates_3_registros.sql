-- ACTIVIDAD5_02: Actualizar 3 registros por tabla
USE TiendaDB;

SELECT '=== ACTUALIZANDO REGISTROS ===' as accion;

-- 1. Actualizar 3 categorías - cambiar descripción
SELECT 'Actualizando 3 categorías...' as mensaje;
UPDATE categoria SET descripcion = CONCAT(descripcion, ' - ACTUALIZADO')
WHERE id_categoria IN (1, 2, 3);

-- 2. Actualizar 3 proveedores - modificar teléfono
SELECT 'Actualizando 3 proveedores...' as mensaje;
UPDATE proveedor SET telefono = CONCAT('UPD-', telefono)
WHERE id_proveedor IN (1, 2, 3);

-- 3. Actualizar 3 empleados - aumentar salario en 10%
SELECT 'Actualizando 3 empleados...' as mensaje;
UPDATE empleado SET salario = salario * 1.10
WHERE id_empleado IN (1, 2, 3);

-- 4. Actualizar 3 clientes - cambiar teléfono
SELECT 'Actualizando 3 clientes...' as mensaje;
UPDATE cliente SET telefono = CONCAT('NEW-', telefono)
WHERE codigo_cliente IN ('CLI-001', 'CLI-002', 'CLI-003');

-- 5. Actualizar 3 productos - aumentar precio en 5%
SELECT 'Actualizando 3 productos...' as mensaje;
UPDATE producto SET precio = precio * 1.05
WHERE codigo_producto IN ('ELEC-001', 'ELEC-002', 'ROPA-001');

-- 6. Actualizar 3 ventas - cambiar total
SELECT 'Actualizando 3 ventas...' as mensaje;
UPDATE venta SET total = 999.99
WHERE id_venta IN (1, 2, 3);

-- 7. Actualizar 3 detalles de venta - modificar cantidad
SELECT 'Actualizando 3 detalles de venta...' as mensaje;
UPDATE detalle_venta SET cantidad = cantidad + 1
WHERE id_venta = 1 OR id_venta = 2 OR id_venta = 3
LIMIT 3;

-- 8. Actualizar 3 pagos - cambiar método de pago
SELECT 'Actualizando 3 pagos...' as mensaje;
UPDATE pago SET metodo_pago = 'tarjeta_credito'
WHERE id_venta IN (1, 2, 3);

-- 9. Actualizar 3 pedidos - cambiar estado
SELECT 'Actualizando 3 pedidos...' as mensaje;
UPDATE pedido SET estado = 'procesando'
WHERE id_pedido IN (1, 2, 3);

-- 10. Actualizar 3 detalles de pedido - modificar precio unitario
SELECT 'Actualizando 3 detalles de pedido...' as mensaje;
UPDATE detalle_pedido SET precio_unitario = precio_unitario * 1.08
WHERE id_pedido IN (1, 2, 3)
LIMIT 3;

SELECT '=== ACTUALIZACIONES COMPLETADAS ===' as resultado;
SELECT 'Se actualizaron 3 registros en cada tabla' as mensaje;