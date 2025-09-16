-- Ejercicio 2: Crear índice en la tabla productos sobre el campo nombre
-- Para mejorar el rendimiento de las búsquedas de productos
USE TiendaDB;

START TRANSACTION;

SELECT '=== CREANDO ÍNDICE EN PRODUCTOS ===' as accion;

-- Mostrar índices existentes antes de agregar el nuevo
SELECT 'Índices existentes en la tabla producto:' as info;
SHOW INDEX FROM producto;

-- Crear índice en el campo nombre de la tabla producto
CREATE INDEX idx_producto_nombre_busqueda ON producto(nombre);

SELECT 'Índice idx_producto_nombre_busqueda creado exitosamente' as resultado;

-- Mostrar índices después de agregar el nuevo
SELECT '=== ÍNDICES DESPUÉS DE LA CREACIÓN ===' as seccion;
SHOW INDEX FROM producto;

-- Demostrar el uso del índice con una consulta de ejemplo
SELECT '=== EJEMPLO DE BÚSQUEDA USANDO EL ÍNDICE ===' as seccion;
SELECT codigo_producto, nombre, precio, stock
FROM producto
WHERE nombre LIKE '%Samsung%';

SELECT '=== PLAN DE EJECUCIÓN (EXPLAIN) ===' as seccion;
EXPLAIN SELECT codigo_producto, nombre, precio, stock
FROM producto
WHERE nombre LIKE '%Samsung%';

COMMIT;

SELECT 'Ejercicio 2 completado - Índice en campo nombre creado' as status;