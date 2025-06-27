-- Create the main schema for our practice database
CREATE SCHEMA IF NOT EXISTS practice_app;

-- Set the default search path
ALTER DATABASE practice SET search_path TO practice_app, public;