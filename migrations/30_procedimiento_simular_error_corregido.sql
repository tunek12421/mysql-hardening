-- =================================================================
-- CORRECCIÓN DEL EJERCICIO 6 - PROCEDIMIENTO simular_error
-- =================================================================
-- Crear un procedimiento almacenado corregido que simule error por email duplicado

START TRANSACTION;

-- Eliminar el procedimiento anterior
DROP PROCEDURE IF EXISTS simular_error;

-- Crear el procedimiento almacenado simular_error corregido
DELIMITER //
CREATE PROCEDURE simular_error()
BEGIN
    -- Variables para controlar el flujo y almacenar información
    DECLARE v_error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE v_error_message VARCHAR(255) DEFAULT '';
    DECLARE v_sql_state VARCHAR(5) DEFAULT '00000';
    DECLARE v_clientes_antes INT DEFAULT 0;
    DECLARE v_clientes_despues INT DEFAULT 0;
    DECLARE v_email_duplicado VARCHAR(100) DEFAULT '';
    
    -- Handler para capturar errores de duplicación
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error_occurred = TRUE;
        GET DIAGNOSTICS CONDITION 1
            v_sql_state = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
    END;
    
    -- =================================================================
    -- PREPARACIÓN: VERIFICAR ESTADO INICIAL
    -- =================================================================
    
    -- Contar clientes antes de la operación
    SELECT COUNT(*) INTO v_clientes_antes FROM cliente;
    
    -- Obtener un email existente para generar duplicación
    SELECT correo_electronico INTO v_email_duplicado 
    FROM cliente 
    WHERE correo_electronico IS NOT NULL 
    LIMIT 1;
    
    -- Mostrar información inicial
    SELECT 'SIMULACIÓN DE ERROR CON ROLLBACK - VERSIÓN CORREGIDA' as titulo;
    SELECT 'Estado inicial:' as fase;
    SELECT v_clientes_antes as clientes_registrados_antes;
    SELECT v_email_duplicado as email_que_se_duplicara;
    
    -- =================================================================
    -- INICIAR TRANSACCIÓN EXPLÍCITA
    -- =================================================================
    
    START TRANSACTION;
    
    SELECT 'Iniciando transacción...' as accion;
    
    -- =================================================================
    -- INSERTAR CLIENTE VÁLIDO PRIMERO (ESTO DEBERÍA FUNCIONAR)
    -- =================================================================
    
    INSERT INTO cliente (
        codigo_cliente, 
        nombre, 
        correo_electronico, 
        telefono, 
        direccion,
        fecha_registro
    ) VALUES (
        'CLI-T01',  -- Código más corto (10 caracteres máximo)
        'Cliente de Prueba Válido',
        'test_valido@email.com',
        '555-0001',
        'Dirección Test 123',
        CURDATE()
    );
    
    -- Verificar que se insertó correctamente
    IF ROW_COUNT() > 0 THEN
        SELECT 'Cliente válido insertado exitosamente en la transacción' as resultado_insercion_1;
        SELECT codigo_cliente, nombre, correo_electronico 
        FROM cliente 
        WHERE codigo_cliente = 'CLI-T01';
    END IF;
    
    -- =================================================================
    -- INTENTAR INSERTAR CLIENTE CON EMAIL DUPLICADO (ESTO CAUSARÁ ERROR)
    -- =================================================================
    
    SELECT 'Intentando insertar cliente con email duplicado...' as accion_error;
    SELECT CONCAT('Email que causará duplicación: ', v_email_duplicado) as email_problema;
    
    -- Esta inserción causará un error por email duplicado
    INSERT INTO cliente (
        codigo_cliente, 
        nombre, 
        correo_electronico, 
        telefono, 
        direccion,
        fecha_registro
    ) VALUES (
        'CLI-T02',  -- Código más corto
        'Cliente Duplicado',
        v_email_duplicado,  -- Este email ya existe, causará error
        '555-0002',
        'Dirección Test 456',
        CURDATE()
    );
    
    -- =================================================================
    -- VERIFICAR SI OCURRIÓ ERROR Y HACER ROLLBACK
    -- =================================================================
    
    IF v_error_occurred = TRUE THEN
        -- Error detectado, hacer ROLLBACK
        ROLLBACK;
        
        SELECT 'ERROR DETECTADO - EJECUTANDO ROLLBACK' as resultado;
        SELECT v_sql_state as codigo_error_sql;
        SELECT v_error_message as mensaje_error;
        SELECT 'Transacción revertida exitosamente' as estado_transaccion;
        
    ELSE
        -- No hubo error (no debería llegar aquí en este caso)
        COMMIT;
        SELECT 'Transacción completada sin errores (NO ESPERADO)' as resultado;
    END IF;
    
    -- =================================================================
    -- VERIFICACIÓN POST-TRANSACCIÓN
    -- =================================================================
    
    -- Contar clientes después de la operación
    SELECT COUNT(*) INTO v_clientes_despues FROM cliente;
    
    SELECT 'VERIFICACIÓN DESPUÉS DEL ROLLBACK:' as verificacion;
    SELECT v_clientes_antes as clientes_antes;
    SELECT v_clientes_despues as clientes_despues;
    SELECT (v_clientes_despues - v_clientes_antes) as diferencia;
    
    -- Verificar que los clientes de prueba NO existen
    SELECT 'Verificando que los clientes de prueba NO existen:' as busqueda;
    SELECT COUNT(*) as clientes_test_encontrados
    FROM cliente 
    WHERE codigo_cliente IN ('CLI-T01', 'CLI-T02');
    
    -- Verificar específicamente que CLI-T01 no existe (aunque se insertó exitosamente)
    SELECT 'Cliente CLI-T01 (que se insertó exitosamente) después del ROLLBACK:' as verificacion_especifica;
    SELECT COUNT(*) as cli_t01_existe
    FROM cliente 
    WHERE codigo_cliente = 'CLI-T01';
    
    -- =================================================================
    -- EXPLICACIÓN DETALLADA
    -- =================================================================
    
    SELECT 'EXPLICACIÓN DETALLADA DE LO QUE SUCEDIÓ:' as explicacion;
    SELECT '1. Se inició una transacción explícita con START TRANSACTION' as paso1;
    SELECT '2. Se insertó cliente CLI-T01 exitosamente DENTRO de la transacción' as paso2;
    SELECT '3. Se intentó insertar CLI-T02 con email duplicado (VIOLACIÓN DE UNIQUE)' as paso3;
    SELECT '4. MySQL generó error por violación de restricción UNIQUE' as paso4;
    SELECT '5. El handler SQLEXCEPTION capturó el error automáticamente' as paso5;
    SELECT '6. Se ejecutó ROLLBACK para revertir TODA la transacción' as paso6;
    SELECT '7. CLI-T01 también fue eliminado (ATOMICIDAD TRANSACCIONAL)' as paso7;
    
    SELECT 'PRINCIPIOS ACID DEMOSTRADOS:' as principios_acid;
    SELECT 'ATOMICIDAD: Todo o nada - Si algo falla, todo se revierte' as atomicidad;
    SELECT 'CONSISTENCIA: Las restricciones de integridad se mantienen' as consistencia;
    SELECT 'AISLAMIENTO: La transacción se ejecutó de forma aislada' as aislamiento;
    SELECT 'DURABILIDAD: No aplica porque se hizo ROLLBACK' as durabilidad;
    
END//
DELIMITER ;

COMMIT;

SELECT 'Procedimiento simular_error corregido y listo para ejecutar' as resultado;