-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 1
-- =================================================================
-- Crear una vista llamada ventas_clientes que muestre el nombre del cliente, 
-- la fecha de venta y el total de cada venta.

START TRANSACTION;

-- Crear la vista ventas_clientes
CREATE OR REPLACE VIEW ventas_clientes AS
SELECT 
    c.nombre AS nombre_cliente,           -- Nombre del cliente
    v.fecha_hora AS fecha_venta,          -- Fecha y hora de la venta
    v.total AS total_venta                -- Total de la venta
FROM cliente c
INNER JOIN venta v ON c.codigo_cliente = v.codigo_cliente
ORDER BY v.fecha_hora DESC;               -- Ordenar por fecha más reciente primero

COMMIT;

-- Mostrar confirmación de creación
SELECT 'Vista ventas_clientes creada exitosamente' as resultado;
SELECT 'La vista muestra: nombre_cliente, fecha_venta, total_venta' as descripcion;