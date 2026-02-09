#\!/bin/bash
# =============================================================================
# TeammateIdle Hook - Agent Teams Idle Handler
# =============================================================================
# Runs when a teammate agent becomes idle.
# Checks completed tasks and reports pending tasks.
# Helps the team lead monitor teammate progress.
#
# Exit code: Always 0 (informational only)
# =============================================================================

# --- Parse hook input ---
TEAMMATE_NAME="${CLAUDE_TEAMMATE_NAME:-unknown}"
TEAMMATE_ROLE="${CLAUDE_TEAMMATE_ROLE:-}"

# If arguments are passed as JSON via stdin, parse them
if [ "$TEAMMATE_NAME" = "unknown" ] && [ -p /dev/stdin ]; then
    INPUT=$(cat /dev/stdin 2>/dev/null || true)
    if [ -n "$INPUT" ] && command -v jq &>/dev/null; then
        TEAMMATE_NAME=$(echo "$INPUT" | jq -r ".teammate_name // \"unknown\"" 2>/dev/null || true)
        TEAMMATE_ROLE=$(echo "$INPUT" | jq -r ".teammate_role // empty" 2>/dev/null || true)
    fi
fi

echo ""
echo "=========================================="
echo "  Teammate Idle: $TEAMMATE_NAME"
[ -n "$TEAMMATE_ROLE" ] && echo "  Role: $TEAMMATE_ROLE"
echo "=========================================="

# --- Check current task file ---
TASK_FILE=".claude/current-task.md"
if [ -f "$TASK_FILE" ]; then
    echo ""
    echo "Current task status:"

    # Count completed and pending tasks from the task file
    COMPLETED=$(grep -c "\[x\]" "$TASK_FILE" 2>/dev/null || echo "0")
    PENDING=$(grep -c "\[ \]" "$TASK_FILE" 2>/dev/null || echo "0")
    TOTAL=$((COMPLETED + PENDING))

    echo "  Completed: $COMPLETED / $TOTAL"
    echo "  Pending:   $PENDING"

    if [ "$PENDING" -gt 0 ]; then
        echo ""
        echo "  Pending tasks:"
        grep "\[ \]" "$TASK_FILE" 2>/dev/null | head -5 | while IFS= read -r line; do
            echo "    $line"
        done
        REMAINING=$(grep -c "\[ \]" "$TASK_FILE" 2>/dev/null || echo "0")
        if [ "$REMAINING" -gt 5 ]; then
            echo "    ... and $((REMAINING - 5)) more"
        fi
    fi
else
    echo ""
    echo "  No current-task.md found."
    echo "  Consider creating .claude/current-task.md to track progress."
fi

# --- Check for uncommitted changes by this teammate ---
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo ""
        echo "  NOTE: $UNCOMMITTED uncommitted file(s) detected."
        echo "  The teammate may have unfinished work."
    fi
fi

# --- Suggestions ---
echo ""
echo "Suggestions:"
if [ "${PENDING:-0}" -gt 0 ]; then
    echo "  - Assign next pending task to this teammate"
    echo "  - Or reassign to another teammate if blocked"
else
    echo "  - All tasks appear complete"
    echo "  - Consider shutting down this teammate"
    echo "  - Or assign new tasks if more work is needed"
fi

echo ""
echo "=========================================="
echo ""

exit 0
