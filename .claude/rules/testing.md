---
paths:
  - "src/**/*.test.tsx"
  - "src/**/*.test.ts"
  - "**/__tests__/**"
  - "vitest.config.*"
  - "tests/setup.*"
---

# Frontend Testing Standards

## Test Runner
- **Vitest** for unit and component tests (preferred for Next.js/Vite projects)
- **React Testing Library** for component rendering and interaction
- **Playwright** for E2E tests (separate config, e2e/ directory)

## Component Testing Rules

### Query Priority (most to least preferred)
1. `getByRole` - Accessible by role (best for a11y)
2. `getByLabelText` - Form elements
3. `getByText` - Visible text content
4. `getByPlaceholderText` - Input placeholders
5. `getByTestId` - Last resort only

### Test User Behavior, Not Implementation
```typescript
// GOOD - Tests what user sees
expect(screen.getByRole('button', { name: /submit/i })).toBeEnabled();

// BAD - Tests internal state
expect(component.state.isSubmitting).toBe(false);
```

## What to Test Per Component Type

### Page Components
- Renders without error
- Loading and error states display correctly
- Data fetching integration (mock API calls)
- SEO metadata present (title, description)

### Form Components
- Validation messages display correctly (Turkish text)
- Submit success and error handling
- Required fields enforcement
- Turkish character input handling (I/i, ğ, ş, ü, ö, ç)
- Disabled state during submission

### Interactive Components (buttons, modals, dropdowns)
- Click/interaction triggers expected behavior
- Keyboard navigation works
- Focus management is correct
- ARIA attributes are present

### Layout Components
- Renders children correctly
- Conditional rendering based on auth state
- Responsive behavior (test with different viewports in E2E)

## Vitest Configuration Standard

```typescript
// vitest.config.ts - Base configuration
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';

export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
    include: ['src/**/*.test.{ts,tsx}'],
    coverage: {
      provider: 'v8',
      reporter: ['text-summary', 'lcov', 'json-summary'],
      reportsDirectory: './coverage',
      thresholds: {
        statements: 60,
        branches: 50,
        functions: 60,
        lines: 60,
      },
    },
  },
});
```

## Mocking

### API Calls
- Prefer MSW (Mock Service Worker) for API mocking
- Alternative: `vi.mock` for module-level mocks
- Always mock external API calls in unit tests

### Next.js Modules
```typescript
// Mock next/navigation
vi.mock('next/navigation', () => ({
  useRouter: () => ({ push: vi.fn(), back: vi.fn() }),
  usePathname: () => '/test',
  useSearchParams: () => new URLSearchParams(),
}));

// Mock next-intl
vi.mock('next-intl', () => ({
  useTranslations: () => (key: string) => key,
  useLocale: () => 'tr',
}));
```

### Never Mock
- React Testing Library itself
- The component being tested
- Built-in browser APIs (use jsdom)

## Snapshot Testing
- Use sparingly — only for design-system/shared UI components
- Update snapshots deliberately, not blindly with `--update`
- Prefer explicit assertions over snapshots for business logic

## Test Setup File
```typescript
// tests/setup.ts
import '@testing-library/jest-dom/vitest';
// Add global test utilities here
```

## Scripts in package.json
```json
{
  "test": "vitest run",
  "test:watch": "vitest",
  "test:coverage": "vitest run --coverage",
  "test:ui": "vitest --ui"
}
```
