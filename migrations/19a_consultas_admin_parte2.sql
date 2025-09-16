START TRANSACTION;

-- ADMINISTRADOR TECNICO - CONSULTAS PDF PARTE 2 (SIN PERMISOS ROOT)
-- Usuario: admin_tecnico, Password: admintecnico123

-- 1. Ver estructura de una tabla (ejemplo productos)
DESCRIBE producto;
SHOW CREATE TABLE producto;

-- 2. Crear un respaldo lógico de la base de datos (ejemplo en MySQL)
-- NOTA: Este comando se ejecuta desde shell, no desde MySQL:
-- mysqldump -u admin_tecnico -padmintecnico123 TiendaDB > backup_tienda_$(date +%Y%m%d).sql

-- 3. Registrar un pago (admin puede hacer operaciones de cualquier rol)
INSERT INTO venta (codigo_cliente, id_empleado, total) VALUES ('CLI-003', 1, 0.00);
SET @venta_admin = LAST_INSERT_ID();
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) 
VALUES (@venta_admin, 'ROPA-001', 1, 29.99);
INSERT INTO pago (metodo_pago, monto, id_venta) VALUES ('transferencia', 29.99, @venta_admin);

-- 4. Crear una vista de productos con bajo stock
CREATE OR REPLACE VIEW vista_productos_criticos AS
SELECT p.codigo_producto, p.nombre, p.stock, p.precio, c.nombre as categoria
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.stock < 5
ORDER BY p.stock ASC;

COMMIT;

SELECT 'Consultas de ADMINISTRADOR TECNICO ejecutadas exitosamente - PDF Parte 2' as status;