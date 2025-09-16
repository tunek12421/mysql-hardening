START TRANSACTION;

-- CAJERO: Vista para consultar productos con bajo stock (menos de 10 unidades)
-- Permite al cajero identificar productos que necesitan reposicion
CREATE VIEW vista_productos_bajo_stock AS
SELECT 
    p.codigo_producto,    -- Codigo del producto
    p.nombre,            -- Nombre del producto
    p.stock,             -- Cantidad disponible
    p.precio,            -- Precio actual
    c.nombre as categoria -- Categoria del producto
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.stock < 10;      -- Solo productos con stock bajo

COMMIT;

SELECT 'Vista productos_bajo_stock creada exitosamente' as status;