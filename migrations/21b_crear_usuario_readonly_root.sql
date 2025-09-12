START TRANSACTION;

-- CREAR USUARIO DE SOLO LECTURA (REQUIERE ROOT)
-- Consulta 5 del admin técnico que necesita permisos especiales

-- 5. Crear un usuario de solo lectura
CREATE USER IF NOT EXISTS 'consulta_readonly'@'localhost' IDENTIFIED BY 'readonly123';
GRANT SELECT ON TiendaDB.* TO 'consulta_readonly'@'localhost';
FLUSH PRIVILEGES;

COMMIT;

SELECT 'Usuario de solo lectura creado exitosamente' as status;