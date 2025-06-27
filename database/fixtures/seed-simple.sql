-- Simple Practice Database Seed Data (2 tables only)
-- Set search path for all operations
SET search_path TO practice_app;

-- =====================================================
-- COMPANIES
-- =====================================================

INSERT INTO company (id, name, slug, status) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'Acme Social Media', 'acme-social', 'ACTIVE'),
    ('550e8400-e29b-41d4-a716-446655440002', 'Brand Masters Co', 'brand-masters', 'ACTIVE'),
    ('550e8400-e29b-41d4-a716-446655440003', 'Creative Agency Ltd', 'creative-agency', 'ACTIVE');

-- =====================================================
-- USERS
-- =====================================================

INSERT INTO users (id, company_id, email, first_name, last_name, status) VALUES
    -- Acme Social Media users
    ('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'john.doe@acme.com', 'John', 'Doe', 'ACTIVE'),
    ('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'jane.smith@acme.com', 'Jane', 'Smith', 'ACTIVE'),
    ('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'mike.wilson@acme.com', 'Mike', 'Wilson', 'INVITED'),
    
    -- Brand Masters Co users
    ('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'sarah.brown@brandmasters.com', 'Sarah', 'Brown', 'ACTIVE'),
    ('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440002', 'david.lee@brandmasters.com', 'David', 'Lee', 'ACTIVE'),
    
    -- Creative Agency Ltd users
    ('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'emma.taylor@creative.com', 'Emma', 'Taylor', 'ACTIVE');

-- =====================================================
-- USER ROLES
-- =====================================================

INSERT INTO user_role (id, user_id, company_id, role) VALUES
    ('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'OWNER'),
    ('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'ADMIN'),
    ('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'MEMBER'),
    ('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'OWNER'),
    ('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440002', 'MEMBER'),
    ('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'OWNER');

-- Update timestamps to current
UPDATE company SET updated_at = NOW();
UPDATE users SET updated_at = NOW(); 