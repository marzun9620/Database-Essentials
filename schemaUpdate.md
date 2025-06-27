# Database Schema Update Guide

## Overview

This guide explains how to update your database schema using Atlas migrations and the dual database strategy (Atlas + Prisma).

## Quick Reference

```bash
# Complete workflow for schema changes
task migrate:diff      # Generate migration from schema changes
task migrate:apply     # Apply migration to database
task prisma:pull:gen   # Update Prisma client (dual strategy)
```

## Schema Update Workflow

### 1. Edit Schema Files

Edit your schema definition in `database/schema/schema.sql`:

```sql
-- Example: Add a new column to users table
ALTER TABLE practice_app.users ADD COLUMN phone VARCHAR(20);

-- Example: Create a new table
CREATE TABLE practice_app.notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES practice_app.users(id),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Generate Migration

Create a migration file from your schema changes:

```bash
task migrate:diff
```

This command:

- Compares your current schema with the database
- Generates a migration file in `database/migrations/`
- Shows you what changes will be made

### 3. Review Migration

Check the generated migration file:

```bash
ls -la database/migrations/
cat database/migrations/YYYYMMDDHHMMSS_migration_name.sql
```

### 4. Apply Migration

Apply the migration to your database:

```bash
# Apply with auto-approval (development)
task migrate:apply

# Apply with confirmation (safer, shows what will be applied)
task migrate:apply:confirm
```

### 5. Update Prisma (Dual Strategy)

If using the dual database strategy, update Prisma client:

```bash
task prisma:pull:gen
```

This:

- Pulls the updated schema from database
- Generates new Prisma client
- Updates TypeScript types

## Available Commands

### Schema Management

| Command                      | Description                                   |
| ---------------------------- | --------------------------------------------- |
| `task migrate:diff`          | Generate migration from schema changes        |
| `task migrate:apply`         | Apply migrations to database                  |
| `task migrate:apply:confirm` | Apply with confirmation                       |
| `task migrate:status`        | Show migration status                         |
| `task schema:inspect`        | Inspect current database schema               |
| `task schema:validate`       | Validate schema file                          |
| `task schema:clean`          | Reset database schema (WARNING: deletes data) |

### Development Workflow

| Command               | Description                               |
| --------------------- | ----------------------------------------- |
| `task db:reset`       | Complete database reset with fresh schema |
| `task dev:setup`      | Setup development environment             |
| `task dev:setup:dual` | Setup with dual database strategy         |
| `task test:schema`    | Test schema with basic queries            |

### Prisma Integration (Dual Strategy)

| Command                | Description                            |
| ---------------------- | -------------------------------------- |
| `task prisma:pull:gen` | Pull schema and generate Prisma client |
| `task prisma:studio`   | Open Prisma Studio                     |
| `task sql:generate`    | Generate typed SQL functions           |

## Environment-Specific Workflows

### Local Development

```bash
# Quick schema update
task migrate:diff
task migrate:apply
task prisma:pull:gen

# Complete reset (if needed)
task db:reset
```

### Staging Environment

```bash
# Use staging environment
task env:staging migrate:diff
task env:staging migrate:apply:confirm
```

### Production Environment

```bash
# Use production environment (with extra caution)
task env:production migrate:diff
task env:production migrate:apply:confirm
```

## Best Practices

### 1. Always Review Migrations

```bash
# Never apply migrations blindly
task migrate:apply:confirm
```

### 2. Test Schema Changes

```bash
# Test your changes
task test:schema
```

### 3. Backup Before Major Changes

```bash
# For production, always backup first
pg_dump your_database > backup.sql
```

### 4. Use Descriptive Migration Names

Atlas automatically names migrations, but you can add comments:

```sql
-- Migration: Add user phone numbers
ALTER TABLE practice_app.users ADD COLUMN phone VARCHAR(20);
```

### 5. Validate Schema

```bash
# Validate before applying
task schema:validate
```

## Common Scenarios

### Adding a New Table

1. Edit `database/schema/schema.sql`:

```sql
CREATE TABLE practice_app.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

2. Generate and apply:

```bash
task migrate:diff
task migrate:apply
task prisma:pull:gen
```

### Adding a Column

1. Edit schema:

```sql
ALTER TABLE practice_app.users ADD COLUMN email VARCHAR(255);
```

2. Apply changes:

```bash
task migrate:diff
task migrate:apply
task prisma:pull:gen
```

### Modifying Existing Data

1. Edit schema:

```sql
-- Add column with default value
ALTER TABLE practice_app.users ADD COLUMN status VARCHAR(20) DEFAULT 'active';

-- Update existing data
UPDATE practice_app.users SET status = 'active' WHERE status IS NULL;
```

2. Apply:

```bash
task migrate:diff
task migrate:apply
```

## Troubleshooting

### Migration Conflicts

If you get migration conflicts:

```bash
# Check current status
task migrate:status

# Clean and reapply (WARNING: deletes data)
task schema:clean
task migrate:apply
```

### Schema Validation Errors

```bash
# Validate schema
task schema:validate

# Check current database state
task schema:inspect
```

### Prisma Sync Issues

```bash
# Regenerate Prisma client
task prisma:pull:gen

# Check Prisma schema
cat prisma/schema.prisma
```

## File Structure

```
database/
├── schema/
│   └── schema.sql          # Your schema definition
├── migrations/             # Generated migration files
│   └── YYYYMMDDHHMMSS_*.sql
└── fixtures/
    └── seed-simple.sql     # Seed data

prisma/
├── schema.prisma           # Generated from database
└── sql/                    # Typed SQL queries
    └── analytics.sql
```

## Security Notes

- Never commit `.env.production` or `.env.staging` files
- Use `task migrate:apply:confirm` in production
- Always backup before major schema changes
- Test migrations in staging before production

## Quick Commands Reference

```bash
# Schema update workflow
task migrate:diff && task migrate:apply && task prisma:pull:gen

# Development setup
task dev:setup:dual

# Database access
task db:shell

# Status check
task migrate:status
task dev:status
```
