START TRANSACTION;

-- GERENTE: Vista para obtener clientes con mayor volumen de compras
-- Identifica los clientes mas valiosos para estrategias de fidelizacion
CREATE VIEW vista_clientes_mayor_volumen AS
SELECT 
    c.codigo_cliente,                      -- Codigo del cliente
    c.nombre,                              -- Nombre del cliente
    COUNT(v.id_venta) as total_compras,    -- Numero total de compras
    SUM(v.total) as monto_total,           -- Monto total gastado
    AVG(v.total) as compra_promedio        -- Compra promedio por visita
FROM cliente c
JOIN venta v ON c.codigo_cliente = v.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre
HAVING COUNT(v.id_venta) > 1               -- Solo clientes con mas de 1 compra
ORDER BY monto_total DESC;                 -- Ordenar por mayor gasto

COMMIT;

SELECT 'Vista clientes_mayor_volumen creada exitosamente' as status;