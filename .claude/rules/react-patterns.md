---
paths:
  - "src/components/**/*.tsx"
  - "src/app/**/*.tsx"
  - "src/hooks/**/*.ts"
---

# React Patterns

## Component Structure
- All components in TypeScript (.tsx)
- Export named components (not default)
- Props interface defined above component
- Destructure props in function signature

## Architecture
- App Router with Server Components by default
- Client Components only when needed ('use client')
- Mobile-first responsive design
- shadcn/ui components preferred over custom
- Composition over inheritance

## Forms
- React Hook Form for all forms
- Zod schemas for validation
- Schemas in `src/lib/validations/`
- Show validation errors inline

## State Management
- React Server Components for server state
- React hooks for local state
- URL search params for shareable state
- Avoid unnecessary client-side state

## Performance
- Use `React.memo` only when measured
- Lazy load heavy components with `dynamic()`
- Optimize images with `next/image`
- Avoid prop drilling; use composition

## Turkish-Safe
- Import from `lib/turkish-utils` for case operations
- Use `next-intl` for all user-facing text
- Test with Turkish characters in all text inputs
