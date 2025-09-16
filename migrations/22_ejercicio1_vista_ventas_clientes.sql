-- Ejercicio 1: Crear vista ventas_clientes
-- Muestra el nombre del cliente, la fecha de venta y el total de cada venta
USE TiendaDB;

START TRANSACTION;

SELECT '=== CREANDO VISTA VENTAS_CLIENTES ===' as accion;

-- Crear vista ventas_clientes
CREATE VIEW ventas_clientes AS
SELECT
    c.nombre AS cliente_nombre,
    DATE(v.fecha_hora) AS fecha_venta,
    v.total AS total_venta
FROM
    venta v
    INNER JOIN cliente c ON v.codigo_cliente = c.codigo_cliente
ORDER BY
    v.fecha_hora DESC;

SELECT 'Vista ventas_clientes creada exitosamente' as resultado;

-- Mostrar algunos registros de la vista
SELECT '=== DATOS DE LA VISTA ===' as seccion;
SELECT * FROM ventas_clientes LIMIT 10;

COMMIT;

SELECT 'Ejercicio 1 completado - Vista ventas_clientes disponible' as status;