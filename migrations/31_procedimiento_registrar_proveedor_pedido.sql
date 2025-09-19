-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 7
-- =================================================================
-- Crear un procedimiento almacenado llamado registrar_proveedor_pedido que:
-- 1. Inserte un nuevo proveedor válido
-- 2. Cree un SAVEPOINT
-- 3. Intente insertar un pedido con un proveedor inexistente
-- 4. Revierta solo el error con ROLLBACK TO SAVEPOINT
-- 5. Confirme los datos válidos con COMMIT

START TRANSACTION;

-- Eliminar el procedimiento si existe para recrearlo
DROP PROCEDURE IF EXISTS registrar_proveedor_pedido;

-- Crear el procedimiento almacenado registrar_proveedor_pedido
DELIMITER //
CREATE PROCEDURE registrar_proveedor_pedido()
BEGIN
    -- Variables para controlar el flujo y almacenar información
    DECLARE v_error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE v_error_message VARCHAR(255) DEFAULT '';
    DECLARE v_sql_state VARCHAR(5) DEFAULT '00000';
    DECLARE v_proveedores_antes INT DEFAULT 0;
    DECLARE v_proveedores_despues INT DEFAULT 0;
    DECLARE v_pedidos_antes INT DEFAULT 0;
    DECLARE v_pedidos_despues INT DEFAULT 0;
    DECLARE v_id_proveedor_nuevo INT DEFAULT 0;
    DECLARE v_proveedor_inexistente INT DEFAULT 9999;
    
    -- Handler para capturar errores
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
    
    -- Contar registros antes de las operaciones
    SELECT COUNT(*) INTO v_proveedores_antes FROM proveedor;
    SELECT COUNT(*) INTO v_pedidos_antes FROM pedido;
    
    -- Mostrar información inicial
    SELECT 'PROCEDIMIENTO registrar_proveedor_pedido - DEMOSTRACIÓN DE SAVEPOINT' as titulo;
    SELECT 'Estado inicial:' as fase;
    SELECT v_proveedores_antes as proveedores_antes;
    SELECT v_pedidos_antes as pedidos_antes;
    
    -- =================================================================
    -- INICIAR TRANSACCIÓN PRINCIPAL
    -- =================================================================
    
    START TRANSACTION;
    
    SELECT 'Transacción principal iniciada' as transaccion_principal;
    
    -- =================================================================
    -- PASO 1: INSERTAR NUEVO PROVEEDOR VÁLIDO
    -- =================================================================
    
    SELECT 'PASO 1: Insertando nuevo proveedor válido...' as paso1;
    
    INSERT INTO proveedor (
        nombre, 
        telefono, 
        direccion, 
        correo_electronico
    ) VALUES (
        'Proveedor Savepoint Demo',
        '555-SAVE-01',
        'Avenida Savepoint 123, Ciudad Demo',
        'savepoint.demo@proveedores.com'
    );
    
    -- Obtener el ID del proveedor recién insertado
    SET v_id_proveedor_nuevo = LAST_INSERT_ID();
    
    -- Verificar que se insertó correctamente
    IF ROW_COUNT() > 0 THEN
        SELECT 'Proveedor insertado exitosamente' as resultado_paso1;
        SELECT v_id_proveedor_nuevo as id_proveedor_nuevo;
        SELECT nombre, telefono, correo_electronico 
        FROM proveedor 
        WHERE id_proveedor = v_id_proveedor_nuevo;
    ELSE
        SELECT 'Error al insertar proveedor' as error_paso1;
    END IF;
    
    -- =================================================================
    -- PASO 2: CREAR SAVEPOINT
    -- =================================================================
    
    SELECT 'PASO 2: Creando SAVEPOINT...' as paso2;
    
    SAVEPOINT sp_despues_proveedor;
    
    SELECT 'SAVEPOINT sp_despues_proveedor creado exitosamente' as savepoint_creado;
    SELECT 'Estado protegido: Proveedor válido insertado' as estado_protegido;
    
    -- =================================================================
    -- PASO 3: INTENTAR INSERTAR PEDIDO CON PROVEEDOR INEXISTENTE
    -- =================================================================
    
    SELECT 'PASO 3: Intentando insertar pedido con proveedor inexistente...' as paso3;
    SELECT CONCAT('ID de proveedor inexistente que usaremos: ', v_proveedor_inexistente) as proveedor_invalido;
    
    -- Esta operación causará un error por violación de clave foránea
    INSERT INTO pedido (
        fecha_pedido,
        estado,
        id_proveedor
    ) VALUES (
        CURDATE(),
        'pendiente',
        v_proveedor_inexistente  -- Este proveedor no existe
    );
    
    -- Si llegamos aquí sin error, algo está mal
    IF v_error_occurred = FALSE THEN
        SELECT 'INESPERADO: El pedido se insertó sin error' as resultado_inesperado;
    END IF;
    
    -- =================================================================
    -- PASO 4: VERIFICAR ERROR Y ROLLBACK TO SAVEPOINT
    -- =================================================================
    
    IF v_error_occurred = TRUE THEN
        SELECT 'ERROR DETECTADO en inserción de pedido' as error_detectado;
        SELECT v_sql_state as codigo_error;
        SELECT v_error_message as mensaje_error;
        
        SELECT 'PASO 4: Ejecutando ROLLBACK TO SAVEPOINT...' as paso4;
        
        -- Rollback solo hasta el savepoint (mantiene el proveedor)
        ROLLBACK TO SAVEPOINT sp_despues_proveedor;
        
        SELECT 'ROLLBACK TO SAVEPOINT ejecutado exitosamente' as rollback_parcial;
        SELECT 'El proveedor válido se mantiene, solo se revirtió el pedido fallido' as explicacion_rollback;
        
        -- Resetear flag de error para continuar
        SET v_error_occurred = FALSE;
        
    ELSE
        SELECT 'No se detectó error (inesperado)' as sin_error;
    END IF;
    
    -- =================================================================
    -- VERIFICACIÓN INTERMEDIA
    -- =================================================================
    
    SELECT 'VERIFICACIÓN INTERMEDIA:' as verificacion_intermedia;
    
    -- Verificar que el proveedor aún existe
    SELECT 'Verificando que el proveedor válido AÚN EXISTE:' as verificacion_proveedor;
    SELECT COUNT(*) as proveedor_existe
    FROM proveedor 
    WHERE id_proveedor = v_id_proveedor_nuevo;
    
    -- Contar pedidos actuales (no debería haber aumentado)
    SELECT COUNT(*) INTO v_pedidos_despues FROM pedido;
    SELECT 'Pedidos antes vs después del error:' as verificacion_pedidos;
    SELECT v_pedidos_antes as pedidos_antes, v_pedidos_despues as pedidos_despues;
    
    -- =================================================================
    -- PASO 5: CONFIRMAR DATOS VÁLIDOS CON COMMIT
    -- =================================================================
    
    SELECT 'PASO 5: Confirmando datos válidos con COMMIT...' as paso5;
    
    -- Insertar un pedido válido para demostrar que la transacción sigue activa
    SELECT 'Insertando pedido válido con el proveedor recién creado:' as pedido_valido;
    
    INSERT INTO pedido (
        fecha_pedido,
        estado,
        id_proveedor
    ) VALUES (
        CURDATE(),
        'pendiente',
        v_id_proveedor_nuevo  -- Este proveedor SÍ existe
    );
    
    IF ROW_COUNT() > 0 THEN
        SELECT 'Pedido válido insertado exitosamente' as pedido_valido_resultado;
        SELECT LAST_INSERT_ID() as id_pedido_creado;
    END IF;
    
    -- Confirmar toda la transacción
    COMMIT;
    
    SELECT 'COMMIT ejecutado - Transacción completada exitosamente' as commit_final;
    
    -- =================================================================
    -- VERIFICACIÓN FINAL
    -- =================================================================
    
    -- Contar registros después de todas las operaciones
    SELECT COUNT(*) INTO v_proveedores_despues FROM proveedor;
    SELECT COUNT(*) INTO v_pedidos_despues FROM pedido;
    
    SELECT 'VERIFICACIÓN FINAL:' as verificacion_final;
    SELECT v_proveedores_antes as proveedores_antes;
    SELECT v_proveedores_despues as proveedores_despues;
    SELECT (v_proveedores_despues - v_proveedores_antes) as nuevos_proveedores;
    
    SELECT v_pedidos_antes as pedidos_antes_final;
    SELECT v_pedidos_despues as pedidos_despues_final;
    SELECT (v_pedidos_despues - v_pedidos_antes) as nuevos_pedidos;
    
    -- Mostrar el proveedor creado
    SELECT 'Proveedor creado y confirmado:' as proveedor_final;
    SELECT id_proveedor, nombre, telefono, correo_electronico
    FROM proveedor 
    WHERE id_proveedor = v_id_proveedor_nuevo;
    
    -- Mostrar el pedido creado
    SELECT 'Pedido válido creado:' as pedido_final;
    SELECT p.id_pedido, p.fecha_pedido, p.estado, pr.nombre as proveedor_nombre
    FROM pedido p
    JOIN proveedor pr ON p.id_proveedor = pr.id_proveedor
    WHERE p.id_proveedor = v_id_proveedor_nuevo;
    
    -- =================================================================
    -- EXPLICACIÓN DE SAVEPOINT
    -- =================================================================
    
    SELECT 'EXPLICACIÓN DE SAVEPOINT:' as explicacion_savepoint;
    SELECT '1. SAVEPOINT permite crear puntos de control dentro de una transacción' as concepto1;
    SELECT '2. ROLLBACK TO SAVEPOINT revierte solo hasta ese punto específico' as concepto2;
    SELECT '3. Las operaciones anteriores al SAVEPOINT se mantienen' as concepto3;
    SELECT '4. La transacción principal sigue activa después del rollback parcial' as concepto4;
    SELECT '5. COMMIT al final confirma todas las operaciones válidas' as concepto5;
    
    SELECT 'RESULTADO DEMOSTRADO:' as resultado_demo;
    SELECT '✅ Proveedor válido insertado y confirmado' as demo1;
    SELECT '❌ Pedido inválido rechazado y revertido' as demo2;
    SELECT '✅ Pedido válido insertado después del error' as demo3;
    SELECT '✅ Transacción completada exitosamente' as demo4;
    
END//
DELIMITER ;

COMMIT;

-- =================================================================
-- INFORMACIÓN PREVIA PARA DEMOSTRACIÓN
-- =================================================================

SELECT 'Procedimiento registrar_proveedor_pedido creado exitosamente' as resultado;

-- Mostrar estado inicial antes de la prueba
SELECT 'ESTADO INICIAL ANTES DE LA PRUEBA:' as estado_inicial;
SELECT COUNT(*) as total_proveedores FROM proveedor;
SELECT COUNT(*) as total_pedidos FROM pedido;

SELECT 'Últimos proveedores registrados:' as proveedores_actuales;
SELECT id_proveedor, nombre, telefono 
FROM proveedor 
ORDER BY id_proveedor DESC 
LIMIT 3;