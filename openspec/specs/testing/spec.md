# Testing

## Purpose
Defines the testing infrastructure and requirements for the Claude Code Templates project. The project uses Jest as the primary testing framework for unit and integration tests across the CLI tool and API layers, and Playwright for end-to-end browser testing of the analytics dashboard. Tests are organized by type (unit, integration, validation, e2e) and follow the AAA (Arrange, Act, Assert) pattern.

## Requirements

### REQ-TE-001: Jest Unit Test Framework for CLI Tool
The system MUST use Jest as the testing framework for the CLI tool, configured with Node.js test environment, coverage collection from src/**/*.js excluding test files, and minimum 70% coverage thresholds for branches, functions, lines, and statements.

#### Scenario: Unit test execution
- WHEN `npm test` is run in the cli-tool directory
- THEN Jest discovers and executes all test files in tests/unit/
- AND reports pass/fail results with coverage summary

#### Scenario: Coverage threshold enforcement
- WHEN test coverage drops below 70% for any metric
- THEN Jest reports a coverage failure

**File:** `cli-tool/jest.config.js`

### REQ-TE-002: API Endpoint Integration Tests
The system MUST provide integration tests for all critical API endpoints validating response status codes, CORS headers, request validation, and error handling.

#### Scenario: Endpoint response validation
- WHEN API endpoint tests are run via `npm test` in the api/ directory
- THEN all endpoints are tested for correct HTTP status codes
- AND CORS headers are verified present
- AND invalid data returns 400 errors
- AND correct HTTP method validation is confirmed

**File:** `api/__tests__/endpoints.test.js`, `api/jest.config.cjs`

### REQ-TE-003: Component Validation Test Suite
The system SHALL provide validation tests that verify component integrity using the multi-layer validation system including structural, semantic, integrity, provenance, and reference validators.

#### Scenario: Validation test execution
- WHEN validation tests are run
- THEN each validator (Structural, Semantic, Integrity, Provenance, Reference) is tested independently
- AND the ValidationOrchestrator coordination logic is verified

**File:** `cli-tool/tests/validation/`

### REQ-TE-004: Playwright E2E Test Configuration
The system MUST configure Playwright for end-to-end testing of the analytics dashboard with a 30-second timeout, 1 retry on failure, trace capture on first retry, screenshot on failure, and automatic web server startup on port 3333.

#### Scenario: E2E test with analytics dashboard
- WHEN Playwright E2E tests are executed
- THEN the analytics server starts automatically via `npm run analytics:start`
- AND tests run against http://localhost:3333
- AND failed tests capture screenshots and traces

**File:** `playwright.config.ts`

### REQ-TE-005: Homepage Load E2E Test
The system MUST include an E2E test that verifies the analytics dashboard homepage loads successfully with a non-empty title and no console errors.

#### Scenario: Successful homepage load
- WHEN the homepage E2E test runs
- THEN the page loads at the base URL
- AND the page title matches a non-empty string
- AND no console errors are detected during page load

**File:** `e2e/example.spec.ts`

### REQ-TE-006: Test Organization by Category
The system MUST organize tests into distinct directories by type: unit tests (tests/unit/), integration tests (tests/integration/), validation tests (tests/validation/), and end-to-end tests (e2e/).

#### Scenario: Test discovery by category
- WHEN a specific test category is requested (e.g., unit tests only)
- THEN only tests from the corresponding directory are executed
- AND test results are reported with category context

**File:** `cli-tool/tests/unit/`, `cli-tool/tests/integration/`, `cli-tool/tests/validation/`, `e2e/`

### REQ-TE-007: Test Setup and Fixtures
The system SHALL provide a centralized test setup file that configures mock environments, common fixtures, and shared test utilities for consistent test execution.

#### Scenario: Test environment initialization
- WHEN any test suite starts
- THEN the setup file configures mock environment variables
- AND provides common test utilities and fixtures
- AND ensures isolated test execution

**File:** `cli-tool/tests/setup.js`

### REQ-TE-008: Shell-Based CLI Command Testing
The system SHALL provide shell-based test scripts for verifying CLI command execution, component installation flows, and interactive mode behavior.

#### Scenario: CLI command smoke testing
- WHEN test-commands.sh is executed
- THEN each CLI flag and command combination is tested
- AND expected output patterns are verified
- AND error conditions are tested for proper handling

**File:** `cli-tool/test-commands.sh`, `cli-tool/test-detailed.sh`
