-- Verificar que hay suficientes registros (mínimo 5 por tabla)
   SELECT 'cliente' as tabla, COUNT(*) as total FROM cliente
   UNION SELECT 'producto', COUNT(*) FROM producto
   UNION SELECT 'venta', COUNT(*) FROM venta
   -- etc...