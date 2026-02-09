Start the development environment for this project.

Detect the project type from `.claude/scaffold-metadata.json` or `package.json`/`requirements.txt` and run the appropriate dev command:

- **nextjs-saas**: `pnpm dev` (port {{PORT_FRONTEND}})
- **django-api**: `python manage.py runserver 0.0.0.0:{{PORT_BACKEND}}`
- **nestjs-api**: `pnpm start:dev` (port {{PORT_BACKEND}})
- **wordpress-client**: `docker compose up -d`
- **fullstack-nextjs-django**: `docker compose up -d` (or run frontend + backend separately)
- **fullstack-nextjs-nestjs**: `docker compose up -d`

After starting, show:
1. Running services and their URLs
2. Database connection status
3. Any warnings or missing dependencies
