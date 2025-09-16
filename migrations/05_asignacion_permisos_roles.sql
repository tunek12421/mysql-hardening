START TRANSACTION;

-- CAJERO: registrar ventas, pagos y consultar productos/clientes
GRANT SELECT ON TiendaDB.producto TO 'cajero'@'localhost';        -- Ver productos disponibles
GRANT SELECT ON TiendaDB.categoria TO 'cajero'@'localhost';       -- Indispensable para JOINs con producto
GRANT SELECT ON TiendaDB.cliente TO 'cajero'@'localhost';         -- Buscar y validar datos del cliente
GRANT INSERT, SELECT ON TiendaDB.venta TO 'cajero'@'localhost';   -- Crear ventas y obtener LAST_INSERT_ID
GRANT INSERT, SELECT ON TiendaDB.detalle_venta TO 'cajero'@'localhost';  -- Registrar items vendidos
GRANT INSERT, SELECT ON TiendaDB.pago TO 'cajero'@'localhost';    -- Registrar metodo de pago

-- GERENTE: consultar ventas, pagos, clientes y empleados para generar reportes
GRANT SELECT ON TiendaDB.venta TO 'gerente'@'localhost';          -- Reportes de ventas del dia/mensuales
GRANT SELECT ON TiendaDB.detalle_venta TO 'gerente'@'localhost';  -- Analisis de productos vendidos
GRANT SELECT ON TiendaDB.pago TO 'gerente'@'localhost';           -- Reportes de metodos de pago
GRANT SELECT ON TiendaDB.cliente TO 'gerente'@'localhost';        -- Reportes de clientes con mayor volumen
GRANT SELECT ON TiendaDB.empleado TO 'gerente'@'localhost';       -- Reportes de ventas por empleado
GRANT SELECT ON TiendaDB.producto TO 'gerente'@'localhost';       -- Analisis de rotacion de inventario
GRANT SELECT ON TiendaDB.categoria TO 'gerente'@'localhost';      -- Reportes agrupados por categoria

-- ADMINISTRADOR TECNICO: tareas de mantenimiento y respaldo
GRANT ALL PRIVILEGES ON TiendaDB.* TO 'admin_tecnico'@'localhost'; -- Control total sobre la base de datos
GRANT CREATE USER ON *.* TO 'admin_tecnico'@'localhost';          -- Gestionar usuarios del sistema
GRANT RELOAD ON *.* TO 'admin_tecnico'@'localhost';               -- Realizar respaldos con mysqldump
GRANT PROCESS ON *.* TO 'admin_tecnico'@'localhost';              -- Monitorear procesos del servidor

FLUSH PRIVILEGES;

COMMIT;

SELECT 'Permisos asignados exitosamente por roles' as status;