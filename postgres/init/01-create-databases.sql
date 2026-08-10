-- Chạy một lần khi volume Postgres còn trống (docker-entrypoint-initdb.d).
-- Keycloak dùng DB "keycloak" (POSTGRES_DB). Service dùng DB riêng bên dưới.

CREATE DATABASE "hs-user-service";
GRANT ALL PRIVILEGES ON DATABASE "hs-user-service" TO homespace;
