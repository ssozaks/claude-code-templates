#!/bin/bash
# =============================================================================
# TaskCompleted Hook - Quality Gate
# =============================================================================
# Runs when a task is marked as completed.
# Runs lint/type-check and test suite.
# Exit code 2 to reject task completion if checks fail.
# =============================================================================

# --- Detect project type ---
PROJECT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

HAS_PACKAGE_JSON=false
HAS_REQUIREMENTS=false

[ -f "$PROJECT_DIR/package.json" ] && HAS_PACKAGE_JSON=true
[ -f "$PROJECT_DIR/requirements.txt" ] || [ -d "$PROJECT_DIR/requirements" ] && HAS_REQUIREMENTS=true

ERRORS=0

# --- Run lint/type-check ---
if [ "$HAS_PACKAGE_JSON" = true ]; then
    if command -v pnpm &>/dev/null; then
        # Type check
        pnpm type-check 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "⚠️  TypeScript type-check failed"
            ERRORS=$((ERRORS + 1))
        fi

        # Lint
        pnpm lint 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "⚠️  Lint check failed"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

if [ "$HAS_REQUIREMENTS" = true ]; then
    if command -v flake8 &>/dev/null; then
        flake8 --max-line-length=120 --count 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "⚠️  Python lint (flake8) failed"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# --- Run tests ---
if [ "$HAS_PACKAGE_JSON" = true ]; then
    if command -v pnpm &>/dev/null; then
        pnpm test --passWithNoTests 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "⚠️  Tests failed"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

if [ "$HAS_REQUIREMENTS" = true ]; then
    if command -v pytest &>/dev/null; then
        pytest --tb=short -q 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "⚠️  Python tests failed"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# --- Result ---
if [ $ERRORS -gt 0 ]; then
    echo ""
    echo "❌ Quality gate failed with $ERRORS issue(s)."
    echo "Fix the issues above before marking the task as completed."
    exit 2
fi

echo "✅ Quality gate passed"
exit 0
