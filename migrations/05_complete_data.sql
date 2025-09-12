-- Migración 05: Completar datos para llegar a 10 registros por tabla

-- Completar productos (agregar 12 productos nuevos)
INSERT INTO producto (codigo_producto, nombre, precio, stock, id_categoria) VALUES 
('LIB-001', 'Cien Años de Soledad', 19.99, 35, 15),
('LIB-002', 'Manual de Programación Python', 45.99, 20, 15),
('JUG-001', 'Set de Legos Creativos', 79.99, 18, 16),
('JUG-002', 'Muñeca Barbie Princesa', 24.99, 22, 16),
('BEL-001', 'Crema Facial Hidratante', 32.99, 45, 17),
('BEL-002', 'Perfume Eau de Toilette', 89.99, 28, 17),
('AUT-001', 'Aceite Motor Sintético', 25.99, 60, 18),
('AUT-002', 'Filtro de Aire Universal', 15.99, 40, 18),
('JAR-001', 'Manguera de Jardín 20m', 34.99, 15, 19),
('JAR-002', 'Set Herramientas Jardín', 69.99, 12, 19),
('MAS-001', 'Comida Premium para Perros', 42.99, 35, 20),
('MAS-002', 'Collar LED para Mascotas', 18.99, 25, 20);

-- Completar ventas (agregar 7 ventas nuevas)
INSERT INTO venta (fecha_hora, total, codigo_cliente, id_empleado) VALUES 
('2024-08-18 11:20:00', 0.00, 'CLI-004', 4),
('2024-08-19 13:45:00', 0.00, 'CLI-005', 5),
('2024-08-20 15:10:00', 0.00, 'CLI-006', 6),
('2024-08-21 09:30:00', 0.00, 'CLI-007', 7),
('2024-08-22 12:15:00', 0.00, 'CLI-008', 8),
('2024-08-23 14:50:00', 0.00, 'CLI-009', 9),
('2024-08-24 16:25:00', 0.00, 'CLI-010', 10);

-- Completar detalles de venta
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) VALUES 
(4, 'LIB-001', 2, 19.99),
(4, 'LIB-002', 1, 45.99),
(5, 'DEPORT-001', 1, 39.99),
(5, 'DEPORT-002', 1, 159.99),
(6, 'JUG-001', 1, 79.99),
(6, 'JUG-002', 2, 24.99),
(7, 'AUT-001', 2, 25.99),
(7, 'AUT-002', 1, 15.99),
(8, 'JAR-001', 1, 34.99),
(8, 'JAR-002', 1, 69.99),
(9, 'MAS-001', 1, 42.99),
(9, 'BEL-002', 1, 89.99),
(10, 'ELEC-002', 1, 1199.99),
(10, 'MAS-002', 2, 18.99);

-- Completar pagos
INSERT INTO pago (metodo_pago, monto, fecha_pago, id_venta) VALUES 
('tarjeta', 85.97, '2024-08-18', 4),
('efectivo', 199.98, '2024-08-19', 5),
('transferencia', 129.97, '2024-08-20', 6),
('tarjeta', 67.97, '2024-08-21', 7),
('efectivo', 104.98, '2024-08-22', 8),
('transferencia', 132.98, '2024-08-23', 9),
('tarjeta', 1237.97, '2024-08-24', 10);

-- Completar pedidos (agregar 8 pedidos nuevos)
INSERT INTO pedido (fecha_pedido, estado, id_proveedor) VALUES 
('2024-08-13', 'completado', 3),
('2024-08-14', 'pendiente', 4),
('2024-08-15', 'completado', 5),
('2024-08-16', 'pendiente', 6),
('2024-08-17', 'completado', 7),
('2024-08-18', 'cancelado', 8),
('2024-08-19', 'pendiente', 9),
('2024-08-20', 'completado', 10);

-- Completar detalles de pedidos
INSERT INTO detalle_pedido (id_pedido, codigo_producto, cantidad, precio_unitario) VALUES 
(3, 'HOGAR-001', 8, 250.00),
(3, 'HOGAR-002', 15, 40.00),
(4, 'DEPORT-001', 25, 35.00),
(4, 'DEPORT-002', 10, 140.00),
(5, 'LIB-001', 50, 15.00),
(5, 'LIB-002', 25, 35.00),
(6, 'JUG-001', 12, 65.00),
(6, 'JUG-002', 20, 20.00),
(7, 'BEL-001', 30, 28.00),
(7, 'BEL-002', 15, 75.00),
(9, 'JAR-001', 20, 28.00),
(9, 'JAR-002', 15, 60.00),
(10, 'MAS-001', 25, 38.00),
(10, 'MAS-002', 30, 15.00);

SELECT 'Datos completados exitosamente - ahora cada tabla tiene 10+ registros' as status;