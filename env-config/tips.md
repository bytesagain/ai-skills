# Env Config Manager — tips.md
## .env 最佳实践
1. 每个项目都有 `.env.example`（不含真实值）
2. `.env` 加入 `.gitignore`
3. 变量名全大写下划线分隔: `DATABASE_URL`
4. 布尔值用 `true/false` 不用 `1/0`
5. 生产环境不要用 .env 文件，用环境变量注入

## 常见框架配置
### Node.js (dotenv)
```
PORT=3000
NODE_ENV=development
DATABASE_URL=postgresql://user:pass@localhost:5432/db
JWT_SECRET=change_me_in_production
```

### Python (python-dotenv)
```
FLASK_ENV=development
SECRET_KEY=change_me
SQLALCHEMY_DATABASE_URI=sqlite:///app.db
REDIS_URL=redis://localhost:6379/0
```

### Docker Compose
```
COMPOSE_PROJECT_NAME=myapp
POSTGRES_USER=admin
POSTGRES_PASSWORD=change_me
POSTGRES_DB=myapp
```
