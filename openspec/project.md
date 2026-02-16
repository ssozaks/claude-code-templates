# Claude Code Templates - Architecture Overview

## Project Summary

Claude Code Templates is a comprehensive Node.js CLI tool and web platform that provides ready-to-use configurations for Anthropic's Claude Code. It includes a component management system (agents, commands, settings, hooks, MCPs, skills), a real-time analytics dashboard, a public website at aitmpl.com, and integrations with Discord, NPM, and GitHub.

## Architecture Layers

### 1. CLI Tool (`cli-tool/`)

The primary user-facing interface. A Node.js CLI application using Commander for argument parsing, Inquirer for interactive selection, and a modular architecture for component installation, analytics, and diagnostics.

**Entry point:** `cli-tool/bin/create-claude-config.js` -> `cli-tool/src/index.js`

**Key modules:**
- `src/index.js` - Main CLI logic, component installation, flag handling
- `src/analytics.js` - Analytics dashboard server (Express + WebSocket)
- `src/health-check.js` - System diagnostic tool
- `src/chats-mobile.js` - Mobile conversation monitor
- `src/plugin-dashboard.js` - Plugin management interface
- `src/skill-dashboard.js` - Skill browsing interface
- `src/tracking-service.js` - Download/usage tracking client
- `src/file-operations.js` - File system operations for installations
- `src/utils.js` - Shared utilities

### 2. Analytics Engine (`cli-tool/src/analytics/`)

Modular backend for real-time Claude Code session monitoring.

**Core modules:**
- `core/StateCalculator.js` - Conversation state detection
- `core/ProcessDetector.js` - Running process detection
- `core/ConversationAnalyzer.js` - JSONL message parsing
- `core/FileWatcher.js` - File system monitoring (chokidar)
- `core/SessionAnalyzer.js` - Session-level analysis with agent detection
- `core/AgentAnalyzer.js` - Agent team specific analysis

**Data layer:**
- `data/DataCache.js` - Multi-level caching (memory + disk)

**Notifications:**
- `notifications/WebSocketServer.js` - Real-time WebSocket broadcasting
- `notifications/NotificationManager.js` - Event-driven alert system

**Utilities:**
- `utils/PerformanceMonitor.js` - System health metrics

### 3. Analytics Dashboard Frontend (`cli-tool/src/analytics-web/`)

Vanilla JavaScript single-page application served by the analytics Express server.

**Components:**
- `components/App.js` - Application shell
- `components/DashboardPage.js` - Main dashboard layout
- `components/ConversationTable.js` - Session list
- `components/ActivityHeatmap.js` - Activity visualization
- `components/AgentAnalytics.js` - Agent metrics
- `components/SessionTimer.js` - Duration tracking
- `components/Charts.js` - Data visualization
- `components/HeaderComponent.js` - Navigation header
- `components/Sidebar.js` - Side navigation
- `components/ToolDisplay.js` - Tool usage display

**Services:**
- `services/StateService.js` - Reactive state management
- `services/DataService.js` - API communication with caching
- `services/WebSocketService.js` - WebSocket client management

### 4. Serverless API (`api/`)

Vercel serverless functions powering the platform backend.

**Endpoints:**
- `track-download-supabase.js` - POST `/api/track-download-supabase` (Supabase)
- `track-command-usage.js` - POST `/api/track-command-usage` (Neon)
- `claude-code-check.js` - GET `/api/claude-code-check` (cron, Neon + Discord)
- `discord/interactions.js` - POST `/api/discord/interactions` (Discord bot)
- `_parser-claude.js` - Changelog parsing utility (internal)

### 5. Public Website (`docs/`)

Static website served at aitmpl.com via Vercel.

**Pages:**
- `index.html` - Component browsing catalog
- `component.html` - Component detail page
- `plugin.html` - Plugin detail page
- `download-stats.html` - Download statistics
- `trending.html` - Trending components
- `workflows.html` - Workflow documentation
- `sandbox-interface.html` - Component sandbox
- `jobs.html` - Job board

