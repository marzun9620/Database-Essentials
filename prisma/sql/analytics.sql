-- Simple queries for 2 tables using Typed SQL
-- Demonstrates the dual database strategy with basic operations

-- Get company with user count
-- @param {String} $1:companyId
SELECT 
  c.name as company_name,
  c.slug,
  COUNT(u.id) as user_count
FROM practice_app.company c
LEFT JOIN practice_app.users u ON c.id = u.company_id
WHERE c.id = $1::uuid
GROUP BY c.id, c.name, c.slug;

-- Get users by company with role information
-- @param {String} $1:companyId
SELECT 
  u.first_name,
  u.last_name,
  u.email,
  u.status,
  ur.role
FROM practice_app.users u
LEFT JOIN practice_app.user_role ur ON u.id = ur.user_id AND ur.company_id = $1::uuid
WHERE u.company_id = $1::uuid
ORDER BY u.created_at DESC; 