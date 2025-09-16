START TRANSACTION;

-- ADMIN TECNICO: Crear indice para optimizar consultas de ventas por fecha
CREATE INDEX IF NOT EXISTS idx_venta_fecha_total_admin ON venta(fecha_hora, total);

-- ADMIN TECNICO: Actualizacion masiva de precios (ejemplo categoria 1 +10%)
UPDATE producto SET precio = precio * 1.10 WHERE id_categoria = 1;

-- ADMIN TECNICO: Monitorear estado de tablas criticas para mantenimiento
SHOW TABLE STATUS FROM TiendaDB;

COMMIT;

SELECT 'Consultas de administrador tecnico ejecutadas exitosamente' as status;