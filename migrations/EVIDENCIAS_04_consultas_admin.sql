-- =================================================================
-- EVIDENCIAS PDF PARTE 2 - PUNTO 3: CONSULTAS DEL ADMIN TÉCNICO
-- =================================================================

SELECT '=== CONSULTAS DEL ADMINISTRADOR TÉCNICO ===' as EVIDENCIA;
SELECT USER() as 'Usuario Conectado', DATABASE() as 'Base de Datos';

-- CONSULTA 1: Ver estructura de tabla productos
SELECT '1. ESTRUCTURA DE TABLA PRODUCTOS' as CONSULTA;
DESCRIBE producto;

SELECT 'Comando CREATE TABLE de la tabla producto:' as INFO;
SHOW CREATE TABLE producto\G

-- CONSULTA 2: Información sobre respaldo lógico
SELECT '2. RESPALDO LÓGICO DE LA BASE DE DATOS' as CONSULTA;
SELECT 'Comando para respaldo: mysqldump -u admin_tecnico -padmintecnico123 TiendaDB > backup_tienda.sql' as COMANDO;
SELECT 'Respaldo debe ejecutarse desde shell del sistema, no desde MySQL' as NOTA;

-- CONSULTA 3: Registrar un pago (admin puede hacer operaciones de otros roles)
SELECT '3. REGISTRAR UN PAGO (Admin actuando como cajero)' as CONSULTA;
INSERT INTO venta (codigo_cliente, id_empleado, total) VALUES ('CLI-006', 3, 0.00);
SET @venta_admin = LAST_INSERT_ID();
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) 
VALUES (@venta_admin, 'ROPA-002', 1, 89.99);
INSERT INTO pago (metodo_pago, monto, id_venta) VALUES ('transferencia', 89.99, @venta_admin);
SELECT 'Pago registrado exitosamente por admin técnico' as RESULTADO;

-- Mostrar la venta recién creada
SELECT 'Venta creada por admin técnico:' as DETALLE;
SELECT v.id_venta, v.codigo_cliente, v.total, p.metodo_pago, p.monto
FROM venta v
JOIN pago p ON v.id_venta = p.id_venta
WHERE v.id_venta = @venta_admin;

-- CONSULTA 4: Crear vista de productos con bajo stock
SELECT '4. CREAR VISTA DE PRODUCTOS CON BAJO STOCK' as CONSULTA;
CREATE OR REPLACE VIEW vista_productos_evidencia AS
SELECT p.codigo_producto, p.nombre, p.stock, p.precio, c.nombre as categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.stock < 15
ORDER BY p.stock ASC;

SELECT 'Vista creada exitosamente' as RESULTADO;

-- Mostrar contenido de la vista
SELECT 'Contenido de vista_productos_evidencia:' as CONTENIDO;
SELECT * FROM vista_productos_evidencia LIMIT 5;

-- CONSULTA 5: Usuario de solo lectura ya fue creado como root
SELECT '5. VERIFICAR USUARIO DE SOLO LECTURA' as CONSULTA;
SELECT 'Usuario consulta_readonly creado previamente con permisos root' as INFO;
SHOW GRANTS FOR 'consulta_readonly'@'localhost';

SELECT 'EVIDENCIA COMPLETADA - Todas las consultas del admin ejecutadas' as RESULTADO;