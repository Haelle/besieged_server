CREATE ROLE shared_world WITH LOGIN CREATEDB PASSWORD 'password';

\c shared_world_development
CREATE EXTENSION pgcrypto;

\c shared_world_test
CREATE EXTENSION pgcrypto;

\c shared_world_production
CREATE EXTENSION pgcrypto;
