-- =================================================================
-- ACTIVIDAD 5 - PERSONA B: SUBCONSULTAS
-- =================================================================
-- REQUISITO: 4 consultas usando 2 tipos de subconsultas
-- Tipos implementados: WHERE y FROM

SELECT '=== ACTIVIDAD 5 - 4 SUBCONSULTAS ===' as TITULO;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- =================================================================
-- SUBCONSULTA TIPO 1: EN CLÁUSULA WHERE
-- =================================================================

-- CONSULTA 1: Clientes que han gastado más que el promedio general
SELECT '1. CLIENTES QUE GASTARON MÁS QUE EL PROMEDIO' as CONSULTA;
SELECT 'CONSULTA SQL:' as CODIGO;
SELECT '
SELECT 
    c.codigo_cliente,
    c.nombre,
    c.correo_electronico,
    ROUND(SUM(v.total), 2) as total_gastado
FROM cliente c
JOIN venta v ON c.codigo_cliente = v.codigo_cliente
WHERE c.codigo_cliente IN (
    -- Subconsulta: clientes con ventas superiores al promedio
    SELECT v2.codigo_cliente 
    FROM venta v2 
    WHERE v2.total > (
        SELECT AVG(total) FROM venta
    )
)
GROUP BY c.codigo_cliente, c.nombre, c.correo_electronico
ORDER BY total_gastado DESC;
' as 'CONSULTA_SQL';

SELECT 'RESULTADO:' as EJECUCION;
SELECT 
    c.codigo_cliente,
    c.nombre,
    c.correo_electronico,
    ROUND(SUM(v.total), 2) as total_gastado
FROM cliente c
JOIN venta v ON c.codigo_cliente = v.codigo_cliente
WHERE c.codigo_cliente IN (
    -- Subconsulta: clientes con ventas superiores al promedio
    SELECT v2.codigo_cliente 
    FROM venta v2 
    WHERE v2.total > (
        SELECT AVG(total) FROM venta
    )
)
GROUP BY c.codigo_cliente, c.nombre, c.correo_electronico
ORDER BY total_gastado DESC;

-- CONSULTA 2: Productos con precio mayor al precio promedio de su categoría
SELECT '2. PRODUCTOS CON PRECIO MAYOR AL PROMEDIO DE SU CATEGORÍA' as CONSULTA;
SELECT 'CONSULTA SQL:' as CODIGO;
SELECT '
SELECT 
    p.codigo_producto,
    p.nombre,
    c.nombre as categoria,
    p.precio,
    ROUND((
        SELECT AVG(p2.precio) 
        FROM producto p2 
        WHERE p2.id_categoria = p.id_categoria
    ), 2) as precio_promedio_categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.precio > (
    -- Subconsulta correlacionada: precio promedio por categoría
    SELECT AVG(p2.precio)
    FROM producto p2
    WHERE p2.id_categoria = p.id_categoria
)
ORDER BY p.precio DESC;
' as 'CONSULTA_SQL';

SELECT 'RESULTADO:' as EJECUCION;
SELECT 
    p.codigo_producto,
    p.nombre,
    c.nombre as categoria,
    p.precio,
    ROUND((
        SELECT AVG(p2.precio) 
        FROM producto p2 
        WHERE p2.id_categoria = p.id_categoria
    ), 2) as precio_promedio_categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.precio > (
    -- Subconsulta correlacionada: precio promedio por categoría
    SELECT AVG(p2.precio)
    FROM producto p2
    WHERE p2.id_categoria = p.id_categoria
)
ORDER BY p.precio DESC;

-- =================================================================
-- SUBCONSULTA TIPO 2: EN CLÁUSULA FROM (TABLA DERIVADA)
-- =================================================================

-- CONSULTA 3: Categorías con total de ventas y productos vendidos
SELECT '3. RESUMEN DE VENTAS POR CATEGORÍA' as CONSULTA;
SELECT 'CONSULTA SQL:' as CODIGO;
SELECT '
SELECT 
    c.nombre as categoria,
    ventas_categoria.total_productos_vendidos,
    ventas_categoria.monto_total_ventas,
    ROUND(ventas_categoria.precio_promedio_venta, 2) as precio_promedio
