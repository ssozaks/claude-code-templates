Run database migrations for this project.

Steps:
1. Show current migration status
2. Generate new migrations (if schema changes detected)
3. Apply pending migrations
4. Show final migration status

Preset-specific:
- **django-api / fullstack-nextjs-django**:
  ```bash
  python manage.py showmigrations
  python manage.py makemigrations
  python manage.py migrate
  ```
- **nestjs-api / fullstack-nextjs-nestjs**:
  ```bash
  pnpm migration:show
  pnpm migration:generate -- -n MigrationName
  pnpm migration:run
  ```

Safety:
- Always show what will change BEFORE applying
- Recommend backup before production migrations
- Show rollback command in case of issues
