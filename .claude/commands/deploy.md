Deploy the project to production.

Steps:
1. Run tests first (`/test`) - abort if tests fail
2. Build production assets
3. Build Docker image(s)
4. Push to registry (if configured)
5. Deploy via configured method (Docker, Cloudflare, etc.)

Preset-specific:
- **nextjs-saas**: `pnpm build && docker build -t {{PROJECT_NAME}}-frontend .`
- **django-api**: `docker build -t {{PROJECT_NAME}}-backend .`
- **nestjs-api**: `pnpm build && docker build -t {{PROJECT_NAME}}-backend .`
- **wordpress-client**: `docker build -t {{PROJECT_NAME}}-wordpress .`
- **fullstack-***: Build both frontend and backend images

After deploy, show:
1. Build status and size
2. Deployment URL (if available)
3. Any post-deploy checks needed
