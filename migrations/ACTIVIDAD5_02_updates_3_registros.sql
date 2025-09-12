-- Actualizar 3 registros de cada tabla
   UPDATE cliente SET telefono = CONCAT('NEW-', telefono) 
   WHERE codigo_cliente IN ('CLI-001', 'CLI-002', 'CLI-003');
   
   UPDATE producto SET precio = precio * 1.05 
   WHERE codigo_producto IN ('ELEC-001', 'ELEC-002', 'ROPA-001');
   -- etc...