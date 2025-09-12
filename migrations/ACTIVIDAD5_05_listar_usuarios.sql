-- =================================================================
-- ACTIVIDAD 5 - PERSONA B: LISTAR USUARIOS CREADOS
-- =================================================================
-- REQUISITO: Listar los usuarios creados en el sistema
-- CAPTURA: Lista completa de usuarios del proyecto

SELECT '=== ACTIVIDAD 5 - LISTA DE USUARIOS CREADOS ===' as TITULO;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- =================================================================
-- CONSULTA PRINCIPAL: USUARIOS DEL PROYECTO
-- =================================================================

SELECT 'USUARIOS CREADOS EN EL PROYECTO MYSQL-HARDENING:' as LISTADO;

-- Mostrar usuarios específicos del proyecto (excluir usuarios del sistema)
SELECT 
    User as 'Usuario',
    Host as 'Host',
    CASE 
        WHEN password_expired = 'Y' THEN 'SÍ'
        ELSE 'NO'
    END as 'Contraseña Expirada',
    CASE 
        WHEN account_locked = 'Y' THEN 'SÍ'
        ELSE 'NO'
    END as 'Cuenta Bloqueada'
FROM mysql.user 
WHERE User IN ('cajero', 'gerente', 'admin_tecnico', 'consulta_readonly')
ORDER BY User;

-- =================================================================
-- INFORMACIÓN ADICIONAL DE USUARIOS
-- =================================================================

SELECT 'INFORMACIÓN DETALLADA DE USUARIOS:' as DETALLE;

-- Contar usuarios creados para el proyecto
SELECT 'TOTAL DE USUARIOS DEL PROYECTO:' as CONTADOR;
SELECT COUNT(*) as 'Número de Usuarios Creados'
FROM mysql.user 
WHERE User IN ('cajero', 'gerente', 'admin_tecnico', 'consulta_readonly');

-- Verificar usuarios activos
SELECT 'USUARIOS ACTIVOS (no bloqueados):' as ACTIVOS;
SELECT 
    User as 'Usuario Activo',
    Host as 'Host'
FROM mysql.user 
WHERE User IN ('cajero', 'gerente', 'admin_tecnico', 'consulta_readonly')
  AND account_locked = 'N'
ORDER BY User;

-- =================================================================
-- DESCRIPCIÓN DE ROLES
-- =================================================================

SELECT 'DESCRIPCIÓN DE ROLES IMPLEMENTADOS:' as ROLES;
SELECT 
    'cajero' as Usuario,
    'Registrar ventas, consultar productos y clientes' as Función,
    'SELECT, INSERT en tablas específicas' as 'Permisos Principales'
UNION ALL
SELECT 
    'gerente' as Usuario,
    'Generar reportes y análisis de ventas' as Función,
    'SELECT en todas las tablas, INDEX' as 'Permisos Principales'
UNION ALL
SELECT 
    'admin_tecnico' as Usuario,
    'Administración completa de base de datos' as Función,
    'ALL PRIVILEGES, CREATE USER, RELOAD' as 'Permisos Principales'
UNION ALL
SELECT 
    'consulta_readonly' as Usuario,
    'Solo lectura para auditorías' as Función,
    'SELECT únicamente' as 'Permisos Principales';

SELECT 'EVIDENCIA COMPLETADA - Lista de usuarios generada exitosamente' as RESULTADO;