FROM categoria c
JOIN (
    -- Subconsulta en FROM: estadísticas de ventas por categoría
    SELECT 
        p.id_categoria,
        SUM(dv.cantidad) as total_productos_vendidos,
        SUM(dv.cantidad * dv.precio_unitario) as monto_total_ventas,
        AVG(dv.precio_unitario) as precio_promedio_venta
    FROM producto p
    JOIN detalle_venta dv ON p.codigo_producto = dv.codigo_producto
    GROUP BY p.id_categoria
) ventas_categoria ON c.id_categoria = ventas_categoria.id_categoria
ORDER BY ventas_categoria.monto_total_ventas DESC;
' as 'CONSULTA_SQL';

SELECT 'RESULTADO:' as EJECUCION;
SELECT 
    c.nombre as categoria,
    ventas_categoria.total_productos_vendidos,
    ventas_categoria.monto_total_ventas,
    ROUND(ventas_categoria.precio_promedio_venta, 2) as precio_promedio
FROM categoria c
JOIN (
    -- Subconsulta en FROM: estadísticas de ventas por categoría
    SELECT 
        p.id_categoria,
        SUM(dv.cantidad) as total_productos_vendidos,
        SUM(dv.cantidad * dv.precio_unitario) as monto_total_ventas,
        AVG(dv.precio_unitario) as precio_promedio_venta
    FROM producto p
    JOIN detalle_venta dv ON p.codigo_producto = dv.codigo_producto
    GROUP BY p.id_categoria
) ventas_categoria ON c.id_categoria = ventas_categoria.id_categoria
ORDER BY ventas_categoria.monto_total_ventas DESC;

-- CONSULTA 4: Empleados con su desempeño de ventas comparado con el promedio
SELECT '4. DESEMPEÑO DE EMPLEADOS VS PROMEDIO GENERAL' as CONSULTA;
SELECT 'CONSULTA SQL:' as CODIGO;
SELECT '
SELECT 
    e.nombre_completo,
    e.cargo,
    desempeno.total_ventas,
    desempeno.monto_total,
    ROUND(desempeno.venta_promedio, 2) as venta_promedio_empleado,
    ROUND(promedio_general.promedio_sistema, 2) as promedio_general_sistema,
    CASE 
        WHEN desempeno.venta_promedio > promedio_general.promedio_sistema 
        THEN SOBRE EL PROMEDIO
        ELSE BAJO EL PROMEDIO
    END as evaluacion
FROM empleado e
JOIN (
    -- Subconsulta 1 en FROM: desempeño individual por empleado
    SELECT 
        v.id_empleado,
        COUNT(v.id_venta) as total_ventas,
        SUM(v.total) as monto_total,
        AVG(v.total) as venta_promedio
    FROM venta v
    GROUP BY v.id_empleado
) desempeno ON e.id_empleado = desempeno.id_empleado
CROSS JOIN (
    -- Subconsulta 2 en FROM: promedio general del sistema
    SELECT AVG(total) as promedio_sistema
    FROM venta
) promedio_general
ORDER BY desempeno.venta_promedio DESC;
' as 'CONSULTA_SQL';

SELECT 'RESULTADO:' as EJECUCION;
SELECT 
    e.nombre_completo,
    e.cargo,
    desempeno.total_ventas,
    desempeno.monto_total,
    ROUND(desempeno.venta_promedio, 2) as venta_promedio_empleado,
    ROUND(promedio_general.promedio_sistema, 2) as promedio_general_sistema,
    CASE 
        WHEN desempeno.venta_promedio > promedio_general.promedio_sistema 
        THEN 'SOBRE EL PROMEDIO'
        ELSE 'BAJO EL PROMEDIO'
    END as evaluacion
FROM empleado e
JOIN (
    -- Subconsulta 1 en FROM: desempeño individual por empleado
    SELECT 
        v.id_empleado,
        COUNT(v.id_venta) as total_ventas,
        SUM(v.total) as monto_total,
        AVG(v.total) as venta_promedio
    FROM venta v
    GROUP BY v.id_empleado
) desempeno ON e.id_empleado = desempeno.id_empleado
CROSS JOIN (
    -- Subconsulta 2 en FROM: promedio general del sistema
    SELECT AVG(total) as promedio_sistema
    FROM venta
) promedio_general
ORDER BY desempeno.venta_promedio DESC;

SELECT 'EVIDENCIA COMPLETADA - 4 subconsultas ejecutadas exitosamente' as RESULTADO;
SELECT '2 tipos implementados: WHERE (consultas 1 y 2) y FROM (consultas 3 y 4)' as TIPOS_SUBCONSULTA;