# OpenSpec Workflow Guide

## What is OpenSpec
OpenSpec is a spec-driven development workflow. It creates structured specification documents before implementation, ensuring clarity, traceability, and systematic development.

## Workflow: proposal → design → tasks → implementation → archive

### 1. Proposal (`/openspec:proposal`)
- Create a new feature proposal
- Define: what, why, acceptance criteria
- Output: `openspec/changes/<feature>/proposal.md`

### 2. Design (manual or with Claude)
- Technical design based on proposal
- Define: architecture, data models, API contracts
- Output: `openspec/changes/<feature>/design.md`

### 3. Tasks
- Break down design into implementable tasks
- Checklist format with clear acceptance criteria
- Output: `openspec/changes/<feature>/tasks.md`

### 4. Implementation
- Implement tasks from the checklist
- Reference spec files during development
- Update tasks.md as items are completed

### 5. Archive (`/openspec:archive`)
- Move completed specs to archive
- Maintain history of decisions

## When to Use OpenSpec
- New features or significant enhancements
- Architectural changes
- Complex integrations
- Any change that benefits from upfront planning

## When NOT to Use
- Simple bug fixes
- Minor styling changes
- Documentation updates
- Single-file changes

## Integration with Agent Teams
- Spec files serve as shared context for teammates
- Each teammate can reference the spec for their scope
- Tasks from spec can be distributed across teammates
- Spec survives context compaction (it's a file, not conversation)
