# Coding Standards

## Naming Conventions
- **Frontend (TypeScript/React):** camelCase for variables/functions, PascalCase for components/classes
- **Backend (Django/Python):** snake_case for variables/functions, PascalCase for classes
- **Backend (NestJS/TypeScript):** camelCase for variables/functions, PascalCase for classes/interfaces
- **Database:** snake_case for tables and columns
- **API responses:** camelCase for JSON keys
- **Files:** kebab-case for components (user-profile.tsx), snake_case for Python (user_service.py)

## Git Conventions
- **Commit messages:** Conventional Commits format in ENGLISH
  - `feat:` new feature
  - `fix:` bug fix
  - `refactor:` code restructuring
  - `docs:` documentation
  - `test:` adding tests
  - `chore:` maintenance
- **Branches:** `feature/`, `fix/`, `refactor/` prefixes
- **PRs:** Short title (<70 chars), detailed description with summary and test plan

## Code Quality
- No `any` type in TypeScript
- No `console.log` in production code (use proper logging)
- No commented-out code in commits
- No TODO/FIXME without tracking issue
- Maximum function length: ~50 lines
- Maximum file length: ~300 lines
- DRY: Extract shared logic, but avoid premature abstraction

## Import Order
1. External packages (react, next, etc.)
2. Internal aliases (@/components, @/lib)
3. Relative imports (./utils, ../types)
4. Style imports (*.css)

## Error Handling
- Always handle errors explicitly; no silent catches
- Use typed errors where possible
- Log errors with context (user action, input data)
- User-facing errors in Turkish, system errors in English
