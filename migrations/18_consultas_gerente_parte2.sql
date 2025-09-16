START TRANSACTION;

-- GERENTE - CONSULTAS PDF PARTE 2  
-- Usuario: gerente, Password: gerente123

-- 1. Ventas totales por cliente
SELECT c.codigo_cliente, c.nombre, 
       COUNT(v.id_venta) as total_ventas,
       SUM(v.total) as monto_total
FROM cliente c
LEFT JOIN venta v ON c.codigo_cliente = v.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre
ORDER BY monto_total DESC;

-- 2. Crear un índice en la tabla productos, columna categoría
CREATE INDEX idx_producto_categoria_gerente ON producto(id_categoria);

-- 3. Reporte de pagos por método
SELECT metodo_pago, 
       COUNT(*) as cantidad_pagos,
       SUM(monto) as monto_total,
       AVG(monto) as pago_promedio
FROM pago
GROUP BY metodo_pago
ORDER BY monto_total DESC;

-- 4. Ventas realizadas por empleado
SELECT e.nombre_completo, 
       COUNT(v.id_venta) as ventas_realizadas,
       COALESCE(SUM(v.total), 0) as monto_total
FROM empleado e
LEFT JOIN venta v ON e.id_empleado = v.id_empleado
GROUP BY e.id_empleado, e.nombre_completo
ORDER BY monto_total DESC;

-- 5. Clientes que no realizaron ninguna compra
SELECT c.codigo_cliente, c.nombre, c.correo_electronico
FROM cliente c
LEFT JOIN venta v ON c.codigo_cliente = v.codigo_cliente
WHERE v.codigo_cliente IS NULL
ORDER BY c.nombre;

COMMIT;

SELECT 'Consultas de GERENTE ejecutadas exitosamente - PDF Parte 2' as status;