**JavaScript modules:**
- `js/script.js` - Main application logic
- `js/search-functionality.js` - Search engine
- `js/data-loader.js` - Component catalog loader
- `js/stack-router.js` - Client-side routing
- `js/cart-manager.js` - Installation cart
- `js/component-page.js` - Component detail logic
- `js/modal-helpers.js` - Modal system
- `js/index-events.js` - Event handling
- `js/trending.js` - Trending data display

### 6. Component Library (`cli-tool/components/`)

Markdown-based component definitions organized by type:
- `agents/` - AI specialist configurations (25+ categories)
- `commands/` - Custom slash commands (20+ categories)
- `hooks/` - Automation triggers (10+ categories)
- `mcps/` - External integrations (12+ categories)
- `settings/` - Configuration presets (13+ categories)
- `skills/` - Reusable capabilities (11+ categories)

### 7. Database Layer

**Supabase (download tracking):**
- `component_downloads` - Individual download events
- `download_stats` - Aggregated download statistics

**Neon PostgreSQL (version monitoring + command usage):**
- `claude_code_versions` - Detected Claude Code releases
- `claude_code_changes` - Parsed changelog entries
- `discord_notifications_log` - Discord webhook logs
- `monitoring_metadata` - System monitoring state
- `command_usage_logs` - CLI command executions
- `command_usage_stats` - Aggregated command statistics
- Views: `daily_command_usage`, `platform_distribution`, `popular_commands_30d`

**Migrations:** `database/migrations/`

### 8. CI/CD and Deployment

**GitHub Actions (`.github/workflows/`):**
- `publish-package.yml` - npm/GitHub Packages publishing
- `component-security-validation.yml` - Security audit on PRs
- `discord-release-notification.yml` - Release notifications
- `update-json-data.yml` - Component catalog updates

**Vercel (`vercel.json`):**
- Static site deployment from `docs/`
- Serverless functions from `api/`
- Cron job: `/api/claude-code-check` every 30 minutes
- URL rewrites for SPA routing

### 9. Validation System (`cli-tool/src/validation/`)

Multi-layer component validation framework:
- `BaseValidator.js` - Abstract validator interface
- `ValidationOrchestrator.js` - Coordinates all validators
- `validators/StructuralValidator.js` - Format and structure checks
- `validators/SemanticValidator.js` - Content meaning validation
- `validators/IntegrityValidator.js` - Data integrity checks
- `validators/ProvenanceValidator.js` - Origin and attribution
- `validators/ReferenceValidator.js` - Cross-reference validation

### 10. Documentation (`docu/`)

Docusaurus-based documentation site (docs.aitmpl.com):
- `docs/` - Documentation content
- `src/` - Custom Docusaurus components
- `docusaurus.config.ts` - Site configuration

## Data Flow

```
User CLI Command
    |
    v
CLI Tool (index.js) --> Tracking API --> Supabase (downloads)
    |                                     Neon DB (commands)
    v
Component Installation
    |
    v
.claude/ directory (local project configuration)

Analytics Dashboard
    |
    v
FileWatcher --> ConversationAnalyzer --> StateCalculator
    |
    v
WebSocketServer --> Dashboard Frontend (StateService)
    |
    v
Real-time UI Updates

Cron Job (every 30min)
    |
    v
NPM Registry Check --> Changelog Parse --> Neon DB --> Discord Webhook
```

## Spec Categories

| Category | Prefix | Scope |
|----------|--------|-------|
| Frontend Components | REQ-FC | Analytics dashboard, plugin/skill dashboards |
| API Endpoints | REQ-AE | Vercel serverless functions |
| Database | REQ-DB | Supabase and Neon schemas, migrations |
| CI/CD | REQ-CC | GitHub Actions, Vercel deployment |
| Testing | REQ-TE | Jest, Playwright, shell scripts |
| Page Structure | REQ-PS | Public website pages at aitmpl.com |
| Interactive Behaviors | REQ-IB | WebSocket, file watching, CLI interaction |
| State Management | REQ-SM | Frontend services, backend caching |
