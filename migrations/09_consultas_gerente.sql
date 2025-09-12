START TRANSACTION;

-- GERENTE: Generar reporte de ventas del dia (analisis diario de ingresos)
SELECT DATE(v.fecha_hora) as fecha, COUNT(*) as total_ventas, SUM(v.total) as monto_total
FROM venta v 
WHERE DATE(v.fecha_hora) = CURDATE()
GROUP BY DATE(v.fecha_hora);

-- GERENTE: Consultar pagos agrupados por metodo (analisis financiero)
SELECT p.metodo_pago, COUNT(*) as cantidad_pagos, SUM(p.monto) as monto_total
FROM pago p
GROUP BY p.metodo_pago;

-- GERENTE: Reporte de ventas realizadas por empleado (evaluacion desempeño)
SELECT e.nombre_completo, COUNT(v.id_venta) as ventas_realizadas, SUM(v.total) as monto_total
FROM empleado e
LEFT JOIN venta v ON e.id_empleado = v.id_empleado
GROUP BY e.id_empleado, e.nombre_completo;

COMMIT;

SELECT 'Consultas de gerente ejecutadas exitosamente' as status;