-- Migración 04: Datos extendidos - 10 registros por tabla

-- Las categorías ya fueron insertadas anteriormente, omitiendo duplicados

-- 7 Proveedores nuevos (los primeros 3 ya existen)
INSERT INTO proveedor (nombre, telefono, direccion, correo_electronico) VALUES 
('Deportes Extremos S.A.', '555-2004', 'Avenida del Deporte 456', 'ventas@deportesextremos.com'),
('Editorial Saber Ltda.', '555-2005', 'Calle de los Libros 789', 'distribucion@editorialsaber.com'),
('Juguetes Felicidad S.R.L.', '555-2006', 'Zona Industrial Norte Bloque C', 'pedidos@juguetesfelicidad.com'),
('Belleza Total S.A.', '555-2007', 'Centro Comercial Beauty Plaza', 'mayorista@bellezatotal.com'),
('Auto Repuestos del Sur', '555-2008', 'Carrera Automotriz 321', 'ventas@autorepuestossur.com'),
('Jardines y Más Ltda.', '555-2009', 'Vivero Central Km 15', 'pedidos@jardinesymas.com'),
('Mascotas Amor S.R.L.', '555-2010', 'Avenida Veterinaria 654', 'distribucion@mascotasamor.com');

-- 7 Empleados nuevos (los primeros 3 ya existen)
INSERT INTO empleado (nombre_completo, cargo, salario, fecha_contratacion) VALUES
('Carlos Alberto Ruiz', 'Supervisor de Inventario', 3800.00, '2021-02-10'),
('Ana Sofía Morales', 'Vendedor Junior', 2400.00, '2023-01-20'),
('Diego Fernando López', 'Cajero', 2200.00, '2023-06-12'),
('Carmen Elena Vega', 'Asistente Administrativo', 2800.00, '2022-09-08'),
('José Miguel Torres', 'Encargado de Almacén', 3000.00, '2021-11-25'),
('Paola Andrea Silva', 'Vendedor', 2600.00, '2023-03-18'),
('Fernando Javier Ortiz', 'Contador', 4200.00, '2020-07-22');

-- 7 Clientes nuevos (los primeros 3 ya existen)
INSERT INTO cliente (codigo_cliente, nombre, correo_electronico, telefono, direccion) VALUES
('CLI-004', 'Ana Martínez Silva', 'ana.martinez@email.com', '315-555-0004', 'Transversal 8 #12-34'),
('CLI-005', 'Luis Fernando Gómez', 'luis.gomez@email.com', '301-555-0005', 'Calle 45 #67-89'),
('CLI-006', 'Patricia Jiménez', 'patricia.jimenez@email.com', '317-555-0006', 'Carrera 20 #56-78'),
('CLI-007', 'Miguel Ángel Vargas', 'miguel.vargas@email.com', '310-555-0007', 'Avenida 68 #34-12'),
('CLI-008', 'Sandra Milena Castro', 'sandra.castro@email.com', '314-555-0008', 'Calle 100 #45-23'),
('CLI-009', 'Ricardo Hernández', 'ricardo.hernandez@email.com', '319-555-0009', 'Carrera 7 #89-45'),
('CLI-010', 'Claudia Esperanza Ramos', 'claudia.ramos@email.com', '316-555-0010', 'Diagonal 25 #78-90');

-- 12 Productos nuevos (los primeros 8 ya existen)
INSERT INTO producto (codigo_producto, nombre, precio, stock, id_categoria) VALUES 
('LIBRO-001', 'Cien Años de Soledad', 19.99, 35, 15),
('LIBRO-002', 'Manual de Programación Python', 45.99, 20, 15),
('JUGUET-001', 'Set de Legos Creativos', 79.99, 18, 16),
('JUGUET-002', 'Muñeca Barbie Princesa', 24.99, 22, 16),
('BELLEZA-001', 'Crema Facial Hidratante', 32.99, 45, 17),
('BELLEZA-002', 'Perfume Eau de Toilette', 89.99, 28, 17),
('AUTO-001', 'Aceite Motor Sintético', 25.99, 60, 18),
('AUTO-002', 'Filtro de Aire Universal', 15.99, 40, 18),
('JARDIN-001', 'Manguera de Jardín 20m', 34.99, 15, 19),
('JARDIN-002', 'Set Herramientas Jardín', 69.99, 12, 19),
('MASCOTAS-001', 'Comida Premium para Perros', 42.99, 35, 20),
('MASCOTAS-002', 'Collar LED para Mascotas', 18.99, 25, 20);

