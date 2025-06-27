-- Practice Database Seed Data
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

-- =====================================================
-- PERMISSIONS
-- =====================================================

INSERT INTO permission (id, name, description, resource, action) VALUES
    ('850e8400-e29b-41d4-a716-446655440001', 'manage_users', 'Manage company users', 'users', 'manage'),
    ('850e8400-e29b-41d4-a716-446655440002', 'view_analytics', 'View analytics dashboards', 'analytics', 'read'),
    ('850e8400-e29b-41d4-a716-446655440003', 'manage_accounts', 'Manage social accounts', 'social_accounts', 'manage'),
    ('850e8400-e29b-41d4-a716-446655440004', 'generate_reports', 'Generate and export reports', 'reports', 'create'),
    ('850e8400-e29b-41d4-a716-446655440005', 'view_reports', 'View existing reports', 'reports', 'read');

-- =====================================================
-- ROLE PERMISSIONS
-- =====================================================

INSERT INTO role_permission (id, role, permission_id) VALUES
    -- OWNER permissions (all)
    ('950e8400-e29b-41d4-a716-446655440001', 'OWNER', '850e8400-e29b-41d4-a716-446655440001'),
    ('950e8400-e29b-41d4-a716-446655440002', 'OWNER', '850e8400-e29b-41d4-a716-446655440002'),
    ('950e8400-e29b-41d4-a716-446655440003', 'OWNER', '850e8400-e29b-41d4-a716-446655440003'),
    ('950e8400-e29b-41d4-a716-446655440004', 'OWNER', '850e8400-e29b-41d4-a716-446655440004'),
    ('950e8400-e29b-41d4-a716-446655440005', 'OWNER', '850e8400-e29b-41d4-a716-446655440005'),
    
    -- ADMIN permissions (most)
    ('950e8400-e29b-41d4-a716-446655440006', 'ADMIN', '850e8400-e29b-41d4-a716-446655440002'),
    ('950e8400-e29b-41d4-a716-446655440007', 'ADMIN', '850e8400-e29b-41d4-a716-446655440003'),
    ('950e8400-e29b-41d4-a716-446655440008', 'ADMIN', '850e8400-e29b-41d4-a716-446655440004'),
    ('950e8400-e29b-41d4-a716-446655440009', 'ADMIN', '850e8400-e29b-41d4-a716-446655440005'),
    
    -- MEMBER permissions (basic)
    ('950e8400-e29b-41d4-a716-446655440010', 'MEMBER', '850e8400-e29b-41d4-a716-446655440002'),
    ('950e8400-e29b-41d4-a716-446655440011', 'MEMBER', '850e8400-e29b-41d4-a716-446655440005'),
    
    -- VIEWER permissions (read-only)
    ('950e8400-e29b-41d4-a716-446655440012', 'VIEWER', '850e8400-e29b-41d4-a716-446655440002'),
    ('950e8400-e29b-41d4-a716-446655440013', 'VIEWER', '850e8400-e29b-41d4-a716-446655440005');

-- =====================================================
-- SOCIAL ACCOUNTS
-- =====================================================

