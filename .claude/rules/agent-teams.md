# Agent Teams Coordination Rules

## When to Use Agent Teams
- Parallel research or review (multiple perspectives)
- New feature spanning frontend + backend + tests
- Debugging with different hypotheses in parallel
- Cross-layer changes (frontend, backend, DB migration separately)

## When NOT to Use
- Single file edits or simple bug fixes
- Highly sequential tasks (step B depends on step A output)
- Multiple agents editing the SAME file (creates conflicts)

## Team Configuration
- **Max teammates:** 4 (diminishing returns beyond this)
- **Tasks per teammate:** 5-6 is ideal
- **Mode:** Delegate (lead coordinates, teammates implement)
- **Plan approval:** Required for risky changes

## File Ownership Rules (CRITICAL)
Each teammate MUST own a distinct set of files/directories. Overlap causes conflicts.

### Example Ownership Split
- Frontend: `src/components/`, `src/app/`, `src/hooks/`
- Backend: `apps/`, `src/modules/`, `config/`
- Tests: `tests/`, `__tests__/`, `*.test.*`, `*.spec.*`
- DevOps: `Dockerfile`, `docker-compose.yml`, `.github/`

## Context Sharing
- Teammates do NOT inherit conversation history
- Spawn prompts must include ALL necessary context
- Reference specific files and line numbers
- Include relevant coding standards

## Team Templates
See `.claude/skills/init-project/templates/teams/` for:
- `feature-team.md` - Full-stack feature development
- `review-team.md` - Code review with security/performance/quality focus
- `research-team.md` - Technical research with devil's advocate

## Best Practices
1. Create tasks before spawning teammates
2. Assign clear ownership boundaries
3. Use TaskUpdate to track progress
4. Monitor idle teammates; reassign if blocked
5. Clean up team after work completes
6. Always use delegate mode for coordination
