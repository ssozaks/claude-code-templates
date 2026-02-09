#\!/bin/bash
# =============================================================================
# PostToolUse Hook - Auto-Format After File Changes
# =============================================================================
# Runs after Write/Edit tools.
# Auto-formats .ts/.tsx/.js/.jsx files with prettier.
# Auto-formats .py files with black.
#
# Exit code: Always 0 (formatting failure should never block operations)
# =============================================================================

# --- Parse hook input ---
TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
FILE_PATH="${CLAUDE_FILE_PATH:-}"

# If arguments are passed as JSON via stdin, parse them
if [ -z "$FILE_PATH" ] && [ -p /dev/stdin ]; then
    INPUT=$(cat /dev/stdin 2>/dev/null || true)
    if [ -n "$INPUT" ] && command -v jq &>/dev/null; then
        TOOL_NAME=$(echo "$INPUT" | jq -r ".tool_name // empty" 2>/dev/null || true)
        FILE_PATH=$(echo "$INPUT" | jq -r ".file_path // .input.file_path // empty" 2>/dev/null || true)
    fi
fi

# --- Only process Write/Edit tools ---
case "$TOOL_NAME" in
    Write|Edit|write|edit) ;;
    *) exit 0 ;;
esac

# --- Check that file exists ---
if [ -z "$FILE_PATH" ] || [ \! -f "$FILE_PATH" ]; then
    exit 0
fi

# --- Get file extension ---
EXTENSION="${FILE_PATH##*.}"

# --- Format based on file type ---
case "$EXTENSION" in
    ts|tsx|js|jsx|json|css|scss|html|md|yaml|yml)
        # Format with prettier if available
        if command -v prettier &>/dev/null; then
            prettier --write "$FILE_PATH" --log-level silent 2>/dev/null || true
        elif command -v npx &>/dev/null; then
            # Try npx prettier as fallback (if installed locally)
            npx --no-install prettier --write "$FILE_PATH" --log-level silent 2>/dev/null || true
        fi
        ;;
    py)
        # Format with black if available
        if command -v black &>/dev/null; then
            black --quiet "$FILE_PATH" 2>/dev/null || true
        fi
        # Also run isort if available (import sorting)
        if command -v isort &>/dev/null; then
            isort --quiet "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
esac

# --- Always exit successfully ---
# Formatting failures should never block the workflow
exit 0
