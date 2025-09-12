-- =================================================================
-- ACTIVIDAD 5 - PERSONA B: LISTAR PERMISOS POR USUARIO
-- =================================================================
-- REQUISITO: Listar los permisos por usuario
-- CAPTURA: Permisos detallados de cada usuario

SELECT '=== ACTIVIDAD 5 - PERMISOS POR USUARIO ===' as TITULO;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- =================================================================
-- PERMISOS DEL CAJERO
-- =================================================================

SELECT '1. PERMISOS DEL USUARIO CAJERO:' as USUARIO_1;
SHOW GRANTS FOR 'cajero'@'localhost';

-- Explicación de permisos del cajero
SELECT 'FUNCIONES PERMITIDAS PARA CAJERO:' as FUNCIONES_CAJERO;
SELECT 
    'SELECT en producto, categoria, cliente' as 'Consultas Permitidas',
    'INSERT/SELECT en venta, detalle_venta, pago' as 'Operaciones de Venta',
    'UPDATE(stock) en producto' as 'Actualización de Inventario',
    'EXECUTE en RegistrarVentaCompleta' as 'Procedimientos Permitidos';

-- =================================================================
-- PERMISOS DEL GERENTE
-- =================================================================

SELECT '2. PERMISOS DEL USUARIO GERENTE:' as USUARIO_2;
SHOW GRANTS FOR 'gerente'@'localhost';

-- Explicación de permisos del gerente
SELECT 'FUNCIONES PERMITIDAS PARA GERENTE:' as FUNCIONES_GERENTE;
SELECT 
    'SELECT en todas las tablas principales' as 'Consultas Permitidas',
    'INDEX en TiendaDB.*' as 'Optimización de Consultas',
    'EXECUTE en GenerarReporteMensual' as 'Procedimientos Permitidos',
    'Solo lectura - NO puede modificar datos' as 'Restricciones';

-- =================================================================
-- PERMISOS DEL ADMINISTRADOR TÉCNICO
-- =================================================================

SELECT '3. PERMISOS DEL USUARIO ADMIN_TECNICO:' as USUARIO_3;
SHOW GRANTS FOR 'admin_tecnico'@'localhost';

-- Explicación de permisos del admin técnico
SELECT 'FUNCIONES PERMITIDAS PARA ADMIN_TECNICO:' as FUNCIONES_ADMIN;
SELECT 
    'ALL PRIVILEGES en TiendaDB.*' as 'Control Total BD',
    'CREATE USER en *.*' as 'Gestión de Usuarios',
    'RELOAD en *.*' as 'Respaldos y Mantenimiento',
    'PROCESS en *.*' as 'Monitoreo del Sistema',
    'EXECUTE en ActualizacionMasivaPrecio' as 'Procedimientos Admin';

-- =================================================================
-- PERMISOS DEL USUARIO READONLY
-- =================================================================

SELECT '4. PERMISOS DEL USUARIO CONSULTA_READONLY:' as USUARIO_4;
SHOW GRANTS FOR 'consulta_readonly'@'localhost';

-- Explicación de permisos del usuario readonly
SELECT 'FUNCIONES PERMITIDAS PARA CONSULTA_READONLY:' as FUNCIONES_READONLY;
SELECT 
    'SELECT en TiendaDB.*' as 'Solo Lectura',
    'NO puede INSERT, UPDATE, DELETE' as 'Restricciones de Modificación',
    'Ideal para auditorías y consultas' as 'Propósito',
    'Máxima seguridad de datos' as 'Beneficio';

-- =================================================================
-- RESUMEN COMPARATIVO DE PERMISOS
-- =================================================================

SELECT 'RESUMEN COMPARATIVO DE PERMISOS POR USUARIO:' as RESUMEN;
SELECT 
    'cajero' as Usuario,
    'Operaciones de venta' as 'Función Principal',
    'SELECT, INSERT específicos + UPDATE(stock)' as 'Nivel de Acceso'
UNION ALL
SELECT 
    'gerente' as Usuario,
    'Reportes y análisis' as 'Función Principal',
    'SELECT general + INDEX' as 'Nivel de Acceso'
UNION ALL
SELECT 
    'admin_tecnico' as Usuario,
    'Administración completa' as 'Función Principal',
    'ALL PRIVILEGES + permisos globales' as 'Nivel de Acceso'
UNION ALL
SELECT 
    'consulta_readonly' as Usuario,
    'Auditoría y consultas' as 'Función Principal',
    'SELECT únicamente' as 'Nivel de Acceso';

-- =================================================================
-- VERIFICACIÓN DEL PRINCIPIO DE MENOR PRIVILEGIO
-- =================================================================

SELECT 'VERIFICACIÓN DEL PRINCIPIO DE MENOR PRIVILEGIO:' as PRINCIPIO;
SELECT 
    'Cada usuario tiene solo los permisos mínimos necesarios' as 'Implementación',
    'Segregación clara de funciones por rol' as 'Beneficio 1',
    'Reducción de riesgos de seguridad' as 'Beneficio 2',
    'Control granular de acceso a datos' as 'Beneficio 3';

SELECT 'EVIDENCIA COMPLETADA - Permisos por usuario documentados exitosamente' as RESULTADO;