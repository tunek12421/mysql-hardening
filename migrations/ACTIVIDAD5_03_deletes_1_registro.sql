-- IMPORTANTE: Eliminar primero registros dependientes
   DELETE FROM detalle_venta WHERE id_venta = 10;
   DELETE FROM pago WHERE id_venta = 10;
   DELETE FROM venta WHERE id_venta = 10;
   
   DELETE FROM cliente WHERE codigo_cliente = 'CLI-010';
   -- etc...