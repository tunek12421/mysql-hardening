-- =================================================================
-- GESTIÓN DE ESQUEMAS DE OBJETOS Y TRANSACCIONES - EJERCICIO 4
-- =================================================================
-- Crear una secuencia llamada seq_proveedor para generar identificadores 
-- consecutivos de proveedores.
--
-- NOTA: MySQL/MariaDB no soporta secuencias nativas como PostgreSQL u Oracle.
-- En su lugar, utilizamos AUTO_INCREMENT que ya está implementado en la tabla.
-- Adicionalmente, crearemos una tabla simulada de secuencia para demostrar el concepto.

START TRANSACTION;

-- =====================================================================
-- ANÁLISIS DEL ESTADO ACTUAL
-- =====================================================================

SELECT 'ANÁLISIS: Verificando implementación actual de secuencia en tabla proveedor' as analisis;

-- Mostrar estructura actual con AUTO_INCREMENT
DESCRIBE proveedor;

-- Verificar el valor actual de AUTO_INCREMENT
SELECT 'Valor actual de AUTO_INCREMENT en tabla proveedor:' as info;
SELECT AUTO_INCREMENT as valor_actual_secuencia
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'TiendaDB' AND TABLE_NAME = 'proveedor';

-- =====================================================================
-- IMPLEMENTACIÓN ALTERNATIVA: TABLA DE SECUENCIA SIMULADA
-- =====================================================================

SELECT 'Creando tabla de secuencia simulada seq_proveedor...' as creacion;

-- Crear tabla para simular una secuencia
CREATE TABLE IF NOT EXISTS seq_proveedor (
    id INT PRIMARY KEY,
    nombre_secuencia VARCHAR(50) NOT NULL,
    valor_actual INT NOT NULL DEFAULT 1,
    incremento INT NOT NULL DEFAULT 1,
    valor_minimo INT NOT NULL DEFAULT 1,
    valor_maximo INT NOT NULL DEFAULT 999999999,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertar configuración inicial de la secuencia
INSERT INTO seq_proveedor (id, nombre_secuencia, valor_actual, incremento) 
VALUES (1, 'seq_proveedor', 11, 1)
ON DUPLICATE KEY UPDATE 
    valor_actual = GREATEST(valor_actual, (SELECT COALESCE(MAX(id_proveedor), 0) + 1 FROM proveedor));

-- =====================================================================
-- FUNCIÓN PARA OBTENER SIGUIENTE VALOR DE SECUENCIA
-- =====================================================================

-- Crear función para obtener el siguiente valor
DELIMITER //
CREATE FUNCTION IF NOT EXISTS NEXTVAL_seq_proveedor() 
RETURNS INT
READS SQL DATA
MODIFIES SQL DATA
DETERMINISTIC
BEGIN
    DECLARE next_val INT;
    
    -- Obtener y actualizar el siguiente valor
    UPDATE seq_proveedor 
    SET valor_actual = valor_actual + incremento,
        updated_at = CURRENT_TIMESTAMP
    WHERE nombre_secuencia = 'seq_proveedor';
    
    -- Obtener el valor actualizado
    SELECT valor_actual INTO next_val 
    FROM seq_proveedor 
    WHERE nombre_secuencia = 'seq_proveedor';
    
    RETURN next_val;
END//

-- Crear función para obtener el valor actual sin incrementar
CREATE FUNCTION IF NOT EXISTS CURRVAL_seq_proveedor() 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE curr_val INT;
    
    SELECT valor_actual INTO curr_val 
    FROM seq_proveedor 
    WHERE nombre_secuencia = 'seq_proveedor';
    
    RETURN curr_val;
END//

DELIMITER ;

-- =====================================================================
-- CONFIGURAR AUTO_INCREMENT PARA SINCRONIZACIÓN
-- =====================================================================

-- Sincronizar AUTO_INCREMENT con el próximo valor disponible
SET @next_auto_increment = (SELECT COALESCE(MAX(id_proveedor), 0) + 1 FROM proveedor);
SET @sql = CONCAT('ALTER TABLE proveedor AUTO_INCREMENT = ', @next_auto_increment);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

COMMIT;

-- =====================================================================
-- DEMOSTRACIÓN Y VERIFICACIÓN
-- =====================================================================

SELECT 'DEMOSTRACIÓN DE FUNCIONAMIENTO:' as demo;

-- Mostrar estado actual de la secuencia
SELECT 'Estado actual de seq_proveedor:' as estado;
SELECT * FROM seq_proveedor;

-- Mostrar valor actual sin incrementar
SELECT 'Valor actual de la secuencia:' as actual, CURRVAL_seq_proveedor() as valor;

-- Obtener siguiente valor
SELECT 'Siguiente valor de la secuencia:' as siguiente, NEXTVAL_seq_proveedor() as valor;

-- Verificar AUTO_INCREMENT actualizado
SELECT 'AUTO_INCREMENT sincronizado:' as sync;
SELECT AUTO_INCREMENT as auto_increment_value
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'TiendaDB' AND TABLE_NAME = 'proveedor';

-- Mostrar proveedores existentes
SELECT 'Proveedores actuales:' as existentes;
SELECT id_proveedor, nombre FROM proveedor ORDER BY id_proveedor;

SELECT 'IMPLEMENTACIÓN COMPLETADA:' as resultado;
SELECT '1. AUTO_INCREMENT nativo de MySQL (recomendado)' as opcion1;
SELECT '2. Tabla de secuencia simulada seq_proveedor (demostración)' as opcion2;
SELECT '3. Funciones NEXTVAL y CURRVAL creadas' as opcion3;