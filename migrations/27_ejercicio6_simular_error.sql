-- Ejercicio 6: Cree un procedimiento almacenado llamado simular_error que intente insertar un
-- cliente con un email duplicado.
-- La transacción debe revertirse usando ROLLBACK.
-- Explique qué sucede con los datos después de ejecutar el procedimiento.
USE TiendaDB;

DELIMITER //
CREATE PROCEDURE simular_error()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Transacción revertida por email duplicado' as resultado;
    END;

    START TRANSACTION;

    SELECT 'Insertando cliente con email duplicado...' as info;

    -- Intentar insertar cliente con email que ya existe
    INSERT INTO cliente (codigo_cliente, nombre, correo_electronico, telefono, direccion)
    VALUES ('CLI-999', 'Cliente Test Error', 'juan.perez@email.com', '999-999-9999', 'Calle Error 123');

    COMMIT;
    SELECT 'ERROR: No se detectó el email duplicado' as resultado;
END//
DELIMITER ;

-- Pruebas
SELECT 'Clientes antes del procedimiento:' as info;
SELECT COUNT(*) as total_clientes FROM cliente;

SELECT 'Email existente:' as info;
SELECT codigo_cliente, nombre, correo_electronico FROM cliente WHERE correo_electronico = 'juan.perez@email.com';

CALL simular_error();

SELECT 'Clientes después del procedimiento:' as info;
SELECT COUNT(*) as total_clientes FROM cliente;

SELECT 'Verificar que CLI-999 no fue insertado:' as info;
SELECT COUNT(*) as cliente_cli999 FROM cliente WHERE codigo_cliente = 'CLI-999';

-- Explicación: Los datos no cambian porque ROLLBACK revierte todas las operaciones
-- de la transacción cuando se detecta el error de email duplicado