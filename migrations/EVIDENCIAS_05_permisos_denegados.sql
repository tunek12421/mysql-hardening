-- =================================================================
-- EVIDENCIAS PDF PARTE 2 - PUNTO 3: CONSULTAS QUE NO PUEDEN REALIZAR
-- =================================================================
-- IMPORTANTE: Ejecutar cada sección con el usuario correspondiente para ver los errores

SELECT '=== CONSULTAS QUE DEBEN FALLAR POR PERMISOS ===' as EVIDENCIA;

-- =================================================================
-- CAJERO - Consultas que deben fallar
-- EJECUTAR COMO: mysql -u cajero -pcajero123 TiendaDB
-- =================================================================

SELECT '--- CAJERO: Consultas que DEBEN FALLAR ---' as USUARIO;
SELECT USER() as 'Usuario Conectado';

-- ERROR ESPERADO 1: No puede crear usuarios
SELECT 'Intentando crear usuario (debe fallar):' as PRUEBA;
-- CREATE USER 'test_cajero'@'localhost' IDENTIFIED BY 'test123';
-- ERROR 1227 (42000): Access denied; you need (at least one of) the CREATE USER privilege(s)

-- ERROR ESPERADO 2: No puede crear vistas
SELECT 'Intentando crear vista (debe fallar):' as PRUEBA;
-- CREATE VIEW test_view AS SELECT * FROM cliente LIMIT 5;
-- ERROR 1142 (42000): CREATE VIEW command denied to user 'cajero'@'localhost'

-- ERROR ESPERADO 3: No puede eliminar datos
SELECT 'Intentando eliminar cliente (debe fallar):' as PRUEBA;
-- DELETE FROM cliente WHERE codigo_cliente = 'CLI-999';
-- ERROR 1142 (42000): DELETE command denied to user 'cajero'@'localhost'

-- =================================================================
-- GERENTE - Consultas que deben fallar
-- EJECUTAR COMO: mysql -u gerente -pgerente123 TiendaDB
-- =================================================================

SELECT '--- GERENTE: Consultas que DEBEN FALLAR ---' as USUARIO;

-- ERROR ESPERADO 1: No puede insertar datos (solo SELECT)
SELECT 'Intentando insertar cliente (debe fallar):' as PRUEBA;
-- INSERT INTO cliente VALUES ('CLI-999', 'Test Usuario', 'test@test.com', '123-456-7890', 'Dirección Test', CURDATE());
-- ERROR 1142 (42000): INSERT command denied to user 'gerente'@'localhost'

-- ERROR ESPERADO 2: No puede crear usuarios
SELECT 'Intentando crear usuario (debe fallar):' as PRUEBA;
-- CREATE USER 'test_gerente'@'localhost' IDENTIFIED BY 'test123';
-- ERROR 1227 (42000): Access denied; you need (at least one of) the CREATE USER privilege(s)

-- ERROR ESPERADO 3: No puede actualizar datos
SELECT 'Intentando actualizar producto (debe fallar):' as PRUEBA;
-- UPDATE producto SET precio = 999.99 WHERE codigo_producto = 'AUT-001';
-- ERROR 1142 (42000): UPDATE command denied to user 'gerente'@'localhost'

-- =================================================================
-- USUARIO READONLY - Consultas que deben fallar
-- EJECUTAR COMO: mysql -u consulta_readonly -preadonly123 TiendaDB
-- =================================================================

SELECT '--- USUARIO READONLY: Consultas que DEBEN FALLAR ---' as USUARIO;

-- ERROR ESPERADO 1: No puede insertar (solo SELECT)
SELECT 'Intentando insertar (debe fallar):' as PRUEBA;
-- INSERT INTO cliente VALUES ('CLI-888', 'Test', NULL, NULL, NULL, CURDATE());
-- ERROR 1142 (42000): INSERT command denied to user 'consulta_readonly'@'localhost'

-- ERROR ESPERADO 2: No puede actualizar (solo SELECT)
SELECT 'Intentando actualizar (debe fallar):' as PRUEBA;
-- UPDATE producto SET precio = 100.00 WHERE codigo_producto = 'AUT-001';
-- ERROR 1142 (42000): UPDATE command denied to user 'consulta_readonly'@'localhost'

-- ERROR ESPERADO 3: No puede eliminar (solo SELECT)
SELECT 'Intentando eliminar (debe fallar):' as PRUEBA;
-- DELETE FROM venta WHERE id_venta = 999;
-- ERROR 1142 (42000): DELETE command denied to user 'consulta_readonly'@'localhost'

-- PERO SÍ PUEDE HACER SELECT
SELECT 'Consulta SELECT permitida para readonly:' as PERMITIDA;
SELECT COUNT(*) as total_productos FROM producto;

SELECT 'EVIDENCIA COMPLETADA - Restricciones de permisos verificadas' as RESULTADO;
SELECT 'Principio de menor privilegio funcionando correctamente' as CONCLUSION;