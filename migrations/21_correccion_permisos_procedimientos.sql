START TRANSACTION;

-- CORRECCIÓN: Dar permisos de ejecución de procedimientos
-- Error: execute command denied to user 'cajero' for routine

-- Cajero necesita EXECUTE en su procedimiento
GRANT EXECUTE ON PROCEDURE TiendaDB.RegistrarVentaCompleta TO 'cajero'@'localhost';

-- Gerente necesita EXECUTE en su procedimiento
GRANT EXECUTE ON PROCEDURE TiendaDB.GenerarReporteMensual TO 'gerente'@'localhost';

-- Admin técnico necesita EXECUTE en su procedimiento  
GRANT EXECUTE ON PROCEDURE TiendaDB.ActualizacionMasivaPrecio TO 'admin_tecnico'@'localhost';

FLUSH PRIVILEGES;

COMMIT;

SELECT 'Permisos de procedimientos corregidos exitosamente' as status;