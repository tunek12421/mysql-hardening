# MySQL Security Hardening Project

Este proyecto implementa paso a paso las configuraciones de seguridad (hardening) de MySQL usando Docker.

## Estructura del Proyecto

```
mysql-hardening-proyecto/
├── config/                 # Archivos de configuración MySQL
├── migrations/             # Migraciones de hardening (una por configuración)
├── scripts/               # Scripts de utilidad
├── logs/                  # Logs de MySQL
├── data/                  # Datos persistentes de MySQL
├── docker-compose.yml     # Configuración de contenedores
└── README.md             # Este archivo
```

## Cómo usar este proyecto

1. **Levantar la base de datos básica:**
   ```bash
   docker-compose up -d
   ```

2. **Ver logs:**
   ```bash
   docker-compose logs -f mysql
   ```

3. **Conectar a la base de datos:**
   ```bash
   docker exec -it mysql-hardening mysql -u root -p
   ```

4. **Aplicar cada migración de hardening** (se crearán paso a paso)

## Migraciones Planeadas

- 01_init_database.sql ✅ (Inicialización básica)
- 02_password_policy.sql (Política de contraseñas)
- 03_user_management.sql (Gestión de usuarios)
- 04_network_security.sql (Seguridad de red)
- 05_audit_logging.sql (Auditoría y logs)
- ... (más configuraciones según PDF)

## Estado Actual

- [x] Estructura básica del proyecto
- [x] Docker Compose configurado
- [x] Configuración MySQL básica
- [ ] Hardening paso a paso (pendiente)# mysql-hardening
# mysql-hardening
