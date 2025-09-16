START TRANSACTION;

-- PRUEBAS DE PERMISOS DENEGADOS - PDF PARTE 2
-- Identificar consultas que cada usuario NO puede realizar

-- CAJERO - Operaciones que debe fallar:
-- 1. No puede crear usuarios (falta CREATE USER)
-- CREATE USER 'test'@'localhost'; -- ERROR 1227: Access denied

-- 2. No puede crear vistas (falta CREATE VIEW)  
-- CREATE VIEW test_view AS SELECT * FROM cliente; -- ERROR 1142: CREATE VIEW denied

-- 3. No puede eliminar datos (falta DELETE)
-- DELETE FROM cliente WHERE codigo_cliente = 'CLI-999'; -- ERROR 1142: DELETE denied

-- GERENTE - Operaciones que debe fallar:
-- 1. ✅ YA CORREGIDO: No podía crear índices (ahora sí puede tras corrección)
-- 2. No puede insertar datos (falta INSERT)
-- INSERT INTO cliente VALUES ('CLI-999', 'Test', NULL, NULL, NULL, CURDATE()); -- ERROR 1142: INSERT denied

-- 3. No puede crear usuarios (falta CREATE USER)  
-- CREATE USER 'test2'@'localhost'; -- ERROR 1227: Access denied

-- ADMIN TECNICO - Operaciones que debe fallar:
-- (Tiene todos los permisos, no debería fallar ninguna operación del sistema)

-- USUARIO READONLY (recién creado) - Operaciones que debe fallar:
-- 1. No puede insertar (solo SELECT)
-- INSERT INTO cliente VALUES (...); -- ERROR 1142: INSERT denied

-- 2. No puede actualizar (solo SELECT)
-- UPDATE producto SET precio = 100; -- ERROR 1142: UPDATE denied

-- 3. No puede eliminar (solo SELECT)
-- DELETE FROM venta; -- ERROR 1142: DELETE denied

COMMIT;

SELECT 'Análisis de permisos denegados completado - PDF Parte 2' as status;
SELECT 'Para probar errores, ejecutar las consultas comentadas con cada usuario correspondiente' as nota;