CREATE ROLE besieged WITH LOGIN CREATEDB PASSWORD 'password';
CREATE DATABASE besieged_production WITH OWNER besieged;
CREATE DATABASE besieged_development WITH OWNER besieged;
CREATE DATABASE besieged_test WITH OWNER besieged;

\c besieged_development
CREATE EXTENSION pgcrypto;

\c besieged_test
CREATE EXTENSION pgcrypto;

\c besieged_production
CREATE EXTENSION pgcrypto;
