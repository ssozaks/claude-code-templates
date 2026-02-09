#\!/bin/bash
# =============================================================================
# Stop Hook - Quality Check When Claude Session Ends
# =============================================================================
# Runs when Claude session ends.
# Warns about uncommitted changes.
# Counts new TODO/FIXME markers in changed files.
# Shows a summary of the session impact.
#
# Exit code: Always 0 (informational only, never blocks)
# =============================================================================

echo ""
echo "=========================================="
echo "  Session Quality Check"
echo "=========================================="

# --- Check for uncommitted changes ---
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    UNCOMMITTED=$(git status --porcelain 2>/dev/null)

    if [ -n "$UNCOMMITTED" ]; then
        MODIFIED_COUNT=$(echo "$UNCOMMITTED" | grep -c "^ M\|^M " 2>/dev/null || echo "0")
        ADDED_COUNT=$(echo "$UNCOMMITTED" | grep -c "^??" 2>/dev/null || echo "0")
        STAGED_COUNT=$(echo "$UNCOMMITTED" | grep -c "^[MADRC]" 2>/dev/null || echo "0")

        echo ""
        echo "WARNING: Uncommitted changes detected\!"
        echo "  Modified files:  $MODIFIED_COUNT"
        echo "  Untracked files: $ADDED_COUNT"
        echo "  Staged files:    $STAGED_COUNT"
        echo ""
        echo "  Consider committing your changes:"
        echo "    git add -A && git commit -m \"feat: describe your changes\""
    else
        echo ""
        echo "OK: Working tree is clean. All changes committed."
    fi

    # --- Count TODO/FIXME markers in changed files ---
    CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null; git diff --name-only --cached 2>/dev/null)

    if [ -n "$CHANGED_FILES" ]; then
        TODO_COUNT=0
        FIXME_COUNT=0
        HACK_COUNT=0

        while IFS= read -r file; do
            if [ -f "$file" ]; then
                FILE_TODOS=$(grep -c "\bTODO\b" "$file" 2>/dev/null || echo "0")
                FILE_FIXMES=$(grep -c "\bFIXME\b" "$file" 2>/dev/null || echo "0")
                FILE_HACKS=$(grep -c "\bHACK\b" "$file" 2>/dev/null || echo "0")
                TODO_COUNT=$((TODO_COUNT + FILE_TODOS))
                FIXME_COUNT=$((FIXME_COUNT + FILE_FIXMES))
                HACK_COUNT=$((HACK_COUNT + FILE_HACKS))
            fi
        done <<< "$CHANGED_FILES"

        TOTAL_MARKERS=$((TODO_COUNT + FIXME_COUNT + HACK_COUNT))

        if [ "$TOTAL_MARKERS" -gt 0 ]; then
            echo ""
            echo "NOTE: Code markers found in changed files:"
            [ "$TODO_COUNT" -gt 0 ] && echo "  TODO:  $TODO_COUNT"
            [ "$FIXME_COUNT" -gt 0 ] && echo "  FIXME: $FIXME_COUNT"
            [ "$HACK_COUNT" -gt 0 ] && echo "  HACK:  $HACK_COUNT"
            echo ""
            echo "  Review these markers before shipping to production."
        fi
    fi

    # --- Show current branch ---
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    echo ""
    echo "Current branch: $BRANCH"

    # --- Show recent commits from this session ---
    RECENT=$(git log --oneline -5 --since="2 hours ago" 2>/dev/null)
    if [ -n "$RECENT" ]; then
        echo ""
        echo "Recent commits (last 2 hours):"
        echo "$RECENT" | while IFS= read -r line; do
            echo "  $line"
        done
    fi
else
    echo ""
    echo "INFO: Not a git repository. Skipping git checks."
fi

echo ""
echo "=========================================="
echo ""

exit 0
