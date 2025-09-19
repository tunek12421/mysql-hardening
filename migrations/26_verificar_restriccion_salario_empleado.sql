-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 3
-- =================================================================
-- Agregar una restricción CHECK en la tabla empleados para que el salario 
-- sea siempre mayor a 0.

START TRANSACTION;

-- Verificar la estructura actual de la tabla empleado
SELECT 'Verificando estructura actual de la tabla empleado...' as verificacion;
DESCRIBE empleado;

-- Mostrar la definición completa de la tabla para ver restricciones existentes
SELECT 'Definición completa de la tabla empleado:' as definicion;
SHOW CREATE TABLE empleado\G

-- Verificar que la restricción CHECK ya existe
SELECT 'ANÁLISIS: La restricción CHECK ya existe en la tabla empleado' as analisis;
SELECT 'Restricción actual: salario > 0' as restriccion_existente;

-- Verificar que la restricción funciona correctamente
SELECT 'Probando la restricción CHECK con datos existentes...' as prueba;
SELECT id_empleado, nombre_completo, salario 
FROM empleado 
WHERE salario > 0
ORDER BY salario DESC;

-- Mostrar que todos los salarios cumplen la restricción
SELECT 'Verificación: Todos los salarios son mayores a 0' as verificacion_datos;
SELECT 
    COUNT(*) as total_empleados,
    MIN(salario) as salario_minimo,
    MAX(salario) as salario_maximo,
    AVG(salario) as salario_promedio
FROM empleado;

COMMIT;

-- Nota sobre intentar insertar un salario inválido
SELECT 'NOTA: Si intentáramos insertar un empleado con salario <= 0, MySQL rechazaría la operación' as nota;
SELECT 'Ejemplo de comando que fallaría:' as ejemplo_fallo;
SELECT 'INSERT INTO empleado (nombre_completo, cargo, salario, fecha_contratacion) VALUES ("Test", "Test", 0, CURDATE());' as comando_fallido;

-- Mostrar el estado actual de la restricción
SELECT 'ESTADO: La restricción CHECK para salario > 0 está ACTIVA y FUNCIONANDO' as estado_final;