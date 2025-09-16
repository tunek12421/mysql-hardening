-- Ejercicio 3: Agregar restricción CHECK en la tabla empleados
-- Para que el salario sea siempre mayor a 0
USE TiendaDB;

START TRANSACTION;

SELECT '=== AGREGANDO RESTRICCIÓN CHECK A EMPLEADOS ===' as accion;

-- Mostrar estructura actual de la tabla empleados
SELECT 'Estructura actual de la tabla empleados:' as info;
DESCRIBE empleado;

-- Mostrar empleados actuales
SELECT '=== EMPLEADOS ACTUALES ===' as seccion;
SELECT id_empleado, nombre_completo, cargo, salario
FROM empleado
ORDER BY id_empleado;

-- Agregar una nueva restricción CHECK con nombre específico
-- Nota: MariaDB soporta restricciones CHECK desde la versión 10.2
SELECT 'Agregando restricción CHECK para salario positivo...' as info;

ALTER TABLE empleado
ADD CONSTRAINT chk_empleado_salario_positivo
CHECK (salario > 0);

SELECT 'Restricción CHECK agregada exitosamente' as resultado;

-- Mostrar la definición actualizada de la tabla
SELECT '=== DEFINICIÓN DE TABLA ACTUALIZADA ===' as seccion;
SHOW CREATE TABLE empleado;

-- Probar la restricción intentando insertar un empleado con salario inválido
SELECT '=== PROBANDO LA RESTRICCIÓN ===' as seccion;
SELECT 'Intentando insertar empleado con salario negativo (debe fallar)...' as test;

SAVEPOINT sp_test_negativo;

-- Intentar insertar empleado con salario negativo
-- Esta operación debe generar un error
INSERT INTO empleado (nombre_completo, cargo, salario, fecha_contratacion)
VALUES ('Test Empleado', 'Test Cargo', -100.00, CURDATE());

-- Si llegamos aquí, algo salió mal
SELECT 'ERROR: La restricción no funcionó correctamente' as error_test;

ROLLBACK TO SAVEPOINT sp_test_negativo;

-- Probar con un salario válido
SELECT 'Insertando empleado con salario válido...' as test;
INSERT INTO empleado (nombre_completo, cargo, salario, fecha_contratacion)
VALUES ('María Test Válido', 'Analista', 2500.00, CURDATE());

SELECT 'Empleado con salario válido insertado correctamente' as resultado;

-- Mostrar el empleado recién insertado
SELECT '=== EMPLEADO INSERTADO ===' as seccion;
SELECT id_empleado, nombre_completo, cargo, salario, fecha_contratacion
FROM empleado
WHERE nombre_completo = 'María Test Válido';

-- Verificar que todos los empleados tienen salario > 0
SELECT '=== VERIFICACIÓN FINAL ===' as seccion;
SELECT
    COUNT(*) as total_empleados,
    MIN(salario) as salario_minimo,
    MAX(salario) as salario_maximo
FROM empleado;

COMMIT;

SELECT 'Ejercicio 3 completado - Restricción CHECK chk_empleado_salario_positivo agregada' as status;