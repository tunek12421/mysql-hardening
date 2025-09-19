-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 6
-- =================================================================
-- Crear un procedimiento almacenado llamado simular_error que intente insertar 
-- un cliente con un email duplicado.
-- La transacción debe revertirse usando ROLLBACK.

START TRANSACTION;

-- Eliminar el procedimiento si existe para recrearlo
DROP PROCEDURE IF EXISTS simular_error;

-- Crear el procedimiento almacenado simular_error
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
    SELECT 'SIMULACIÓN DE ERROR CON ROLLBACK' as titulo;
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
        'CLI-TEST-001',
        'Cliente de Prueba Válido',
        'cliente_valido_test@email.com',
        '555-TEST-01',
        'Dirección de Prueba 123',
        CURDATE()
    );
    
    -- Verificar que se insertó correctamente
    IF ROW_COUNT() > 0 THEN
        SELECT 'Cliente válido insertado exitosamente' as resultado_insercion_1;
        SELECT codigo_cliente, nombre, correo_electronico 
        FROM cliente 
        WHERE codigo_cliente = 'CLI-TEST-001';
    END IF;
    
    -- =================================================================
    -- INTENTAR INSERTAR CLIENTE CON EMAIL DUPLICADO (ESTO CAUSARÁ ERROR)
    -- =================================================================
    
    SELECT 'Intentando insertar cliente con email duplicado...' as accion_error;
    
    -- Esta inserción causará un error por email duplicado
    INSERT INTO cliente (
        codigo_cliente, 
        nombre, 
        correo_electronico, 
        telefono, 
        direccion,
        fecha_registro
    ) VALUES (
        'CLI-TEST-002',
        'Cliente de Prueba Duplicado',
        v_email_duplicado,  -- Este email ya existe, causará error
        '555-TEST-02',
        'Dirección de Prueba 456',
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
        SELECT 'Transacción completada sin errores' as resultado;
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
    
    -- Verificar que el cliente de prueba NO existe
    SELECT 'Verificando que los clientes de prueba NO existen:' as busqueda;
    SELECT COUNT(*) as clientes_test_encontrados
    FROM cliente 
    WHERE codigo_cliente IN ('CLI-TEST-001', 'CLI-TEST-002');
    
    -- =================================================================
    -- EXPLICACIÓN DE LO QUE SUCEDIÓ
    -- =================================================================
    
    SELECT 'EXPLICACIÓN DE LO QUE SUCEDIÓ:' as explicacion;
    SELECT '1. Se inició una transacción explícita' as paso1;
    SELECT '2. Se insertó un cliente válido (exitoso)' as paso2;
    SELECT '3. Se intentó insertar cliente con email duplicado (error)' as paso3;
    SELECT '4. El handler capturó el error automáticamente' as paso4;
    SELECT '5. Se ejecutó ROLLBACK para revertir TODA la transacción' as paso5;
    SELECT '6. AMBOS clientes fueron eliminados (atomicidad)' as paso6;
    
    SELECT 'PRINCIPIO DEMOSTRADO:' as principio;
    SELECT 'ATOMICIDAD - Todo o nada: Si una parte falla, todo se revierte' as atomicidad;
    
END//
DELIMITER ;

COMMIT;

-- =================================================================
-- INFORMACIÓN PREVIA PARA DEMOSTRACIÓN
-- =================================================================

SELECT 'Procedimiento simular_error creado exitosamente' as resultado;

-- Mostrar clientes existentes antes de la prueba
SELECT 'CLIENTES EXISTENTES ANTES DE LA PRUEBA:' as info_previa;
SELECT codigo_cliente, nombre, correo_electronico 
FROM cliente 
ORDER BY codigo_cliente;

-- Mostrar emails existentes para entender la duplicación
SELECT 'EMAILS EXISTENTES (que causarán duplicación):' as emails_existentes;
SELECT DISTINCT correo_electronico 
FROM cliente 
WHERE correo_electronico IS NOT NULL
ORDER BY correo_electronico;