-- 7 Ventas nuevas (las primeras 3 ya existen)
INSERT INTO venta (fecha_hora, total, codigo_cliente, id_empleado) VALUES 
('2024-08-18 11:20:00', 0.00, 'CLI-004', 4),
('2024-08-19 13:45:00', 0.00, 'CLI-005', 5),
('2024-08-20 15:10:00', 0.00, 'CLI-006', 2),
('2024-08-21 09:30:00', 0.00, 'CLI-007', 3),
('2024-08-22 12:15:00', 0.00, 'CLI-008', 1),
('2024-08-23 14:50:00', 0.00, 'CLI-009', 4),
('2024-08-24 16:25:00', 0.00, 'CLI-010', 5);

-- Detalles de venta para las nuevas ventas (id_venta 4-10)
INSERT INTO detalle_venta (id_venta, codigo_producto, cantidad, precio_unitario) VALUES 
(4, 'LIBRO-001', 2, 19.99),
(4, 'LIBRO-002', 1, 45.99),
(5, 'DEPORT-001', 1, 39.99),
(5, 'DEPORT-002', 1, 159.99),
(6, 'JUGUET-001', 1, 79.99),
(6, 'JUGUET-002', 2, 24.99),
(7, 'AUTO-001', 2, 25.99),
(7, 'AUTO-002', 1, 15.99),
(8, 'JARDIN-001', 1, 34.99),
(8, 'JARDIN-002', 1, 69.99),
(9, 'MASCOTAS-001', 1, 42.99),
(9, 'BELLEZA-002', 1, 89.99),
(10, 'ELEC-002', 1, 1199.99),
(10, 'MASCOTAS-002', 2, 18.99);

-- 7 Pagos nuevos para las ventas nuevas (id_venta 4-10)
INSERT INTO pago (metodo_pago, monto, fecha_pago, id_venta) VALUES 
('tarjeta', 85.97, '2024-08-18', 4),
('efectivo', 199.98, '2024-08-19', 5),
('transferencia', 129.97, '2024-08-20', 6),
('tarjeta', 67.97, '2024-08-21', 7),
('efectivo', 104.98, '2024-08-22', 8),
('transferencia', 132.98, '2024-08-23', 9),
('tarjeta', 1237.97, '2024-08-24', 10);

-- 8 Pedidos nuevos (los primeros 2 ya existen)
INSERT INTO pedido (fecha_pedido, estado, id_proveedor) VALUES 
('2024-08-13', 'completado', 3),
('2024-08-14', 'pendiente', 4),
('2024-08-15', 'completado', 5),
('2024-08-16', 'pendiente', 6),
('2024-08-17', 'completado', 7),
('2024-08-18', 'cancelado', 8),
('2024-08-19', 'pendiente', 9),
('2024-08-20', 'completado', 10);

-- Detalles para los nuevos pedidos (id_pedido 3-10, saltando el 8 que está cancelado)
INSERT INTO detalle_pedido (id_pedido, codigo_producto, cantidad, precio_unitario) VALUES 
(3, 'HOGAR-001', 8, 250.00),
(3, 'HOGAR-002', 15, 40.00),
(4, 'DEPORT-001', 25, 35.00),
(4, 'DEPORT-002', 10, 140.00),
(5, 'LIBRO-001', 50, 15.00),
(5, 'LIBRO-002', 25, 35.00),
(6, 'JUGUET-001', 12, 65.00),
(6, 'JUGUET-002', 20, 20.00),
(7, 'BELLEZA-001', 30, 28.00),
(7, 'BELLEZA-002', 15, 75.00),
(9, 'JARDIN-001', 20, 28.00),
(9, 'JARDIN-002', 15, 60.00),
(10, 'MASCOTAS-001', 25, 38.00),
(10, 'MASCOTAS-002', 30, 15.00);

SELECT 'Datos extendidos insertados exitosamente - 10 registros por tabla' as status;