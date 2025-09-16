-- Ejercicio 4: Cree una secuencia llamada seq_proveedor para generar identificadores
-- consecutivos de proveedores (si el motor de base de datos lo soporta).
USE TiendaDB;

START TRANSACTION;

CREATE SEQUENCE IF NOT EXISTS seq_proveedor
START WITH 1
INCREMENT BY 1
MAXVALUE 999999;

-- Pruebas de funcionamiento
SELECT NEXTVAL(seq_proveedor) AS primer_id;
SELECT NEXTVAL(seq_proveedor) AS segundo_id;
SELECT NEXTVAL(seq_proveedor) AS tercer_id;

-- Obtener siguiente valor para verificar secuencia
SELECT NEXTVAL(seq_proveedor) AS siguiente_valor;

COMMIT;