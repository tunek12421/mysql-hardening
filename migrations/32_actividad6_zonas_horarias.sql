-- =====================================================
-- ACTIVIDAD 6: CONFIGURACIÓN DE ZONAS HORARIAS Y VALIDACIÓN DE CONSISTENCIA
-- Propósito: Demostrar manejo correcto de zonas horarias en MySQL
-- Fecha: 19/09/2025
-- Estudiante: Walter Lujan
-- =====================================================

-- PARTE 1: CONFIGURACIÓN Y PREPARACIÓN
-- =====================================================

-- 1. Verificar configuración actual de zona horaria
SELECT 'CONFIGURACIÓN INICIAL DE ZONA HORARIA' as seccion;
SELECT 
    @@global.time_zone as 'Zona Global',
    @@session.time_zone as 'Zona Sesión',
    NOW() as 'Fecha/Hora Actual',
    UTC_TIMESTAMP() as 'Fecha/Hora UTC';

-- 2. Configurar zona horaria de Bolivia (UTC-4)
SET time_zone = '-04:00';

-- 3. Verificar configuración actualizada
SELECT 'CONFIGURACIÓN ACTUALIZADA' as seccion;
SELECT 
    @@global.time_zone as 'Zona Global',
    @@session.time_zone as 'Zona Sesión',
    NOW() as 'Fecha/Hora Bolivia',
    UTC_TIMESTAMP() as 'Fecha/Hora UTC';

-- 4. Crear tabla de prueba para eventos
DROP TABLE IF EXISTS eventos;
CREATE TABLE eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    fecha_evento DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. Insertar registros con diferentes configuraciones de zona horaria
-- Evento con hora local de Bolivia
INSERT INTO eventos (descripcion) VALUES ('Evento Bolivia');

-- Evento convertido a UTC
INSERT INTO eventos (descripcion, fecha_evento) 
VALUES ('Evento UTC', CONVERT_TZ(NOW(), @@session.time_zone, '+00:00'));

-- Evento convertido a Nueva York
INSERT INTO eventos (descripcion, fecha_evento) 
VALUES ('Evento Nueva York', CONVERT_TZ(NOW(), @@session.time_zone, '-05:00'));

-- Evento sin conversión para comparación
INSERT INTO eventos (descripcion, fecha_evento) 
VALUES ('Evento sin conversión', NOW());

-- PARTE 2: CONSULTAS DE VALIDACIÓN Y ANÁLISIS
-- =====================================================

-- 6. Mostrar datos almacenados
SELECT 'VERIFICACIÓN DE DATOS INSERTADOS' as seccion;
SELECT 
    id_evento,
    descripcion,
    fecha_evento,
    'Almacenado en BD' as tipo_fecha
FROM eventos 
ORDER BY id_evento;

-- 7. Mostrar conversiones a diferentes zonas horarias
SELECT 'CONVERSIONES DE ZONA HORARIA' as seccion;
SELECT 
    id_evento,
    descripcion,
    fecha_evento as 'Fecha Original',
    CONVERT_TZ(fecha_evento, @@session.time_zone, '+00:00') as 'UTC (+00:00)',
    CONVERT_TZ(fecha_evento, @@session.time_zone, '-04:00') as 'Bolivia (-04:00)',
    CONVERT_TZ(fecha_evento, @@session.time_zone, '-05:00') as 'Nueva York (-05:00)'
FROM eventos 
ORDER BY id_evento;

-- 8. Detección de inconsistencias
SELECT 'DETECCIÓN DE INCONSISTENCIAS' as seccion;
SELECT 
    e.id_evento,
    e.descripcion,
    e.fecha_evento as 'Fecha Almacenada',
    CONVERT_TZ(e.fecha_evento, '-04:00', '+00:00') as 'Convertida a UTC',
    CASE 
        WHEN e.descripcion = 'Evento Bolivia' THEN 'OK - Bolivia'
        WHEN e.descripcion = 'Evento UTC' AND CONVERT_TZ(e.fecha_evento, '-04:00', '+00:00') != e.fecha_evento THEN 'INCONSISTENCIA - Debería estar en UTC'
        WHEN e.descripcion = 'Evento Nueva York' THEN 'OK - Nueva York'
        ELSE 'SIN CONVERSIÓN'
    END as 'Estado Consistencia'
FROM eventos e
ORDER BY e.id_evento;

-- 9. Demostración de mejores prácticas
SELECT 'MEJORES PRÁCTICAS PARA ZONAS HORARIAS' as seccion;
SELECT 'Ejemplo: Insertar evento a las 15:30 hora Bolivia (debería almacenarse como 19:30 UTC)' as ejemplo;

-- Simulación de inserción correcta
SELECT 
    'Hora Local Bolivia: 15:30' as 'Input Usuario',
    CONVERT_TZ('2025-09-19 15:30:00', '-04:00', '+00:00') as 'Almacenar en UTC',
    CONVERT_TZ(CONVERT_TZ('2025-09-19 15:30:00', '-04:00', '+00:00'), '+00:00', '-04:00') as 'Mostrar en Bolivia',
    CONVERT_TZ(CONVERT_TZ('2025-09-19 15:30:00', '-04:00', '+00:00'), '+00:00', '-05:00') as 'Mostrar en NY';

-- PARTE 3: VALIDACIÓN FINAL Y LIMPIEZA
-- =====================================================

-- 10. Mostrar configuración final del sistema
SELECT 'CONFIGURACIÓN FINAL DEL SISTEMA' as seccion;
SELECT 
    @@global.time_zone as 'Zona Global',
    @@session.time_zone as 'Zona Sesión',
    NOW() as 'Fecha/Hora Actual Sesión',
    UTC_TIMESTAMP() as 'Fecha/Hora UTC',
    TIMEDIFF(NOW(), UTC_TIMESTAMP()) as 'Diferencia con UTC';

-- 11. Resumen de eventos creados
SELECT 'RESUMEN FINAL DE EVENTOS' as seccion;
SELECT 
    COUNT(*) as 'Total Eventos',
    MIN(fecha_evento) as 'Primer Evento',
    MAX(fecha_evento) as 'Último Evento'
FROM eventos;

-- =====================================================
-- CONCLUSIONES Y RECOMENDACIONES:
-- =====================================================
/*
1. PROBLEMA IDENTIFICADO:
   - Los datos se almacenan en la zona horaria de la sesión actual
   - No hay conversión automática a UTC para almacenamiento estándar
   - Esto puede causar inconsistencias al cambiar zonas horarias

2. MEJORES PRÁCTICAS RECOMENDADAS:
   - Almacenar siempre en UTC en la base de datos
   - Convertir a zona horaria local solo para mostrar al usuario
   - Usar CONVERT_TZ() para todas las conversiones
   - Mantener la zona horaria del servidor en UTC cuando sea posible

3. IMPLEMENTACIÓN SEGURA:
   - Validar zona horaria antes de insertar datos
   - Documentar qué zona horaria se usa en cada campo
   - Implementar funciones de conversión consistentes
   - Probar con diferentes zonas horarias

4. IMPACTO EN APLICACIONES:
   - Las aplicaciones web deben manejar zonas horarias del usuario
   - Los reportes deben especificar la zona horaria utilizada
   - Las auditorías requieren timestamps consistentes
   - La sincronización entre sistemas necesita UTC
*/

-- =====================================================
-- FIN DE LA ACTIVIDAD 6
-- =====================================================