# State Management

## Purpose
Defines the client-side state management patterns used in the analytics dashboard frontend and the server-side caching/data management layer. The frontend uses a service-oriented pattern with reactive state updates via a StateService, centralized API communication via a DataService, and real-time data flow through a WebSocketService. The backend uses a DataCache module for multi-level caching and a PerformanceMonitor for system health tracking.

## Requirements

### REQ-SM-001: Reactive State Service
The system MUST provide a StateService that manages frontend application state with reactive subscriptions, enabling components to subscribe to state changes and receive automatic updates when data changes.

#### Scenario: Component state subscription
- WHEN a dashboard component subscribes to a state key
- THEN it receives the current value immediately
- AND is notified of subsequent changes to that key
- AND can unsubscribe to stop receiving updates

#### Scenario: State update propagation
- WHEN the StateService updates a state value
- THEN all subscribed components receive the new value
- AND UI re-renders are triggered only for affected components

**File:** `cli-tool/src/analytics-web/services/StateService.js`

### REQ-SM-002: Centralized Data Service with Caching
The system MUST provide a DataService that handles all API communication from the frontend, including request deduplication, response caching, and automatic retry logic for transient failures.

#### Scenario: API data fetch with cache
- WHEN a component requests data via the DataService
- THEN the service checks the local cache first
- AND returns cached data if still valid (within TTL)
- AND fetches fresh data from the API if cache is stale

#### Scenario: Request deduplication
- WHEN multiple components request the same data simultaneously
- THEN only one API request is made
- AND all requestors receive the same response

**File:** `cli-tool/src/analytics-web/services/DataService.js`

### REQ-SM-003: WebSocket Service for Real-Time Data Flow
The system MUST provide a WebSocketService that manages the WebSocket connection lifecycle, message parsing, automatic reconnection, and data distribution to the StateService for real-time dashboard updates.

#### Scenario: WebSocket message processing
- WHEN a WebSocket message is received from the analytics server
- THEN the WebSocketService parses the message
- AND updates the StateService with new data
- AND triggers component re-renders for affected state keys

#### Scenario: Automatic reconnection
- WHEN the WebSocket connection is lost
- THEN the service attempts exponential backoff reconnection
- AND switches to HTTP polling as a fallback mechanism
- AND notifies the UI of the connection status change

**File:** `cli-tool/src/analytics-web/services/WebSocketService.js`

### REQ-SM-004: Server-Side Multi-Level Data Cache
The system MUST provide a DataCache module on the analytics backend that implements multi-level caching (memory and disk) with configurable TTL, automatic eviction, and cache invalidation on data updates.

#### Scenario: Cache hit for conversation data
- WHEN conversation data is requested and exists in memory cache
- THEN the cached data is returned immediately without disk or file I/O

#### Scenario: Cache miss and population
- WHEN conversation data is requested but not cached
- THEN the data is loaded from the file system
- AND stored in both memory and disk cache layers
- AND the cache entry is timestamped for TTL tracking

#### Scenario: Cache eviction
- WHEN a cache entry exceeds its TTL
- THEN the entry is evicted on next access
- AND fresh data is loaded to replace it

**File:** `cli-tool/src/analytics/data/DataCache.js`

### REQ-SM-005: Performance Monitor for System Metrics
The system MUST provide a PerformanceMonitor module that tracks system health metrics including memory usage, CPU load, response times, and WebSocket connection counts, making this data available to the dashboard.

#### Scenario: System health metrics collection
- WHEN the PerformanceMonitor performs a health check cycle
- THEN it collects current memory usage, CPU load, and active connections
- AND stores the metrics with timestamps for trend analysis
- AND makes the data available to dashboard components via the StateService

#### Scenario: Memory threshold alerting
- WHEN memory usage exceeds a configurable threshold
- THEN the PerformanceMonitor emits a warning event
- AND the dashboard displays a health alert

**File:** `cli-tool/src/analytics/utils/PerformanceMonitor.js`

### REQ-SM-006: Tracking Service for CLI Analytics
The system SHALL provide a TrackingService module that manages the client-side tracking of component installations and command executions, batching requests when possible and handling offline scenarios.

#### Scenario: Component download tracking
- WHEN a component is installed via the CLI
- THEN the TrackingService sends a POST request to the tracking API
- AND includes component type, name, path, category, and CLI version
- AND handles API errors gracefully without interrupting the installation flow

**File:** `cli-tool/src/tracking-service.js`

### REQ-SM-007: Global Agent Manager SDK
The system SHALL provide a global agent manager in the SDK module that manages agent lifecycle, configuration, and state across CLI sessions.

#### Scenario: Agent registration and lookup
- WHEN a new agent is registered via the SDK
- THEN the global agent manager stores the agent configuration
- AND makes it available for lookup by name or category

**File:** `cli-tool/src/sdk/global-agent-manager.js`
