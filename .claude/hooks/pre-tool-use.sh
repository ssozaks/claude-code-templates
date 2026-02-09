#\!/bin/bash
# =============================================================================
# PreToolUse Hook - Branch Protection + .env Protection
# =============================================================================
# Runs before Write/Edit tools.
# Blocks writes to main/master/production branches.
# Blocks editing .env files (except .env.example).
#
# Exit codes:
#   0 = allow the operation
#   2 = block the operation
# =============================================================================

# --- Configuration ---
PROTECTED_BRANCHES=("main" "master" "production" "prod" "release")

# --- Parse hook input ---
TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
FILE_PATH="${CLAUDE_FILE_PATH:-}"

# If arguments are passed as JSON via stdin, parse them
if [ -z "$TOOL_NAME" ] && [ -p /dev/stdin ]; then
    INPUT=$(cat /dev/stdin 2>/dev/null || true)
    if [ -n "$INPUT" ] && command -v jq &>/dev/null; then
        TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || true)
        FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // .input.file_path // empty' 2>/dev/null || true)
    fi
fi

# --- Only check Write/Edit tools ---
case "$TOOL_NAME" in
    Write|Edit|write|edit) ;;
    *) exit 0 ;;
esac

# --- Branch Protection ---
CURRENT_BRANCH=""
if command -v git &>/dev/null; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
fi

if [ -n "$CURRENT_BRANCH" ]; then
    for branch in "${PROTECTED_BRANCHES[@]}"; do
        if [ "$CURRENT_BRANCH" = "$branch" ]; then
            echo "BLOCKED: Cannot write/edit files on protected branch '$CURRENT_BRANCH'."
            echo "Please create a feature branch first:"
            echo "  git checkout -b feature/your-feature-name"
            exit 2
        fi
    done
fi

# --- .env File Protection ---
if [ -n "$FILE_PATH" ]; then
    BASENAME=$(basename "$FILE_PATH")

    # Allow .env.example files
    if [ "$BASENAME" = ".env.example" ]; then
        exit 0
    fi

    # Block .env files and variants
    if [[ "$BASENAME" == ".env" ]] || [[ "$BASENAME" == .env.* ]] || [[ "$BASENAME" == *.env ]]; then
        echo "BLOCKED: Cannot edit environment file '$BASENAME'."
        echo "Environment files contain secrets and should not be edited by AI tools."
        echo ""
        echo "Allowed actions:"
        echo "  - Edit .env.example (template without real values)"
        echo "  - Manually edit .env files using your text editor"
        exit 2
    fi
fi

# --- All checks passed ---
exit 0
