START TRANSACTION;

-- ADMIN TECNICO: Vista administrativa para monitoreo de tablas criticas
-- Proporciona metricas diarias de los ultimos 30 dias para analisis del sistema
CREATE VIEW vista_monitoreo_ventas AS
SELECT 
    DATE(v.fecha_hora) as fecha,                           -- Fecha de las ventas
    COUNT(v.id_venta) as total_ventas,                     -- Numero de transacciones
    SUM(v.total) as ingresos_diarios,                      -- Ingresos del dia
    COUNT(DISTINCT v.codigo_cliente) as clientes_unicos,   -- Clientes diferentes que compraron
    COUNT(DISTINCT v.id_empleado) as empleados_activos     -- Empleados que hicieron ventas
FROM venta v
WHERE v.fecha_hora >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) -- Ultimos 30 dias
GROUP BY DATE(v.fecha_hora)                                -- Agrupar por dia
ORDER BY fecha DESC;                                       -- Mas reciente primero

COMMIT;

SELECT 'Vista monitoreo_ventas creada exitosamente' as status;