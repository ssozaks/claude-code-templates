# Interactive Behaviors

## Purpose
Defines the real-time communication, interactive features, and dynamic behavior patterns used across the Claude Code Templates ecosystem. This includes WebSocket-based live updates for the analytics dashboard, file system watching for conversation monitoring, browser notifications, data export capabilities, CLI interactive mode, and the component installation cart system on the website.

## Requirements

### REQ-IB-001: WebSocket Server for Real-Time Analytics
The system MUST provide a WebSocket server that broadcasts real-time conversation state updates, session metrics, and system health data to connected analytics dashboard clients.

#### Scenario: Client connection and data streaming
- WHEN a dashboard client connects via WebSocket
- THEN the server establishes a persistent connection
- AND begins streaming conversation state updates in real-time
- AND sends system health metrics at regular intervals

#### Scenario: Connection recovery
- WHEN a WebSocket connection drops
- THEN the client falls back to HTTP polling
- AND automatically attempts to re-establish the WebSocket connection

**File:** `cli-tool/src/analytics/notifications/WebSocketServer.js`

### REQ-IB-002: Notification Manager for Event-Driven Alerts
The system MUST provide a notification manager that dispatches event-driven notifications for conversation state changes, including new sessions, state transitions, and error conditions.

#### Scenario: State change notification
- WHEN a Claude Code conversation transitions state (e.g., from "working" to "awaiting input")
- THEN the NotificationManager emits a state change event
- AND connected clients receive the notification in real-time

#### Scenario: Browser desktop notification
- WHEN a significant state change occurs and the dashboard is not in focus
- THEN a browser desktop notification is triggered (if permissions are granted)

**File:** `cli-tool/src/analytics/notifications/NotificationManager.js`

### REQ-IB-003: File System Watching for Conversation Detection
The system MUST use the chokidar file watcher to monitor Claude Code conversation directories for file changes, enabling real-time conversation state detection without polling.

#### Scenario: New conversation file detected
- WHEN a new JSONL conversation file appears in the watched directory
- THEN the FileWatcher emits an event with the file path
- AND the ConversationAnalyzer begins parsing the new conversation

#### Scenario: Conversation file modification
- WHEN an existing conversation file is modified (new messages appended)
- THEN the FileWatcher triggers an incremental re-analysis
- AND only the new content is parsed for efficiency

**File:** `cli-tool/src/analytics/core/FileWatcher.js`

### REQ-IB-004: Process Detection for Session Correlation
The system SHALL detect running Claude Code processes on the system to correlate file-based conversation data with active terminal sessions.

#### Scenario: Active process detection
- WHEN the analytics system performs a process scan
- THEN it identifies running Claude Code processes
- AND correlates them with conversation file timestamps
- AND updates session status based on process liveness

**File:** `cli-tool/src/analytics/core/ProcessDetector.js`

### REQ-IB-005: Interactive CLI Component Installation
The system MUST provide an interactive CLI mode using inquirer that guides users through component selection, category browsing, and batch installation with visual progress indicators.

#### Scenario: Interactive mode launch
- WHEN the CLI is launched without specific flags (just `npx claude-code-templates@latest`)
- THEN an interactive menu appears with component categories
- AND users can browse, search, and select components
- AND selected components are installed with progress spinners (ora)

#### Scenario: Batch installation with flags
- WHEN multiple component flags are provided (--agent X --command Y --setting Z)
- THEN all specified components are installed sequentially
- AND each installation is tracked via the download tracking API
- AND results are summarized in a formatted terminal output (boxen)

**File:** `cli-tool/src/index.js`, `cli-tool/bin/create-claude-config.js`

### REQ-IB-006: Component Installation Cart System
The system SHALL provide a shopping cart interface on the website that allows users to add multiple components to a cart and generate a single batch installation command.

#### Scenario: Cart-based multi-component install
- WHEN a user adds components to the cart on aitmpl.com
- THEN the cart UI shows selected components with count
- AND generates a combined npx installation command
- AND provides a one-click copy-to-clipboard action

