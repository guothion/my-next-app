# 阶段1：基础依赖（复用层，减少构建时间）
FROM node:20-alpine AS base
# 安装 pnpm（Node 20+ 可直接用 corepack 启用，无需手动装）
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app
# 复制 pnpm 锁文件和包配置（优先缓存，减少重建时间）
COPY pnpm-lock.yaml package.json ./
# pnpm 安装生产依赖（--prod 等价于 npm 的 --omit=dev）
RUN pnpm install --prod --frozen-lockfile

# 阶段2：开发模式（热更新、调试）
FROM base AS dev
# 安装所有依赖（含devDependencies，不加 --prod）
RUN pnpm install --frozen-lockfile
# 暴露 Next.js 默认开发端口
EXPOSE 3000
# 启动开发服务（--host 0.0.0.0 允许宿主机访问）
CMD ["pnpm", "run", "dev"]

# 阶段3：生产构建
FROM base AS build
COPY . .
# 构建生产包（pnpm run build 等价于 npm run build）
RUN pnpm run build

# 阶段4：生产运行
FROM base AS prod
# 复制构建产物
COPY --from=build /app/.next /app/.next
COPY --from=build /app/public /app/public
COPY --from=build /app/package.json /app/package.json
COPY --from=build /app/next.config.mjs /app/next.config.mjs
EXPOSE 3000
# 启动生产服务
CMD ["pnpm", "start"]