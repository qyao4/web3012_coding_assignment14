# 第一阶段: 构建 React 应用
# 使用官方 Node.js 16 版本的 Alpine Linux 镜像作为基础镜像
FROM node:16-alpine AS build

# 设置工作目录
WORKDIR /yao_qiang_final_site

# 将应用的 node_modules/.bin 目录添加到环境变量 PATH 中
ENV PATH /yao_qiang_final_site/node_modules/.bin:$PATH

# 复制 package.json 和 package-lock.json 文件到工作目录
COPY package.json ./
COPY package-lock.json ./

# 安装应用依赖
RUN npm ci --silent

# 复制应用的源代码到工作目录
COPY . ./

# 构建应用
RUN npm run build

# 第二阶段: 使用 Nginx 提供服务
# 使用官方 Nginx 的 Alpine Linux 镜像作为基础镜像
FROM nginx:alpine

# 将从构建阶段复制构建好的文件到 Nginx 服务器的服务目录
COPY --from=build /yao_qiang_final_site/build /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 使用默认的 Nginx 配置启动服务器
CMD ["nginx", "-g", "daemon off;"]
