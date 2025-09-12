-- Migración 02: Creación del esquema TiendaDB
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cliente (
    codigo_cliente VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    direccion TEXT,
    fecha_registro DATE NOT NULL DEFAULT (CURDATE()),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_cliente_correo (correo_electronico),
    INDEX idx_cliente_nombre (nombre)
);

CREATE TABLE IF NOT EXISTS empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL CHECK (salario > 0),
    fecha_contratacion DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_empleado_cargo (cargo),
    INDEX idx_empleado_fecha (fecha_contratacion)
);

CREATE TABLE IF NOT EXISTS proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    direccion TEXT,
    correo_electronico VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_proveedor_nombre (nombre)
);

CREATE TABLE IF NOT EXISTS producto (
    codigo_producto VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(8,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    id_categoria INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_producto_nombre (nombre),
    INDEX idx_producto_categoria (id_categoria),
    INDEX idx_producto_precio (precio)
);

CREATE TABLE IF NOT EXISTS venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    codigo_cliente VARCHAR(10) NOT NULL,
    id_empleado INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo_cliente) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_venta_fecha (fecha_hora),
    INDEX idx_venta_cliente (codigo_cliente),
    INDEX idx_venta_empleado (id_empleado)
);

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido DATE NOT NULL DEFAULT (CURDATE()),
    estado ENUM('pendiente', 'completado', 'cancelado') NOT NULL DEFAULT 'pendiente',
    id_proveedor INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_pedido_fecha (fecha_pedido),
    INDEX idx_pedido_estado (estado),
    INDEX idx_pedido_proveedor (id_proveedor)
);

CREATE TABLE IF NOT EXISTS pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    monto DECIMAL(10,2) NOT NULL CHECK (monto > 0),
    fecha_pago DATE NOT NULL DEFAULT (CURDATE()),
    id_venta INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    INDEX idx_pago_fecha (fecha_pago),
    INDEX idx_pago_metodo (metodo_pago),
    INDEX idx_pago_venta (id_venta)
);

CREATE TABLE IF NOT EXISTS detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    codigo_producto VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(8,2) NOT NULL CHECK (precio_unitario >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo_producto) REFERENCES producto(codigo_producto) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    UNIQUE KEY unique_venta_producto (id_venta, codigo_producto),
    INDEX idx_detalle_venta_producto (codigo_producto)
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    codigo_producto VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(8,2) NOT NULL CHECK (precio_unitario >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo_producto) REFERENCES producto(codigo_producto) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    UNIQUE KEY unique_pedido_producto (id_pedido, codigo_producto),
    INDEX idx_detalle_pedido_producto (codigo_producto)
);

DELIMITER //
CREATE TRIGGER tr_actualizar_total_venta_insert
    AFTER INSERT ON detalle_venta
    FOR EACH ROW
BEGIN
    UPDATE venta 
    SET total = (
        SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
        FROM detalle_venta 
        WHERE id_venta = NEW.id_venta
    )
    WHERE id_venta = NEW.id_venta;
END//

CREATE TRIGGER tr_actualizar_total_venta_update
    AFTER UPDATE ON detalle_venta
    FOR EACH ROW
BEGIN
    UPDATE venta 
    SET total = (
        SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
        FROM detalle_venta 
        WHERE id_venta = NEW.id_venta
    )
    WHERE id_venta = NEW.id_venta;
END//

CREATE TRIGGER tr_actualizar_total_venta_delete
    AFTER DELETE ON detalle_venta
    FOR EACH ROW
BEGIN
    UPDATE venta 
    SET total = (
        SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
        FROM detalle_venta 
        WHERE id_venta = OLD.id_venta
    )
    WHERE id_venta = OLD.id_venta;
END//

CREATE TRIGGER tr_actualizar_stock_venta
    AFTER INSERT ON detalle_venta
    FOR EACH ROW
BEGIN
    UPDATE producto 
    SET stock = stock - NEW.cantidad
    WHERE codigo_producto = NEW.codigo_producto;
    
    IF (SELECT stock FROM producto WHERE codigo_producto = NEW.codigo_producto) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el producto';
    END IF;
END//

DELIMITER ;

SELECT 'Esquema TiendaDB creado exitosamente' as status;