# Page Structure

## Purpose
Defines the public-facing web pages served at aitmpl.com via Vercel from the docs/ output directory. The website provides a component browsing interface, component detail pages, download statistics, trending data, job board, blog, sandbox interface, and plugin pages. All pages use vanilla HTML/CSS/JavaScript with client-side routing handled by the stack-router module and Vercel URL rewrites.

## Requirements

### REQ-PS-001: Main Component Browsing Page
The system MUST provide a main index page at the root URL that allows users to browse, search, filter, and install Claude Code components (agents, commands, settings, hooks, MCPs, skills, templates) with category tabs and interactive cards.

#### Scenario: Component catalog browsing
- WHEN a user visits aitmpl.com
- THEN the index page loads with all component categories
- AND displays component cards with name, description, and install command
- AND provides category filter tabs (agents, commands, settings, hooks, mcps, templates, plugins)

#### Scenario: Client-side route navigation
- WHEN a user clicks the /agents, /commands, /settings, /hooks, /mcps, or /templates tab
- THEN the client-side router filters the view to the selected category
- AND the URL is updated without a full page reload

**File:** `docs/index.html`, `docs/js/script.js`, `docs/js/stack-router.js`

### REQ-PS-002: Component Detail Page
The system MUST provide a component detail page at /component/:type/:name that displays the full component content, installation instructions, metadata, and related components.

#### Scenario: Component detail display
- WHEN a user navigates to /component/agent/security-auditor
- THEN the component.html page loads with the component's full content
- AND shows installation command, category, type, and description
- AND displays related components from the same category

**File:** `docs/component.html`, `docs/js/component-page.js`

### REQ-PS-003: Download Statistics Page
The system MUST provide a download statistics page that displays component download metrics with charts, rankings, and time-series data sourced from the tracking API.

#### Scenario: Statistics dashboard display
- WHEN a user visits the download stats page
- THEN charts render showing download trends over time
- AND top downloaded components are listed by category
- AND total download counts are displayed prominently

**File:** `docs/download-stats.html`

### REQ-PS-004: Trending Components Page
The system MUST provide a trending page that showcases popular and recently trending components based on download velocity and community engagement.

#### Scenario: Trending data display
- WHEN a user visits the trending page
- THEN trending components are displayed with trend indicators
- AND data is loaded from the pre-generated trending-data.json file
- AND time period filters are available (24h, 7d, 30d)

**File:** `docs/trending.html`, `docs/trending-data.json`, `docs/js/trending.js`

### REQ-PS-005: Plugin Marketplace Page
The system MUST provide a plugin detail page at /plugin/:name that displays plugin information, permissions, installation instructions, and configuration details.

#### Scenario: Plugin detail view
- WHEN a user navigates to /plugin/some-plugin
- THEN the plugin page loads with plugin metadata
- AND shows required permissions, configuration options, and install command

**File:** `docs/plugin.html`, `docs/js/plugin-page.js`

### REQ-PS-006: Workflows Documentation Page
The system MUST provide a workflows page that documents available automation workflows with visual representations and configuration guides.

#### Scenario: Workflow documentation browsing
- WHEN a user visits the workflows page
- THEN available workflows are listed with descriptions
- AND each workflow shows its trigger conditions and actions
- AND configuration examples are provided

**File:** `docs/workflows.html`, `docs/js/workflows.js`, `docs/js/workflows-events.js`

### REQ-PS-007: Blog Content Section
The system SHALL provide a blog section with articles about Claude Code development, tips, and component highlights.

#### Scenario: Blog page rendering
- WHEN a user navigates to the blog section
- THEN blog posts are displayed in reverse chronological order
- AND each post shows title, date, summary, and read-more link

**File:** `docs/blog/`

### REQ-PS-008: Search Functionality Across All Pages
The system MUST provide cross-page search functionality that allows users to search components by name, description, category, and type with instant results.

#### Scenario: Component search execution
- WHEN a user types a search query in the search box
- THEN matching components are filtered and displayed instantly
- AND results are ranked by relevance
- AND search works across all component types

**File:** `docs/js/search-functionality.js`

### REQ-PS-009: Component Data Loading from JSON Catalog
The system MUST load component data from the pre-generated components.json catalog file and components-metadata.json for efficient client-side rendering without API calls for browsing.

#### Scenario: Catalog data loading
- WHEN any page that displays components initializes
- THEN the data-loader fetches components.json
- AND parses the JSON catalog into renderable component objects
- AND caches the data for subsequent navigations

**File:** `docs/js/data-loader.js`, `docs/components.json`, `docs/components-metadata.json`

### REQ-PS-010: Sandbox Interface Page
The system SHALL provide a sandbox interface page that allows users to test and preview component configurations in an isolated environment.

#### Scenario: Sandbox page load
- WHEN a user navigates to the sandbox interface
- THEN the sandbox page loads with an interactive configuration editor
- AND provides preview capabilities for component settings

**File:** `docs/sandbox-interface.html`

### REQ-PS-011: SEO and Accessibility Configuration
The system MUST provide robots.txt and sitemap.xml files for search engine optimization, and CNAME configuration for the custom domain aitmpl.com.

#### Scenario: Search engine crawling
- WHEN a search engine crawler visits the site
- THEN robots.txt provides crawling directives
- AND sitemap.xml lists all indexable pages with priorities and change frequencies

**File:** `docs/robots.txt`, `docs/sitemap.xml`, `docs/CNAME`
