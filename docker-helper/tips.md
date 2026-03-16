# Docker Helper Tips

## Dockerfile最佳实践
1. 使用具体版本标签，避免 `latest`
2. 合并RUN指令减少层数
3. 将不常变的指令放前面利用缓存
4. 使用多阶段构建减小最终镜像
5. 使用 `.dockerignore` 排除不需要的文件
6. 非root用户运行容器

## docker-compose常用操作
```bash
docker-compose up -d          # 后台启动
docker-compose down           # 停止并删除
docker-compose logs -f        # 查看日志
docker-compose ps             # 查看状态
docker-compose exec web sh    # 进入容器
docker-compose build --no-cache  # 重新构建
```

## 镜像优化要点
- Alpine基础镜像: ~5MB vs Ubuntu ~70MB
- 多阶段构建: 编译与运行分离
- 清理缓存: `apt-get clean && rm -rf /var/lib/apt/lists/*`
- 合并COPY指令
- 使用 `docker image prune` 清理无用镜像

## 调试技巧
```bash
docker logs <container>       # 查看日志
docker exec -it <container> sh  # 进入容器
docker inspect <container>    # 查看详情
docker stats                  # 资源使用
docker system df              # 磁盘占用
```
