# Frontend Components

## Purpose
Defines the frontend UI components used across the Claude Code Templates project, including the analytics dashboard, plugin dashboard, skill dashboard, conversation monitor, and the public-facing website (aitmpl.com). Components are built with vanilla JavaScript (no framework) for maximum compatibility, using a modular architecture with services and reusable UI elements.

## Requirements

### REQ-FC-001: Analytics Dashboard Application Shell
The system SHALL provide a single-page analytics dashboard application (App.js) that orchestrates all dashboard sub-components including header, sidebar, conversation table, charts, session timer, and agent analytics.

#### Scenario: Dashboard initialization
- WHEN the analytics dashboard is loaded at http://localhost:3333
- THEN the App component initializes all sub-components
- AND renders the header, sidebar, and main content area
- AND establishes WebSocket connection for real-time data

**File:** `cli-tool/src/analytics-web/components/App.js`

### REQ-FC-002: Conversation Table Component
The system SHALL provide an interactive conversation table that displays active Claude Code sessions with state indicators, timestamps, and action controls.

#### Scenario: Conversation list rendering
- WHEN conversation data is received from the backend
- THEN the ConversationTable component renders each conversation row
- AND displays conversation state (active, idle, awaiting input)
- AND provides sorting and filtering capabilities

**File:** `cli-tool/src/analytics-web/components/ConversationTable.js`

### REQ-FC-003: Activity Heatmap Visualization
The system SHALL provide a heatmap component that visualizes Claude Code session activity over time using color-coded intensity levels.

#### Scenario: Heatmap data display
- WHEN session activity data is available
- THEN the ActivityHeatmap renders a time-based grid
- AND applies color intensity based on activity frequency
- AND supports hover interactions to show detailed metrics

**File:** `cli-tool/src/analytics-web/components/ActivityHeatmap.js`

### REQ-FC-004: Agent Analytics Component
The system SHALL provide an analytics component specifically for monitoring AI agent team activity, including spawn counts, task completion, and performance metrics.

#### Scenario: Agent metrics display
- WHEN agent team data is detected from active sessions
- THEN the AgentAnalytics component displays agent-specific metrics
- AND shows teammate activity, task distribution, and completion rates

**File:** `cli-tool/src/analytics-web/components/AgentAnalytics.js`

### REQ-FC-005: Session Timer Component
The system SHALL provide a session timer that tracks and displays the duration of active Claude Code sessions with visual indicators for session health.

#### Scenario: Active session timing
- WHEN a Claude Code session is active
- THEN the SessionTimer displays elapsed time
- AND updates in real-time without page refresh
- AND provides visual cues for long-running sessions

**File:** `cli-tool/src/analytics-web/components/SessionTimer.js`

### REQ-FC-006: Dashboard Page Component
The system MUST provide the main dashboard page layout component that composes all analytics sub-components into a cohesive monitoring interface with responsive design.

#### Scenario: Full dashboard render
- WHEN a user navigates to the analytics dashboard root
- THEN the DashboardPage renders all analytics widgets
- AND arranges them in a responsive grid layout
- AND handles loading and error states gracefully

**File:** `cli-tool/src/analytics-web/components/DashboardPage.js`

### REQ-FC-007: Tool Display Component
The system SHALL provide a component for displaying tool usage data and patterns within Claude Code sessions, including tool call frequencies and execution times.

#### Scenario: Tool usage visualization
- WHEN tool call data is available from conversation analysis
- THEN the ToolDisplay component renders tool usage metrics
- AND categorizes tools by type (file operations, search, web, etc.)

**File:** `cli-tool/src/analytics-web/components/ToolDisplay.js`

### REQ-FC-008: Plugin Dashboard Web Interface
The system SHALL provide a standalone web interface for browsing, managing, and configuring Claude Code plugins with marketplace browsing and permission management.

#### Scenario: Plugin browsing and management
- WHEN the user launches the plugin dashboard via `--plugins` flag
- THEN the plugin dashboard renders marketplace view
- AND shows installed plugins with their status
- AND provides plugin permission configuration controls

**File:** `cli-tool/src/plugin-dashboard-web/index.html`, `cli-tool/src/plugin-dashboard-web/app.js`

### REQ-FC-009: Skill Dashboard Web Interface
The system SHALL provide a web interface for browsing and managing Claude Code skills with category filtering and progressive disclosure.

#### Scenario: Skill browsing and installation
- WHEN the user launches the skill dashboard
- THEN the skill dashboard renders available skills
- AND supports category filtering and search
- AND provides installation command generation

**File:** `cli-tool/src/skill-dashboard-web/index.html`, `cli-tool/src/skill-dashboard-web/script.js`

### REQ-FC-010: Charts Visualization Component
The system SHALL provide chart components for data visualization within the analytics dashboard, supporting line charts, bar charts, and real-time updating charts.

#### Scenario: Chart rendering with live data
- WHEN analytics data updates arrive via WebSocket
- THEN the Charts component updates visualizations in real-time
- AND maintains smooth animations during data transitions

**File:** `cli-tool/src/analytics-web/components/Charts.js`

### REQ-FC-011: Header Component
The system SHALL provide a header component for the analytics dashboard with navigation, connection status indicators, and system health badges.

#### Scenario: Header status display
- WHEN the dashboard is connected to the analytics backend
- THEN the HeaderComponent shows connection status as green
- AND displays system health indicators
- AND provides navigation controls

**File:** `cli-tool/src/analytics-web/components/HeaderComponent.js`

### REQ-FC-012: Sidebar Navigation Component
The system SHALL provide a collapsible sidebar component with navigation links to different dashboard sections and view toggles.

#### Scenario: Sidebar navigation
- WHEN the user clicks a sidebar navigation item
- THEN the main content area updates to show the selected section
- AND the sidebar highlights the active navigation item

**File:** `cli-tool/src/analytics-web/components/Sidebar.js`
