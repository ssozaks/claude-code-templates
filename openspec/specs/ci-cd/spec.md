# CI/CD

## Purpose
Defines the continuous integration and deployment pipelines for the Claude Code Templates project. The project uses GitHub Actions for automated workflows including package publishing to GitHub Packages/npm, component security validation on pull requests, Discord release notifications, and component catalog data updates. Deployment to production is handled via Vercel with automated cron jobs.

## Requirements

### REQ-CC-001: Automated Package Publishing Workflow
The system MUST provide a GitHub Actions workflow that publishes the CLI tool package to GitHub Packages when a release is published or when manually triggered, including dependency installation, test execution, and scoped package configuration.

#### Scenario: Release-triggered publish
- WHEN a new GitHub release is published
- THEN the workflow checks out the repository
- AND sets up Node.js 18 with GitHub Packages registry
- AND installs dependencies with `npm ci`
- AND runs the test suite
- AND publishes to GitHub Packages under @davila7 scope

#### Scenario: Manual version publish
- WHEN the workflow is manually triggered with a version input
- THEN the workflow uses the specified version for publication
- AND generates a summary with installation instructions

**File:** `.github/workflows/publish-package.yml`

### REQ-CC-002: Component Security Validation Workflow
The system MUST run automated security validation on all component files (cli-tool/components/**/*.md) when pull requests modify components or when changes are pushed to main, generating security audit reports and posting results as PR comments.

#### Scenario: PR component security check
- WHEN a pull request modifies component markdown files
- THEN the workflow runs `npm run security-audit:ci`
- AND generates a JSON security report
- AND uploads the report as a workflow artifact (30-day retention)
- AND posts a formatted PR comment with pass/fail status, component scores, and error details

#### Scenario: Security audit failure
- WHEN the security audit detects critical issues
- THEN the workflow fails with an explicit error message
- AND the PR is blocked from merging

**File:** `.github/workflows/component-security-validation.yml`

### REQ-CC-003: Discord Release Notification Workflow
The system SHALL provide a GitHub Actions workflow that sends Discord notifications when new releases of the CLI tool are published, formatted with version details and changelog information.

#### Scenario: Release notification dispatch
- WHEN a new release is created on GitHub
- THEN the workflow sends a formatted notification to the configured Discord webhook
- AND includes version number, changelog summary, and installation instructions

**File:** `.github/workflows/discord-release-notification.yml`

### REQ-CC-004: Component Catalog Data Update Workflow
The system SHALL provide a GitHub Actions workflow that regenerates the components.json catalog file whenever component files are added, modified, or removed, keeping the web interface data in sync.

#### Scenario: Component catalog regeneration
- WHEN component files in cli-tool/components/ are modified
- THEN the workflow runs the component generation script
- AND updates docs/components.json with the latest catalog data
- AND commits the changes back to the repository

**File:** `.github/workflows/update-json-data.yml`

### REQ-CC-005: Vercel Production Deployment Configuration
The system MUST configure Vercel deployment with the docs/ directory as output, npm build command, URL rewrites for SPA routing, and cron job scheduling for the version check endpoint.

#### Scenario: SPA route rewriting
- WHEN a user navigates to /agents, /commands, /settings, /hooks, /mcps, /templates, or /plugins
- THEN Vercel rewrites the request to index.html for client-side routing

#### Scenario: Component page routing
- WHEN a user navigates to /component/:type/:name
- THEN Vercel rewrites the request to component.html

#### Scenario: Plugin page routing
- WHEN a user navigates to /plugin/:name
- THEN Vercel rewrites the request to plugin.html

**File:** `vercel.json`

### REQ-CC-006: Pre-deployment Validation Script
The system SHALL provide a pre-deployment check script that validates critical endpoints, environment variables, and build artifacts before production deployment.

#### Scenario: Pre-deploy checks execution
- WHEN the predeploy-check.sh script is run
- THEN it validates all required environment variables are set
- AND checks API endpoint health
- AND verifies build output exists in docs/

**File:** `scripts/predeploy-check.sh`
