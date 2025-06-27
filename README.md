# Practice Database Setup

A complete database setup practice environment based on the Kachi-Kaku codebase patterns.

## Features

- **PostgreSQL 15.4** with Docker
- **Atlas CLI** for schema-first migrations
- **Comprehensive Taskfile** for database operations
- **Multi-tenant architecture** with company-based data isolation
- **Analytics-optimized schema** with partitioned fact tables
- **Role-based access control** system
- **Social media integration** patterns

## Quick Start

```bash
# Complete setup (starts database, applies schema, seeds data)
task dev:setup

# Check status
task dev:status

# Access database shell
task db:shell

# View in browser (Adminer)
open http://localhost:28080
```

## Database Access

- **Database URL**: `postgres://root:root@localhost:25433/practice`
- **Schema**: `practice_app`
- **Adminer**: http://localhost:28080 (server: `postgres`, user: `root`, password: `root`, database: `practice`)

## Available Commands

### Infrastructure

- `task up` - Start database and services
- `task down` - Stop all services
- `task restart` - Restart services
- `task clean` - Remove all data and containers

### Schema Management

- `task migrate:apply` - Apply schema changes
- `task schema:clean` - Reset database schema
- `task schema:inspect` - Inspect current schema

### Database Operations

- `task db:shell` - PostgreSQL shell access
- `task db:seed` - Load test data
- `task db:reset` - Complete database reset

### Development

- `task dev:setup` - Complete development setup
- `task test:connection` - Test database connection
- `task test:schema` - Run basic schema tests

## Schema Overview

### Core Tables

- `company` - Multi-tenant company structure
- `users` - User management with RBAC
- `user_role` - Role assignments (OWNER, ADMIN, MEMBER, VIEWER)
- `permission` & `role_permission` - Permission system

### Social Media Integration

- `social_account` - Platform accounts (TikTok, Instagram, YouTube, Facebook)
- `social_token` - OAuth token management
- `content_dimension` - Content metadata

### Analytics (Partitioned Tables)

- `account_daily_metrics` - Daily account performance metrics
- `content_daily_metrics` - Daily content performance metrics

### Reporting System

- `report_template` - Report configuration templates
- `generated_report` - Report generation tracking

## Sample Data

The seed data includes:

- 3 sample companies
- 6 users with different roles
- 6 social media accounts across platforms
- Sample content and metrics data
- Report templates and generated reports

## Practice Exercises

1. **Schema Changes**: Modify `database/schema/schema.sql` and apply with `task migrate:apply`
2. **Data Queries**: Use `task db:shell` to run analytics queries
3. **Partitioning**: Add new monthly partitions for metrics tables
4. **Indexing**: Add performance indexes for specific query patterns
5. **RBAC**: Extend the permission system with new roles and permissions

## File Structure

```
practice-db/
├── atlas.hcl                 # Atlas configuration
├── docker-compose.yml        # PostgreSQL + Adminer setup
├── Taskfile.yml             # Database commands
├── database/
│   ├── init/                # Database initialization scripts
│   ├── schema/schema.sql    # Main schema definition
│   ├── fixtures/seed.sql    # Sample data
│   └── migrations/          # Generated migrations (auto-created)
└── README.md               # This file
```

## Next Steps

This practice environment is perfect for:

- Learning Atlas CLI migrations
- Understanding multi-tenant database design
- Practicing analytics table partitioning
- Experimenting with RBAC patterns
- Testing database performance optimizations

Customize the schema and data to match your specific learning goals!