**File:** `docs/js/cart-manager.js`

### REQ-IB-007: Data Export Capabilities
The system SHALL provide CSV and JSON export functionality for conversation data and analytics metrics from the dashboard.

#### Scenario: CSV data export
- WHEN a user clicks the export button on the analytics dashboard
- THEN conversation data is serialized to CSV format
- AND a download is triggered in the browser

**File:** `cli-tool/src/analytics-web/components/DashboardPage.js`

### REQ-IB-008: Conversation State Detection Logic
The system MUST implement conversation state detection that classifies sessions as "Claude working", "User typing", "Awaiting input", or "Idle" based on file modification timestamps and message content analysis.

#### Scenario: Active session state detection
- WHEN a conversation file was modified within the last 30 seconds
- THEN the StateCalculator classifies the session as "active"
- AND determines the specific sub-state based on the last message type

#### Scenario: Idle session detection
- WHEN a conversation file has not been modified for over 5 minutes
- THEN the StateCalculator classifies the session as "idle"

**File:** `cli-tool/src/analytics/core/StateCalculator.js`

### REQ-IB-009: Conversation Content Analysis
The system MUST parse and analyze JSONL conversation files to extract message counts, tool usage patterns, conversation duration, and content summaries.

#### Scenario: Conversation file parsing
- WHEN a conversation JSONL file is loaded
- THEN the ConversationAnalyzer parses each line as a message
- AND extracts message type, timestamp, tool calls, and content
- AND calculates aggregate metrics (message count, duration, tool usage)

**File:** `cli-tool/src/analytics/core/ConversationAnalyzer.js`

### REQ-IB-010: Session Analysis with Agent Team Detection
The system SHALL analyze Claude Code sessions to detect agent team configurations, teammate spawns, task completion events, and multi-agent coordination patterns.

#### Scenario: Agent team session detection
- WHEN a session involves agent team operations
- THEN the SessionAnalyzer identifies the team lead and teammates
- AND tracks task assignments and completion status
- AND reports agent-specific metrics

**File:** `cli-tool/src/analytics/core/SessionAnalyzer.js`

### REQ-IB-011: Mobile Conversation Monitor Interface
The system SHALL provide a mobile-optimized web interface for remotely monitoring Claude Code conversations with real-time updates and optional secure remote access via Cloudflare Tunnel.

#### Scenario: Mobile conversation monitoring
- WHEN the user launches with `--chats` flag
- THEN a mobile-optimized HTML page is served
- AND conversations are displayed with real-time updates
- AND the interface is responsive for small screens

#### Scenario: Remote access via tunnel
- WHEN the user launches with `--chats --tunnel` flags
- THEN a Cloudflare Tunnel is established for secure remote access
- AND a public URL is provided for accessing the monitor remotely

**File:** `cli-tool/src/chats-mobile.js`, `cli-tool/src/analytics-web/chats_mobile.html`

### REQ-IB-012: Health Check Diagnostic System
The system SHALL provide a comprehensive health check tool that analyzes the user's Claude Code installation, configuration, and system compatibility.

#### Scenario: Health check execution
- WHEN the user runs with `--health-check` flag
- THEN the system checks Claude Code installation status
- AND validates configuration files and environment
- AND reports issues and recommendations

**File:** `cli-tool/src/health-check.js`

### REQ-IB-013: Modal Helper System for Website
The system SHALL provide a reusable modal system for the website that handles component details, installation instructions, and confirmation dialogs.

#### Scenario: Component detail modal display
- WHEN a user clicks on a component card
- THEN a modal opens with full component details
- AND shows the installation command with copy button
- AND provides related component suggestions

**File:** `docs/js/modal-helpers.js`

### REQ-IB-014: Event Handling System for Index Page
The system MUST provide comprehensive event handling for the main index page including scroll behavior, tab switching, card interactions, search input, and keyboard shortcuts.

#### Scenario: Index page event initialization
- WHEN the main page loads
- THEN all event listeners are registered for UI interactions
- AND carousel, search, tabs, and modal events are active

**File:** `docs/js/index-events.js`
