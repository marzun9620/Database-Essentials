-- Practice Database Schema
-- Based on the patterns from kachi-kaku codebase

-- Set search path for all operations
SET search_path TO practice_app;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- CORE BUSINESS ENTITIES
-- =====================================================

-- Company table for multi-tenancy
CREATE TABLE company (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DELETED')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User management
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'INVITED' CHECK (status IN ('INVITED', 'ACTIVE', 'SUSPENDED', 'DELETED')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Password management
CREATE TABLE password (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    hash TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_password UNIQUE (user_id)
);

-- Session management
CREATE TABLE session (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT valid_session_expiry CHECK (expires_at > created_at)
);

-- =====================================================
-- ROLE-BASED ACCESS CONTROL
-- =====================================================

-- Permissions
CREATE TABLE permission (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User roles
CREATE TABLE user_role (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL CHECK (role IN ('OWNER', 'ADMIN', 'MEMBER', 'VIEWER')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_user_company_role UNIQUE (user_id, company_id)
);

-- Role permissions
CREATE TABLE role_permission (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role VARCHAR(50) NOT NULL,
    permission_id UUID NOT NULL REFERENCES permission(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_role_permission UNIQUE (role, permission_id)
);

-- =====================================================
-- EXTERNAL INTEGRATIONS
-- =====================================================

-- Social media accounts (generic)
CREATE TABLE social_account (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL CHECK (platform IN ('TIKTOK', 'INSTAGRAM', 'YOUTUBE', 'FACEBOOK')),
    external_id VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    display_name VARCHAR(255),
    avatar_url TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'EXPIRED', 'REVOKED', 'ERROR')),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_platform_external_id UNIQUE (platform, external_id)
);

-- OAuth tokens for social accounts
CREATE TABLE social_token (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    social_account_id UUID NOT NULL REFERENCES social_account(id) ON DELETE CASCADE,
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    token_type VARCHAR(50) DEFAULT 'Bearer',
    expires_at TIMESTAMPTZ,
    scope TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_account_token UNIQUE (social_account_id)
);

-- =====================================================
-- ANALYTICS TABLES
-- =====================================================

-- Account daily metrics (fact table)
CREATE TABLE account_daily_metrics (
    id UUID DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    social_account_id UUID NOT NULL REFERENCES social_account(id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    followers_count BIGINT DEFAULT 0,
    following_count BIGINT DEFAULT 0,
    posts_count BIGINT DEFAULT 0,
    engagement_rate DECIMAL(5,4) DEFAULT 0.0000,
    reach_count BIGINT DEFAULT 0,
    impression_count BIGINT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    PRIMARY KEY (id, metric_date),
    CONSTRAINT unique_account_date UNIQUE (social_account_id, metric_date)
) PARTITION BY RANGE (metric_date);

-- Content dimension table
CREATE TABLE content_dimension (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    social_account_id UUID NOT NULL REFERENCES social_account(id) ON DELETE CASCADE,
    external_content_id VARCHAR(255) NOT NULL,
    content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('POST', 'STORY', 'REEL', 'VIDEO')),
    title TEXT,
    description TEXT,
    thumbnail_url TEXT,
    content_url TEXT,
    published_at TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT unique_account_content UNIQUE (social_account_id, external_content_id)
);

-- Content daily metrics (partitioned fact table)
CREATE TABLE content_daily_metrics (
    id UUID DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    content_id UUID NOT NULL REFERENCES content_dimension(id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    views_count BIGINT DEFAULT 0,
    likes_count BIGINT DEFAULT 0,
    shares_count BIGINT DEFAULT 0,
    comments_count BIGINT DEFAULT 0,
    engagement_rate DECIMAL(5,4) DEFAULT 0.0000,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    PRIMARY KEY (id, metric_date),
    CONSTRAINT unique_content_date UNIQUE (content_id, metric_date)
) PARTITION BY RANGE (metric_date);

-- =====================================================
-- REPORTING SYSTEM
-- =====================================================

-- Report templates
CREATE TABLE report_template (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    template_type VARCHAR(50) NOT NULL CHECK (template_type IN ('DAILY', 'WEEKLY', 'MONTHLY', 'CUSTOM')),
    config JSONB NOT NULL DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Generated reports
CREATE TABLE generated_report (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    template_id UUID REFERENCES report_template(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED')),
    file_url TEXT,
    file_size BIGINT,
    generated_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- User and authentication indexes
CREATE INDEX idx_users_company_id ON users(company_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_session_user_id ON session(user_id);
CREATE INDEX idx_session_expires_at ON session(expires_at);

-- Social account indexes
CREATE INDEX idx_social_account_company_id ON social_account(company_id);
CREATE INDEX idx_social_account_platform ON social_account(platform);
CREATE INDEX idx_social_account_status ON social_account(status);

-- Analytics indexes
CREATE INDEX idx_content_dimension_social_account_id ON content_dimension(social_account_id);
CREATE INDEX idx_content_dimension_published_at ON content_dimension(published_at);

-- Report indexes
CREATE INDEX idx_report_template_company_id ON report_template(company_id);
CREATE INDEX idx_generated_report_company_id ON generated_report(company_id);
CREATE INDEX idx_generated_report_status ON generated_report(status);
CREATE INDEX idx_generated_report_created_at ON generated_report(created_at);

-- =====================================================
-- CREATE PARTITIONS FOR FACT TABLES
-- =====================================================

-- Account metrics partitions (monthly)
CREATE TABLE account_daily_metrics_2025_01 PARTITION OF account_daily_metrics 
FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE account_daily_metrics_2025_02 PARTITION OF account_daily_metrics 
FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE TABLE account_daily_metrics_2025_03 PARTITION OF account_daily_metrics 
FOR VALUES FROM ('2025-03-01') TO ('2025-04-01');

-- Content metrics partitions (monthly)
CREATE TABLE content_daily_metrics_2025_01 PARTITION OF content_daily_metrics 
FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE content_daily_metrics_2025_02 PARTITION OF content_daily_metrics 
FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE TABLE content_daily_metrics_2025_03 PARTITION OF content_daily_metrics 
FOR VALUES FROM ('2025-03-01') TO ('2025-04-01');