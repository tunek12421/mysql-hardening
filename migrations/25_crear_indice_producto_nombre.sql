-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 2
-- =================================================================
-- Crear un índice en la tabla productos sobre el campo nombre para mejorar 
-- el rendimiento de las búsquedas de productos.

START TRANSACTION;

-- Verificar si el índice ya existe antes de crearlo
SELECT 'Verificando índices existentes en tabla producto...' as verificacion;

-- Mostrar índices actuales en la tabla producto
SHOW INDEX FROM producto WHERE Key_name LIKE '%nombre%';

-- Crear el índice en el campo nombre de la tabla producto
CREATE INDEX IF NOT EXISTS idx_producto_nombre_busqueda ON producto(nombre);

-- Confirmar que el índice fue creado
SELECT 'Índice idx_producto_nombre_busqueda creado exitosamente' as resultado;

-- Mostrar todos los índices de la tabla producto después de la creación
SELECT 'Índices en tabla producto después de la creación:' as info;
SHOW INDEX FROM producto;

COMMIT;

-- Ejemplo de consulta que se beneficiará del índice
SELECT 'Ejemplo de consulta optimizada con el nuevo índice:' as ejemplo;
SELECT 'SELECT * FROM producto WHERE nombre LIKE "%Samsung%"' as consulta_optimizada;
SELECT 'SELECT * FROM producto WHERE nombre = "Smartphone Samsung"' as consulta_exacta;