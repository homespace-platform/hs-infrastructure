-- Chạy một lần khi volume Postgres còn trống (docker-entrypoint-initdb.d).
-- Keycloak uses the "keycloak" database (POSTGRES_DB).
-- The modular monolith uses one shared core database.

CREATE DATABASE homespace_core;
GRANT ALL PRIVILEGES ON DATABASE homespace_core TO homespace;
