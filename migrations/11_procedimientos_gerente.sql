START TRANSACTION;

-- GERENTE: Procedimiento para generar reportes de ventas mensuales
-- Permite al gerente analizar el desempeño de ventas por mes especifico
DELIMITER //
CREATE PROCEDURE GenerarReporteMensual(
    IN p_mes INT,         -- Mes a consultar (1-12)
    IN p_anio INT         -- Año a consultar
)
BEGIN
    -- Reporte detallado dia por dia del mes solicitado
    SELECT 
        DATE(v.fecha_hora) as fecha,           -- Fecha de la venta
        COUNT(v.id_venta) as total_ventas,     -- Numero de ventas del dia
        SUM(v.total) as monto_total,           -- Ingresos totales del dia
        AVG(v.total) as venta_promedio         -- Venta promedio del dia
    FROM venta v
    WHERE MONTH(v.fecha_hora) = p_mes          -- Filtrar por mes
    AND YEAR(v.fecha_hora) = p_anio            -- Filtrar por año
    GROUP BY DATE(v.fecha_hora)                -- Agrupar por dia
    ORDER BY fecha;                            -- Ordenar por fecha
END//
DELIMITER ;

COMMIT;

SELECT 'Procedimiento GenerarReporteMensual creado exitosamente' as status;