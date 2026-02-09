# Language Protocol (Turkish-English Hybrid)

## User Communication
- User writes in TURKISH. This is natural and expected.
- Claude ALWAYS responds to the user in TURKISH.
- Explanations, questions, progress reports, error messages → TURKISH

## Internal Processing
- Extended thinking (reasoning process) runs in ENGLISH (default behavior)
- Agent Teams teammate spawn prompts → ENGLISH
- Subagent prompts → ENGLISH
- Research queries (WebSearch, WebFetch) → ENGLISH

## Code Output
- All code → ENGLISH (variable names, function names, class names)
- Code comments → ENGLISH
- Git commit messages → ENGLISH (Conventional Commits: feat/fix/refactor/docs)
- API endpoints → ENGLISH
- Database table/column names → ENGLISH (snake_case)

## Documentation
- CLAUDE.md → TURKISH (user reads this)
- .claude/rules/ → ENGLISH (Claude consumes these for better comprehension)
- OpenSpec spec files → ENGLISH (technical documentation)
- README.md → ENGLISH (for open source / GitHub)
- current-task.md → TURKISH (user tracks progress)

## UI Text (next-intl)
- Turkish and English translation files → respective languages
- Default language: Turkish (tr)

## Example Flow
1. User: "kullanici kayit formu yap"
2. Claude (thinking - English): "I need to create a user registration form..."
3. Claude (WebSearch - English): "Next.js React Hook Form Zod registration"
4. Claude (code - English): `function RegisterForm() { ... }`
5. Claude (response - Turkish): "Kayit formunu olusturdum. Zod ile validasyon eklendi..."
6. Claude (commit - English): "feat: add user registration form with Zod validation"

## Agent Teams Language Protocol
- Teammates spawn with ENGLISH prompts
- Teammates communicate with each other in ENGLISH
- Lead reports results to user in TURKISH
