START TRANSACTION;



CREATE USER IF NOT EXISTS 'cajero'@'localhost' IDENTIFIED BY 'cajero123';

CREATE USER IF NOT EXISTS 'gerente'@'localhost' IDENTIFIED BY 'gerente123';

CREATE USER IF NOT EXISTS 'admin_tecnico'@'localhost' IDENTIFIED BY 'admintecnico123';



GRANT USAGE ON TiendaDB.* TO 'cajero'@'localhost';

GRANT USAGE ON TiendaDB.* TO 'gerente'@'localhost';

GRANT USAGE ON TiendaDB.* TO 'admin_tecnico'@'localhost';



FLUSH PRIVILEGES;



COMMIT;



SELECT 'Usuario creados exitosamente: cajero, gerente, admin_tecnico' as status;

