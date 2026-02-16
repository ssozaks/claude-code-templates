# Database

## Purpose
Defines the database schemas, tables, indexes, triggers, and views used by the Claude Code Templates platform. The project uses two separate database providers: Supabase (PostgreSQL) for component download tracking and statistics, and Neon (PostgreSQL serverless) for Claude Code version monitoring, changelog storage, Discord notification logs, and CLI command usage analytics.

## Requirements

### REQ-DB-001: Claude Code Versions Table
The system MUST maintain a `claude_code_versions` table that stores all detected Claude Code releases with version number, publication timestamp, changelog content, NPM/GitHub URLs, and Discord notification status.

#### Scenario: New version record insertion
- WHEN a new Claude Code version is detected via NPM
- THEN a record is inserted with version (unique), published_at, changelog_content, npm_url, github_url
- AND discord_notified defaults to false
- AND created_at and updated_at are set automatically

#### Scenario: Version record update
- WHEN the version record is updated (e.g., marking as notified)
- THEN the updated_at column is automatically set to NOW() via trigger

**File:** `database/migrations/001_create_claude_code_versions.sql`

### REQ-DB-002: Claude Code Changes Table
The system MUST maintain a `claude_code_changes` table that stores individual changelog entries parsed from each version, with foreign key reference to the versions table, change type classification, description, and category.

#### Scenario: Change record creation
- WHEN changelog entries are parsed from a new version
- THEN each change is inserted with version_id, change_type (feature, fix, improvement, breaking, deprecation), description, and category

#### Scenario: Cascade deletion
- WHEN a version record is deleted from claude_code_versions
- THEN all associated change records are deleted via ON DELETE CASCADE

**File:** `database/migrations/001_create_claude_code_versions.sql`

### REQ-DB-003: Discord Notifications Log Table
The system MUST maintain a `discord_notifications_log` table that records every Discord webhook notification attempt with version reference, payload, response status, and error information.

#### Scenario: Successful notification logging
- WHEN a Discord notification is sent successfully
- THEN a log record is created with version_id, webhook_url, JSON payload, response_status, and sent_at timestamp

#### Scenario: Failed notification logging
- WHEN a Discord notification fails
- THEN a log record is created with error_message field populated

**File:** `database/migrations/001_create_claude_code_versions.sql`

### REQ-DB-004: Monitoring Metadata Table
The system MUST maintain a `monitoring_metadata` singleton table that tracks the last check timestamp, last version found, total check count, error count, and last error message for the version monitoring system.

#### Scenario: Metadata update after successful check
- WHEN a version check completes successfully
- THEN last_check_at is updated to NOW()
- AND last_version_found is updated with the detected version
- AND check_count is incremented

#### Scenario: Metadata update after failed check
- WHEN a version check encounters an error
- THEN error_count is incremented
- AND last_error is updated with the error message

**File:** `database/migrations/001_create_claude_code_versions.sql`

### REQ-DB-005: Command Usage Logs Table
The system MUST maintain a `command_usage_logs` table that records every CLI command execution with command name, CLI version, Node version, platform, architecture, session ID, and optional metadata (JSONB).

#### Scenario: Command execution logging
- WHEN a CLI command is executed and tracked
- THEN a record is inserted with all available client information
- AND the automatic trigger updates aggregate statistics

**File:** `database/migrations/002_create_command_usage_logs.sql`

### REQ-DB-006: Command Usage Statistics Table with Auto-Update Trigger
The system MUST maintain a `command_usage_stats` table with automatic aggregate updates via a PostgreSQL trigger function. On each new log insertion, the system SHALL upsert the stats table incrementing total_executions, updating last_execution, and recalculating unique_sessions.

#### Scenario: First execution of a command
- WHEN a command is executed for the first time
- THEN a new stats record is created with total_executions=1
- AND first_execution and last_execution are set to the execution timestamp

#### Scenario: Subsequent execution of a command
- WHEN a previously tracked command is executed again
- THEN total_executions is incremented by 1
- AND last_execution is updated to the new timestamp
- AND unique_sessions is recalculated from distinct session IDs

**File:** `database/migrations/002_create_command_usage_logs.sql`

### REQ-DB-007: Analytical Views for Command Usage
The system MUST provide database views for daily command usage breakdown, platform distribution, and popular commands in the last 30 days to support analytics queries.

#### Scenario: Daily usage query
- WHEN the daily_command_usage view is queried
- THEN it returns command_name, date, execution count, unique users, and platform count grouped by day

#### Scenario: Popular commands query
- WHEN the popular_commands_30d view is queried
- THEN it returns commands ordered by execution count within the last 30 days

**File:** `database/migrations/002_create_command_usage_logs.sql`

### REQ-DB-008: Component Downloads Table (Supabase)
The system MUST use a Supabase `component_downloads` table to store individual download events with component_type, component_name, component_path, category, user_agent, ip_address, country, cli_version, and timestamps.

#### Scenario: Download event recording
- WHEN a component is installed via the CLI
- THEN a download record is inserted to Supabase with all client metadata

**File:** `api/track-download-supabase.js`

### REQ-DB-009: Download Statistics Aggregation Table (Supabase)
The system MUST maintain a `download_stats` table in Supabase with upsert logic on the composite key (component_type, component_name) to track total_downloads and last_download timestamp.

#### Scenario: Stats aggregation upsert
- WHEN a new download is tracked
- THEN the download_stats table is upserted with updated totals
- AND the composite unique constraint on (component_type, component_name) prevents duplicates

**File:** `api/track-download-supabase.js`

### REQ-DB-010: Database Performance Indexes
The system MUST create appropriate indexes on frequently queried columns including version lookups, timestamp-based sorting, change type filtering, command name lookups, session ID filtering, and platform distribution queries.

#### Scenario: Index utilization for version lookup
- WHEN a query filters by version number
- THEN the idx_versions_version index is used for efficient lookup

#### Scenario: Index utilization for command analytics
- WHEN analytics queries aggregate by command_name and timestamp
- THEN the idx_command_logs_name and idx_command_logs_timestamp indexes optimize the query

**File:** `database/migrations/001_create_claude_code_versions.sql`, `database/migrations/002_create_command_usage_logs.sql`
