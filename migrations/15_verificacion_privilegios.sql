START TRANSACTION;

-- VERIFICACION: Mostrar permisos asignados a cada usuario
-- Confirma que el principio de menor privilegio se cumple correctamente

-- Permisos del cajero (debe tener SELECT en consultas y INSERT en transacciones)
SHOW GRANTS FOR 'cajero'@'localhost';

-- Permisos del gerente (debe tener solo SELECT para reportes)
SHOW GRANTS FOR 'gerente'@'localhost';

-- Permisos del admin tecnico (debe tener privilegios administrativos)
SHOW GRANTS FOR 'admin_tecnico'@'localhost';

-- Verificar que los usuarios existen en el sistema
SELECT user, host FROM mysql.user WHERE user IN ('cajero', 'gerente', 'admin_tecnico');

COMMIT;

SELECT 'Verificacion de privilegios completada' as status;