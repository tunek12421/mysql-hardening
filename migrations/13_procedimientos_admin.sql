START TRANSACTION;

-- ADMIN TECNICO: Procedimiento para actualizacion masiva de precios
-- Permite ajustar precios por categoria (inflacion, promociones, etc.)
DELIMITER //
CREATE PROCEDURE ActualizacionMasivaPrecio(
    IN p_id_categoria INT,        -- ID de la categoria a actualizar
    IN p_porcentaje DECIMAL(5,2)  -- Porcentaje de ajuste (+10.50 para +10.5%)
)
BEGIN
    -- Aplicar el ajuste de precio a todos los productos de la categoria
    UPDATE producto 
    SET precio = precio * (1 + p_porcentaje/100)  -- Calcular nuevo precio
    WHERE id_categoria = p_id_categoria;          -- Solo la categoria especificada
    
    -- Confirmar la operacion realizada
    SELECT CONCAT('Precios actualizados para categoria ', p_id_categoria, ' con ', p_porcentaje, '%') as resultado;
END//
DELIMITER ;

COMMIT;

SELECT 'Procedimiento ActualizacionMasivaPrecio creado exitosamente' as status;