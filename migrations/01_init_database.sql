-- Migración 01: Inicialización de la base de datos
-- Este archivo se ejecuta automáticamente al levantar el contenedor por primera vez

-- Crear una tabla de ejemplo para testing
CREATE TABLE IF NOT EXISTS hardening_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(255) NOT NULL,
    test_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba
INSERT INTO hardening_test (test_name, test_description) VALUES 
('Base Setup', 'Configuración inicial de la base de datos'),
('Security Test', 'Tabla para probar configuraciones de seguridad');

-- Mostrar información de la instalación
SELECT 'Base de datos inicializada correctamente' as status;