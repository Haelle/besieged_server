CREATE ROLE the_besieged WITH LOGIN CREATEDB PASSWORD 'password';
CREATE DATABASE the_besieged_production WITH OWNER the_besieged;
CREATE DATABASE the_besieged_development WITH OWNER the_besieged;
CREATE DATABASE the_besieged_test WITH OWNER the_besieged;

\c the_besieged_development
CREATE EXTENSION pgcrypto;

\c the_besieged_test
CREATE EXTENSION pgcrypto;

\c the_besieged_production
CREATE EXTENSION pgcrypto;
