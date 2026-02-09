# Ralph Wiggum Autonomous Loop Rules

## What is Ralph Wiggum
Ralph Wiggum is an autonomous coding loop technique. Claude works independently through a task list, making decisions and writing code without requiring user approval at each step. Named after the self-referential nature of the approach.

## How It Works
1. User starts the loop: `/ralph-loop`
2. Claude reads the task from `.claude/current-task.md`
3. Claude works through subtasks autonomously
4. At each checkpoint, Claude updates `current-task.md`
5. Loop continues until task is complete or cancelled
6. User can cancel anytime: `/cancel-ralph`

## Completion Promise
- Claude MUST update `current-task.md` before each major step
- Claude MUST commit working code at logical checkpoints
- Claude MUST NOT make destructive changes without the completion promise
- If uncertain, Claude stops and asks rather than guessing

## Safety Guardrails
- NEVER force-push or reset --hard
- NEVER delete files outside the project directory
- NEVER modify .env files with real credentials
- NEVER commit secrets
- ALWAYS work on a feature branch (not main)
- ALWAYS run tests before marking task complete

## When to Use
- Implementing a well-defined feature from a spec
- Bulk changes across many files (rename, refactor)
- Repetitive implementation tasks
- When the task is clear and risks are low

## When NOT to Use
- Unclear or ambiguous requirements
- First-time architecture decisions
- Production deployments
- Database migrations in production

## Configuration
The Ralph loop config is at `.claude/ralph-loop.local.md` and can be customized per project.
