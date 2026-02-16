# API Endpoints

## Purpose
Defines the Vercel serverless API endpoints that power the Claude Code Templates ecosystem. These endpoints handle component download tracking (Supabase), CLI command usage analytics (Neon Database), Discord bot interactions, and Claude Code version monitoring with automated Discord notifications. All endpoints are deployed on Vercel and serve the public aitmpl.com domain.

## Requirements

### REQ-AE-001: Component Download Tracking Endpoint
The system MUST provide a POST endpoint at `/api/track-download-supabase` that records component installations to Supabase, including component type, name, path, category, CLI version, IP address, and country.

#### Scenario: Successful download tracking
- WHEN a valid POST request with component type and name is received
- THEN the endpoint inserts a record into the `component_downloads` table
- AND upserts the `download_stats` aggregation table
- AND returns a 200 response with success status and timestamp

#### Scenario: Invalid component type
- WHEN a POST request with an invalid component type is received
- THEN the endpoint returns a 400 response with descriptive error message

#### Scenario: Missing required fields
- WHEN a POST request without component type or name is received
- THEN the endpoint returns a 400 response indicating required fields

**File:** `api/track-download-supabase.js`

### REQ-AE-002: CORS Support for All API Endpoints
The system MUST set CORS headers on all API responses allowing cross-origin requests, supporting OPTIONS preflight requests with appropriate Access-Control headers.

#### Scenario: Preflight CORS request
- WHEN an OPTIONS request is sent to any API endpoint
- THEN the endpoint returns 200 with Access-Control-Allow-Origin set to `*`
- AND Access-Control-Allow-Methods includes the supported methods
- AND Access-Control-Allow-Headers includes Content-Type and User-Agent

**File:** `api/track-download-supabase.js`, `api/track-command-usage.js`, `api/claude-code-check.js`

### REQ-AE-003: HTTP Method Validation
The system MUST reject requests with unsupported HTTP methods by returning a 405 Method Not Allowed response with an `allowed` field listing accepted methods.

#### Scenario: GET request to POST-only endpoint
- WHEN a GET request is sent to `/api/track-download-supabase`
- THEN the endpoint returns 405 with `{ error: "Method not allowed", allowed: ["POST"] }`

**File:** `api/track-download-supabase.js`, `api/track-command-usage.js`

### REQ-AE-004: CLI Command Usage Tracking Endpoint
The system MUST provide a POST endpoint at `/api/track-command-usage` that records CLI command executions to Neon Database, including command name, CLI version, Node version, platform, architecture, and session ID.

#### Scenario: Valid command tracking
- WHEN a valid POST request with a recognized command name is received
- THEN the endpoint inserts a record into `command_usage_logs`
- AND automatic database triggers update `command_usage_stats`
- AND returns 200 with success message and timestamp

#### Scenario: Unrecognized command name
- WHEN a POST request with an invalid command name is received
- THEN the endpoint returns 400 with "Invalid command name" error

**File:** `api/track-command-usage.js`

### REQ-AE-005: Claude Code Version Check and Discord Notification
The system MUST provide a GET endpoint at `/api/claude-code-check` that checks for new Claude Code releases from NPM, parses the changelog from GitHub, stores version data in Neon Database, and sends formatted Discord notifications.

#### Scenario: New version detected
- WHEN the cron job triggers and a new Claude Code version is found on NPM
- THEN the endpoint fetches the latest changelog from GitHub
- AND parses changes by category (features, fixes, improvements, breaking)
- AND inserts version and change records into the database
- AND sends a formatted Discord embed notification
- AND marks the version as notified

#### Scenario: Already processed version
- WHEN the cron job triggers but the latest version was already processed
- THEN the endpoint returns 200 with status "already_processed"
- AND updates the monitoring metadata timestamp
- AND does NOT send a duplicate Discord notification

#### Scenario: Changelog parse failure
- WHEN the version is not found in the changelog
- THEN the endpoint throws an error with descriptive message
- AND updates monitoring metadata with error count and message

**File:** `api/claude-code-check.js`, `api/_parser-claude.js`

### REQ-AE-006: Discord Bot Interactions Endpoint
The system MUST provide a POST endpoint at `/api/discord/interactions` that handles Discord slash commands including /search, /info, /install, /popular, and /random for component discovery.

#### Scenario: Discord slash command execution
- WHEN a verified Discord interaction request is received
- THEN the endpoint validates the Discord signature
- AND processes the slash command (search, info, install, popular, random)
- AND returns an appropriate Discord interaction response

**File:** `api/discord/interactions.js`

### REQ-AE-007: Component Type Validation
The system MUST validate component types against an allowed list: agent, command, setting, hook, mcp, skill, and template. The system MUST reject any type not in this list.

#### Scenario: Valid component type submission
- WHEN a download tracking request includes type "agent"
- THEN the validation passes and tracking proceeds

#### Scenario: Invalid component type submission
- WHEN a download tracking request includes type "unknown"
- THEN the validation fails with "Invalid component type" error

**File:** `api/track-download-supabase.js`

### REQ-AE-008: Vercel Cron Job Configuration
The system MUST configure a Vercel cron job that triggers the Claude Code version check endpoint every 30 minutes to monitor for new releases.

#### Scenario: Scheduled version check
- WHEN 30 minutes have elapsed since the last cron execution
- THEN Vercel triggers a GET request to `/api/claude-code-check`
- AND the endpoint performs its full check-and-notify cycle

**File:** `vercel.json`

### REQ-AE-009: Error Handling with Environment-Aware Details
The system MUST return generic error messages in production and detailed error information (including stack traces) only when NODE_ENV is set to "development".

#### Scenario: Production error response
- WHEN an internal error occurs in production
- THEN the endpoint returns 500 with a generic error message
- AND does NOT include error.message or stack trace details

#### Scenario: Development error response
- WHEN an internal error occurs in development mode
- THEN the endpoint returns 500 with the detailed error message

**File:** `api/track-download-supabase.js`, `api/track-command-usage.js`, `api/claude-code-check.js`
