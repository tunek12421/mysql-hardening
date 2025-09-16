START TRANSACTION;

-- CORRECIÓN DE PERMISOS PARA PDF PARTE 2
-- Agregar permisos faltantes identificados en la verificación

-- CAJERO: Necesita UPDATE en stock para completar el flujo de ventas
GRANT UPDATE (stock) ON TiendaDB.producto TO 'cajero'@'localhost';

-- GERENTE: Necesita INDEX para crear índices en optimización de consultas
GRANT INDEX ON TiendaDB.* TO 'gerente'@'localhost';

FLUSH PRIVILEGES;

COMMIT;

SELECT 'Permisos corregidos exitosamente para PDF Parte 2' as status;