INSERT INTO social_account (id, company_id, platform, external_id, username, display_name, avatar_url, status, metadata) VALUES
    -- Acme Social Media accounts
    ('a50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'TIKTOK', 'tiktok_123456', '@acme_social', 'Acme Social Media', 'https://example.com/avatar1.jpg', 'ACTIVE', '{"verified": true, "follower_count": 15000}'),
    ('a50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'INSTAGRAM', 'insta_789012', '@acme_social_ig', 'Acme Social IG', 'https://example.com/avatar2.jpg', 'ACTIVE', '{"verified": false, "follower_count": 8500}'),
    ('a50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 'YOUTUBE', 'yt_345678', 'AcmeSocialTV', 'Acme Social TV', 'https://example.com/avatar3.jpg', 'ACTIVE', '{"subscriber_count": 2500}'),
    
    -- Brand Masters Co accounts
    ('a50e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'TIKTOK', 'tiktok_987654', '@brandmasters', 'Brand Masters', 'https://example.com/avatar4.jpg', 'ACTIVE', '{"verified": true, "follower_count": 45000}'),
    ('a50e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440002', 'FACEBOOK', 'fb_567890', 'BrandMastersOfficial', 'Brand Masters Official', 'https://example.com/avatar5.jpg', 'ACTIVE', '{"page_likes": 12000}'),
    
    -- Creative Agency Ltd accounts
    ('a50e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'INSTAGRAM', 'insta_234567', '@creative_agency', 'Creative Agency', 'https://example.com/avatar6.jpg', 'ACTIVE', '{"verified": false, "follower_count": 3200}');

-- =====================================================
-- CONTENT DIMENSION DATA
-- =====================================================

INSERT INTO content_dimension (id, social_account_id, external_content_id, content_type, title, description, thumbnail_url, content_url, published_at, metadata) VALUES
    -- Acme Social Media TikTok content
    ('b50e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', 'tt_video_001', 'VIDEO', '5 Marketing Tips for Small Business', 'Learn the top 5 marketing strategies that work for small businesses in 2025', 'https://example.com/thumb1.jpg', 'https://tiktok.com/@acme_social/video/001', '2025-01-15 10:30:00+00', '{"duration": 58, "hashtags": ["#marketing", "#smallbusiness", "#tips"]}'),
    ('b50e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440001', 'tt_video_002', 'VIDEO', 'Behind the Scenes: Our Office', 'Take a peek behind the scenes at Acme Social Media office', 'https://example.com/thumb2.jpg', 'https://tiktok.com/@acme_social/video/002', '2025-01-20 14:15:00+00', '{"duration": 45, "hashtags": ["#bts", "#office", "#team"]}'),
    
    -- Brand Masters TikTok content
    ('b50e8400-e29b-41d4-a716-446655440003', 'a50e8400-e29b-41d4-a716-446655440004', 'tt_video_003', 'VIDEO', 'Brand Strategy Masterclass', 'Complete guide to building a strong brand strategy', 'https://example.com/thumb3.jpg', 'https://tiktok.com/@brandmasters/video/003', '2025-01-18 16:45:00+00', '{"duration": 120, "hashtags": ["#branding", "#strategy", "#masterclass"]}'),
    
    -- Instagram posts
    ('b50e8400-e29b-41d4-a716-446655440004', 'a50e8400-e29b-41d4-a716-446655440002', 'ig_post_001', 'POST', 'Monday Motivation', 'Start your week with positive energy! 💪', 'https://example.com/thumb4.jpg', 'https://instagram.com/p/abc123', '2025-01-22 09:00:00+00', '{"likes": 340, "comments": 28}'),
    ('b50e8400-e29b-41d4-a716-446655440005', 'a50e8400-e29b-41d4-a716-446655440006', 'ig_post_002', 'POST', 'Creative Process', 'How we bring ideas to life ✨', 'https://example.com/thumb5.jpg', 'https://instagram.com/p/def456', '2025-01-25 12:30:00+00', '{"likes": 189, "comments": 15}');

-- =====================================================
-- REPORT TEMPLATES
-- =====================================================

INSERT INTO report_template (id, company_id, name, description, template_type, config, is_active) VALUES
    ('c50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Weekly Performance Report', 'Weekly summary of all social media performance metrics', 'WEEKLY', '{"metrics": ["followers", "engagement", "reach"], "platforms": ["TIKTOK", "INSTAGRAM"]}', true),
    ('c50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'Monthly Brand Analysis', 'Comprehensive monthly analysis of brand performance across platforms', 'MONTHLY', '{"metrics": ["engagement_rate", "reach", "brand_mentions"], "include_competitor_analysis": true}', true),
    ('c50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'Daily Metrics Dashboard', 'Daily snapshot of key performance indicators', 'DAILY', '{"metrics": ["views", "likes", "shares"], "auto_export": true}', true);

-- =====================================================
-- SAMPLE METRICS DATA
-- =====================================================

-- Account daily metrics for January 2025
INSERT INTO account_daily_metrics (company_id, social_account_id, metric_date, followers_count, following_count, posts_count, engagement_rate, reach_count, impression_count) VALUES
    -- Acme Social Media TikTok - January 2025
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-15', 15000, 2500, 150, 0.0850, 45000, 120000),
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-16', 15050, 2500, 151, 0.0892, 48000, 125000),
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-17', 15120, 2500, 151, 0.0875, 46500, 118000),
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-18', 15200, 2500, 151, 0.0901, 52000, 135000),
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-19', 15350, 2500, 152, 0.0945, 58000, 145000),
    ('550e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '2025-01-20', 15450, 2500, 153, 0.0920, 55000, 140000),
    
    -- Brand Masters TikTok - January 2025
    ('550e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440004', '2025-01-15', 45000, 1200, 320, 0.1250, 135000, 450000),
    ('550e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440004', '2025-01-16', 45200, 1200, 320, 0.1180, 128000, 425000),
    ('550e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440004', '2025-01-17', 45400, 1200, 320, 0.1220, 142000, 465000),
    ('550e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440004', '2025-01-18', 45850, 1200, 321, 0.1350, 165000, 520000),
    ('550e8400-e29b-41d4-a716-446655440002', 'a50e8400-e29b-41d4-a716-446655440004', '2025-01-19', 46100, 1200, 321, 0.1280, 158000, 485000);

-- Content daily metrics for January 2025
INSERT INTO content_daily_metrics (company_id, content_id, metric_date, views_count, likes_count, shares_count, comments_count, engagement_rate) VALUES
    -- Acme Social Media content
    ('550e8400-e29b-41d4-a716-446655440001', 'b50e8400-e29b-41d4-a716-446655440001', '2025-01-15', 12500, 890, 45, 120, 0.0844),
    ('550e8400-e29b-41d4-a716-446655440001', 'b50e8400-e29b-41d4-a716-446655440001', '2025-01-16', 15200, 1050, 58, 145, 0.0822),
    ('550e8400-e29b-41d4-a716-446655440001', 'b50e8400-e29b-41d4-a716-446655440001', '2025-01-17', 18900, 1200, 72, 168, 0.0762),
    
    ('550e8400-e29b-41d4-a716-446655440001', 'b50e8400-e29b-41d4-a716-446655440002', '2025-01-20', 8500, 520, 28, 85, 0.0745),
    ('550e8400-e29b-41d4-a716-446655440001', 'b50e8400-e29b-41d4-a716-446655440002', '2025-01-21', 11200, 685, 35, 112, 0.0741),
    
    -- Brand Masters content
    ('550e8400-e29b-41d4-a716-446655440002', 'b50e8400-e29b-41d4-a716-446655440003', '2025-01-18', 45000, 5200, 320, 650, 0.1371),
    ('550e8400-e29b-41d4-a716-446655440002', 'b50e8400-e29b-41d4-a716-446655440003', '2025-01-19', 52000, 6100, 380, 750, 0.1390),
    ('550e8400-e29b-41d4-a716-446655440002', 'b50e8400-e29b-41d4-a716-446655440003', '2025-01-20', 58500, 6800, 425, 820, 0.1402);

-- =====================================================
-- GENERATED REPORTS
-- =====================================================

INSERT INTO generated_report (id, company_id, template_id, title, report_type, period_start, period_end, status, file_url, file_size, generated_by) VALUES
    ('d50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'c50e8400-e29b-41d4-a716-446655440001', 'Weekly Performance Report - Week 3, Jan 2025', 'WEEKLY', '2025-01-15', '2025-01-21', 'COMPLETED', 'https://storage.googleapis.com/reports/weekly_20250122.pdf', 2048576, '650e8400-e29b-41d4-a716-446655440001'),
    ('d50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'c50e8400-e29b-41d4-a716-446655440002', 'Monthly Brand Analysis - January 2025', 'MONTHLY', '2025-01-01', '2025-01-31', 'PROCESSING', NULL, NULL, '650e8400-e29b-41d4-a716-446655440004'),
    ('d50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'c50e8400-e29b-41d4-a716-446655440003', 'Daily Metrics - Jan 25, 2025', 'DAILY', '2025-01-25', '2025-01-25', 'COMPLETED', 'https://storage.googleapis.com/reports/daily_20250125.csv', 51200, '650e8400-e29b-41d4-a716-446655440006');

-- Update timestamps to current
UPDATE company SET updated_at = NOW();
UPDATE users SET updated_at = NOW();
UPDATE social_account SET updated_at = NOW();
UPDATE content_dimension SET updated_at = NOW();
UPDATE report_template SET updated_at = NOW();
UPDATE generated_report SET updated_at = NOW();