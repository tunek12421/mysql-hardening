-- =================================================================
-- EVIDENCIAS PDF PARTE 2 - PUNTO 3: CONSULTAS DEL GERENTE
-- =================================================================

SELECT '=== CONSULTAS DEL GERENTE ===' as EVIDENCIA;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- CONSULTA 1: Ventas totales por cliente
SELECT '1. VENTAS TOTALES POR CLIENTE' as CONSULTA;
SELECT c.codigo_cliente, c.nombre, 
       COUNT(v.id_venta) as total_ventas,
       COALESCE(SUM(v.total), 0) as monto_total
FROM cliente c
LEFT JOIN venta v ON c.codigo_cliente = v.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre
ORDER BY monto_total DESC
LIMIT 5;

-- CONSULTA 2: Crear índice en productos.categoría (DEBE FUNCIONAR tras corrección)
SELECT '2. CREAR ÍNDICE EN PRODUCTOS.CATEGORIA' as CONSULTA;
CREATE INDEX IF NOT EXISTS idx_producto_categoria_evidencia ON producto(id_categoria);
SELECT 'Indice creado exitosamente - Permisos INDEX funcionando' as RESULTADO;

-- Verificar índice creado
SELECT 'Indices existentes en tabla producto:' as VERIFICACION;
SHOW INDEX FROM producto WHERE Key_name LIKE '%categoria%';

-- CONSULTA 3: Reporte de pagos por método
SELECT '3. REPORTE DE PAGOS POR MÉTODO' as CONSULTA;
SELECT metodo_pago, 
       COUNT(*) as cantidad_pagos,
       SUM(monto) as monto_total,
       ROUND(AVG(monto), 2) as pago_promedio
FROM pago
GROUP BY metodo_pago
ORDER BY monto_total DESC;

-- CONSULTA 4: Ventas realizadas por empleado
SELECT '4. VENTAS REALIZADAS POR EMPLEADO' as CONSULTA;
SELECT e.nombre_completo, 
       COUNT(v.id_venta) as ventas_realizadas,
       COALESCE(SUM(v.total), 0) as monto_total
FROM empleado e
LEFT JOIN venta v ON e.id_empleado = v.id_empleado
GROUP BY e.id_empleado, e.nombre_completo
ORDER BY monto_total DESC
LIMIT 5;

-- CONSULTA 5: Clientes que no realizaron ninguna compra
SELECT '5. CLIENTES SIN COMPRAS' as CONSULTA;
SELECT c.codigo_cliente, c.nombre, c.correo_electronico
FROM cliente c
LEFT JOIN venta v ON c.codigo_cliente = v.codigo_cliente
WHERE v.codigo_cliente IS NULL
ORDER BY c.nombre;

SELECT 'EVIDENCIA COMPLETADA - Todas las consultas del gerente ejecutadas' as RESULTADO;