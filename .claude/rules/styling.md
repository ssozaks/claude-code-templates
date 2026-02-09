---
paths:
  - "src/**/*.tsx"
  - "src/**/*.css"
  - "src/styles/**"
---

# Styling Rules

## Tailwind CSS
- Use Tailwind utility classes for all styling
- Mobile-first: start with base, add `sm:`, `md:`, `lg:` breakpoints
- Use `cn()` utility for conditional classes (from shadcn/ui)
- Group related classes: layout → spacing → typography → colors → effects

## shadcn/ui
- Use shadcn/ui components before creating custom ones
- Customize via CSS variables in globals.css
- Extend with `cn()` for project-specific variants
- Check shadcn/ui docs before building custom UI

## Responsive Design
- Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px)
- Test all pages at: 375px, 768px, 1024px, 1440px
- Touch targets minimum 44x44px on mobile
- No horizontal scroll on any viewport

## Typography
- Use fonts that support Turkish characters
- Safe fonts: Inter, Nunito, Poppins, Roboto, Open Sans
- Test rendering of: ğ Ğ ı İ ö Ö ş Ş ü Ü ç Ç
- Line height minimum 1.5 for readability

## Do Not
- Do NOT use inline styles
- Do NOT use CSS modules (use Tailwind)
- Do NOT hardcode colors; use CSS variables
- Do NOT use px for font sizes; use Tailwind scale
