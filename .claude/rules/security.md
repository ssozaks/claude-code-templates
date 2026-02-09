# Security Rules

## Secrets Management
- NEVER hardcode API keys, passwords, tokens, or secrets in code
- NEVER commit .env files (must be in .gitignore)
- Use environment variables for all configuration
- .env.example contains ONLY placeholder values: `changeme_generate_strong_password`
- Rotate secrets if accidentally committed (even if immediately reverted)

## Input Validation
- Validate ALL user input at system boundaries
- Use Zod schemas (frontend) or class-validator/serializers (backend)
- Sanitize HTML input to prevent XSS
- Use parameterized queries to prevent SQL injection
- Validate file uploads: type, size, extension

## Authentication & Authorization
- Use JWT or session-based auth (project-specific)
- Check permissions on EVERY API endpoint
- Implement rate limiting on auth endpoints
- Use HTTPS for all communication
- Set secure cookie flags: HttpOnly, Secure, SameSite

## OWASP Top 10 Awareness
1. **Injection:** Parameterized queries, input sanitization
2. **Broken Auth:** Strong passwords, MFA, session management
3. **Sensitive Data:** Encryption at rest and in transit
4. **XXE:** Disable external entity processing
5. **Broken Access Control:** Verify permissions on every request
6. **Misconfiguration:** No debug mode in production, secure headers
7. **XSS:** Escape output, Content Security Policy
8. **Deserialization:** Validate all deserialized data
9. **Known Vulnerabilities:** Keep dependencies updated
10. **Logging:** Log security events, monitor anomalies

## Django-Specific
- CSRF middleware enabled
- `DEBUG = False` in production
- `ALLOWED_HOSTS` properly configured
- Use `django.contrib.auth` password validation

## Next.js-Specific
- No secrets in `NEXT_PUBLIC_*` variables (client-exposed)
- Use API routes for server-side operations
- Sanitize dynamic routes and query params
- Set security headers in next.config.js

## NestJS-Specific
- Use Guards for authentication
- Use Pipes for input validation
- Enable CORS with specific origins
- Use Helmet middleware for security headers
