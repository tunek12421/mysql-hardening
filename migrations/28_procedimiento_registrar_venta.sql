-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 5
-- =================================================================
-- Crear un procedimiento almacenado llamado registrar_venta que:
-- 1. Disminuya el stock de un producto
-- 2. Inserte una nueva venta
-- 3. Inserte el detalle de la venta
-- 4. Confirme la transacción con COMMIT

START TRANSACTION;

-- Eliminar el procedimiento si existe para recrearlo
DROP PROCEDURE IF EXISTS registrar_venta;

-- Crear el procedimiento almacenado registrar_venta
DELIMITER //
CREATE PROCEDURE registrar_venta(
    IN p_codigo_cliente VARCHAR(10),     -- Cliente que realiza la compra
    IN p_id_empleado INT,                -- Empleado que atiende la venta
    IN p_codigo_producto VARCHAR(10),    -- Producto vendido
    IN p_cantidad INT                    -- Cantidad vendida
)
BEGIN
    -- Variables para manejar el procedimiento
    DECLARE v_id_venta INT DEFAULT 0;
    DECLARE v_precio_unitario DECIMAL(8,2) DEFAULT 0.00;
    DECLARE v_stock_actual INT DEFAULT 0;
    DECLARE v_total_venta DECIMAL(10,2) DEFAULT 0.00;
    
    -- Variables para manejo de errores
    DECLARE v_error_message VARCHAR(255) DEFAULT '';
    DECLARE v_sql_error BOOLEAN DEFAULT FALSE;
    
    -- Declarar handler para errores SQL
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_sql_error = TRUE;
        GET DIAGNOSTICS CONDITION 1
            v_error_message = MESSAGE_TEXT;
    END;
    
    -- =================================================================
    -- INICIAR TRANSACCIÓN EXPLÍCITA
    -- =================================================================
    START TRANSACTION;
    
    -- Validación de parámetros de entrada
    IF p_cantidad <= 0 THEN
        SET v_error_message = 'La cantidad debe ser mayor a 0';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La cantidad debe ser mayor a 0';
    END IF;
    
    -- =================================================================
    -- PASO 1: VERIFICAR Y DISMINUIR EL STOCK DEL PRODUCTO
    -- =================================================================
    
    -- Obtener información del producto con bloqueo para evitar condiciones de carrera
    SELECT precio, stock INTO v_precio_unitario, v_stock_actual
    FROM producto 
    WHERE codigo_producto = p_codigo_producto
    FOR UPDATE;
    
    -- Verificar que el producto existe
    IF v_precio_unitario IS NULL THEN
        SET v_error_message = CONCAT('Producto no encontrado: ', p_codigo_producto);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- Verificar que hay suficiente stock
    IF v_stock_actual < p_cantidad THEN
        SET v_error_message = CONCAT('Stock insuficiente. Stock actual: ', v_stock_actual, ', Cantidad solicitada: ', p_cantidad);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- Disminuir el stock del producto
    UPDATE producto 
    SET stock = stock - p_cantidad,
        updated_at = CURRENT_TIMESTAMP
    WHERE codigo_producto = p_codigo_producto;
    
    -- Verificar que la actualización fue exitosa
    IF ROW_COUNT() = 0 THEN
        SET v_error_message = 'Error al actualizar el stock del producto';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- =================================================================
    -- PASO 2: INSERTAR NUEVA VENTA
    -- =================================================================
    
    -- Calcular el total de la venta
    SET v_total_venta = v_precio_unitario * p_cantidad;
    
    -- Insertar la venta
    INSERT INTO venta (
        fecha_hora, 
        total, 
        codigo_cliente, 
        id_empleado,
        created_at
    ) VALUES (
        NOW(), 
        v_total_venta, 
        p_codigo_cliente, 
        p_id_empleado,
        CURRENT_TIMESTAMP
    );
    
    -- Obtener el ID de la venta recién insertada
    SET v_id_venta = LAST_INSERT_ID();
    
    -- Verificar que la venta fue insertada
    IF v_id_venta = 0 THEN
        SET v_error_message = 'Error al insertar la venta';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- =================================================================
    -- PASO 3: INSERTAR EL DETALLE DE LA VENTA
    -- =================================================================
    
    -- Insertar el detalle de la venta
    INSERT INTO detalle_venta (
        id_venta,
        codigo_producto,
        cantidad,
        precio_unitario,
        created_at
    ) VALUES (
        v_id_venta,
        p_codigo_producto,
        p_cantidad,
        v_precio_unitario,
        CURRENT_TIMESTAMP
    );
    
    -- Verificar que el detalle fue insertado
    IF ROW_COUNT() = 0 THEN
        SET v_error_message = 'Error al insertar el detalle de la venta';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- =================================================================
    -- PASO 4: CONFIRMAR LA TRANSACCIÓN CON COMMIT
    -- =================================================================
    
    -- Si no hay errores, confirmar la transacción
    IF v_sql_error = FALSE THEN
        COMMIT;
        
        -- Retornar información de la venta exitosa
        SELECT 
            'VENTA REGISTRADA EXITOSAMENTE' as resultado,
            v_id_venta as id_venta_generada,
            p_codigo_cliente as cliente,
            p_codigo_producto as producto,
            p_cantidad as cantidad_vendida,
            v_precio_unitario as precio_unitario,
            v_total_venta as total_venta,
            (v_stock_actual - p_cantidad) as nuevo_stock;
    ELSE
        -- Si hay errores, hacer rollback
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
END//
DELIMITER ;

COMMIT;

-- =================================================================
-- VERIFICACIÓN Y DEMOSTRACIÓN
-- =================================================================

SELECT 'Procedimiento registrar_venta creado exitosamente' as resultado;

-- Mostrar información de procedimientos
SELECT 'Información del procedimiento creado:' as info;
SHOW CREATE PROCEDURE registrar_venta\G

-- Mostrar estado inicial para la demostración
SELECT 'ESTADO INICIAL PARA DEMOSTRACIÓN:' as demo;

-- Mostrar productos disponibles
SELECT 'Productos con stock disponible:' as productos;
SELECT codigo_producto, nombre, precio, stock 
FROM producto 
WHERE stock > 0 
ORDER BY stock DESC 
LIMIT 5;

-- Mostrar clientes disponibles
SELECT 'Clientes registrados:' as clientes;
SELECT codigo_cliente, nombre 
FROM cliente 
ORDER BY codigo_cliente 
LIMIT 3;

-- Mostrar empleados disponibles
SELECT 'Empleados activos:' as empleados;
SELECT id_empleado, nombre_completo, cargo 
FROM empleado 
ORDER BY id_empleado 
LIMIT 3;