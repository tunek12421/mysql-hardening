-- Migración 02: Datos iniciales simplificados
USE TiendaDB;

START TRANSACTION;

INSERT INTO categoria (nombre, descripcion) VALUES 
('Electrónicos', 'Dispositivos electrónicos'),
('Ropa', 'Prendas de vestir'),
('Hogar', 'Artículos para el hogar'),
('Deportes', 'Artículos deportivos');

INSERT INTO proveedor (nombre, telefono, direccion, correo_electronico) VALUES 
('TecnoDistribuidor S.A.', '555-2001', 'Parque Industrial Los Álamos', 'ventas@tecnodistribuidor.com'),
('Moda y Estilo Ltda.', '555-2002', 'Centro Comercial Plaza Norte', 'pedidos@modayestilo.com'),
('Hogar Confort S.R.L.', '555-2003', 'Zona Franca Industrial', 'compras@hogarconfort.com');

INSERT INTO empleado (nombre_completo, cargo, salario, fecha_contratacion) VALUES
('Roberto Mendoza García', 'Gerente General', 5500.00, '2020-03-15'),
('Laura Patricia Cruz', 'Vendedor Senior', 3200.00, '2021-08-05'),
('Isabel María Ramírez', 'Cajero Principal', 2600.00, '2022-05-15');

INSERT INTO cliente (codigo_cliente, nombre, correo_electronico, telefono, direccion) VALUES
('CLI-001', 'Juan Carlos Pérez', 'juan.perez@email.com', '312-555-0001', 'Carrera 15 #45-67'),
('CLI-002', 'María García López', 'maria.garcia@email.com', '320-555-0002', 'Calle 72 #23-45'),
('CLI-003', 'Carlos Rodríguez', 'carlos.rodriguez@email.com', '318-555-0003', 'Avenida El Dorado #98-76');

INSERT INTO producto (codigo_producto, nombre, precio, stock, id_categoria) VALUES 
('ELEC-001', 'Smartphone Samsung', 699.99, 25, 1),
('ELEC-002', 'Laptop Dell', 1199.99, 15, 1),
('ROPA-001', 'Camiseta Nike', 29.99, 50, 2),
('ROPA-002', 'Jeans Levis', 89.99, 30, 2),
('HOGAR-001', 'Mesa de Centro', 299.99, 10, 3),
('HOGAR-002', 'Lámpara LED', 49.99, 25, 3),
('DEPORT-001', 'Balón Fútbol', 39.99, 40, 4),
('DEPORT-002', 'Raqueta Tenis', 159.99, 12, 4);

INSERT INTO venta (fecha_hora, total, codigo_cliente, id_empleado) VALUES 
('2024-08-15 14:30:00', 0.00, 'CLI-001', 1),
('2024-08-16 10:15:00', 0.00, 'CLI-002', 2),
('2024-08-17 16:45:00', 0.00, 'CLI-003', 3);

INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) VALUES 
(1, 'ELEC-001', 1, 699.99),
(2, 'ROPA-001', 2, 29.99),
(2, 'ROPA-002', 1, 89.99),
(3, 'HOGAR-001', 1, 299.99),
(3, 'HOGAR-002', 1, 49.99);

INSERT INTO pago (metodo_pago, monto, fecha_pago, id_venta) VALUES 
('tarjeta', 699.99, '2024-08-15', 1),
('efectivo', 119.98, '2024-08-16', 2),
('transferencia', 349.98, '2024-08-17', 3);

INSERT INTO pedido (fecha_pedido, estado, id_proveedor) VALUES 
('2024-08-10', 'completado', 1),
('2024-08-12', 'pendiente', 2);

INSERT INTO detalle_pedido (id_pedido, codigo_producto, cantidad, precio_unitario) VALUES 
(1, 'ELEC-001', 10, 650.00),
(1, 'ELEC-002', 5, 1100.00),
(2, 'ROPA-001', 30, 25.00);

COMMIT;

SELECT 'Datos iniciales insertados exitosamente' as status;