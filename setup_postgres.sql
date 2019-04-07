CREATE ROLE shared_world WITH LOGIN CREATEDB PASSWORD 'password';
CREATE DATABASE shared_world_production WITH OWNER shared_world;
CREATE DATABASE shared_world_development WITH OWNER shared_world;
CREATE DATABASE shared_world_test WITH OWNER shared_world;

\c shared_world_development
CREATE EXTENSION pgcrypto;

\c shared_world_test
CREATE EXTENSION pgcrypto;

\c shared_world_production
CREATE EXTENSION pgcrypto;
