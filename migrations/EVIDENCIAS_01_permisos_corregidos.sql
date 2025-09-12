-- =================================================================
-- EVIDENCIAS PDF PARTE 2 - PUNTO 1 y 2: REVISIÓN Y CORRECCIÓN DE PERMISOS
-- =================================================================

SELECT '=== VERIFICACIÓN DE PERMISOS CORREGIDOS ===' as EVIDENCIA;

-- 1. PERMISOS DEL CAJERO (debe incluir UPDATE stock tras corrección)
SELECT 'CAJERO - Permisos asignados:' as USUARIO;
SHOW GRANTS FOR 'cajero'@'localhost';

-- 2. PERMISOS DEL GERENTE (debe incluir INDEX tras corrección)
SELECT 'GERENTE - Permisos asignados:' as USUARIO;
SHOW GRANTS FOR 'gerente'@'localhost';

-- 3. PERMISOS DEL ADMIN TÉCNICO
SELECT 'ADMIN_TECNICO - Permisos asignados:' as USUARIO;
SHOW GRANTS FOR 'admin_tecnico'@'localhost';

-- 4. PERMISOS DEL USUARIO READONLY (creado en punto 5 admin)
SELECT 'CONSULTA_READONLY - Permisos asignados:' as USUARIO;
SHOW GRANTS FOR 'consulta_readonly'@'localhost';

-- 5. VERIFICAR USUARIOS EXISTENTES
SELECT 'Usuarios del sistema TiendaDB:' as VERIFICACION;
SELECT user, host, password_expired 
FROM mysql.user 
WHERE user IN ('cajero', 'gerente', 'admin_tecnico', 'consulta_readonly')
ORDER BY user;

SELECT 'EVIDENCIA COMPLETADA - Permisos verificados exitosamente' as RESULTADO;