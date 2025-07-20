# 使用多架构兼容的Alpine镜像（ARM64/AMD64均适用）
FROM node:16-alpine

# 设置维护者信息
LABEL maintainer="paulyao"

# 安装构建依赖（仅在需要时安装）
RUN apk add --no-cache git python3 make g++ \
    && git clone https://github.com/paulyao/naiveboom.git /naiveboom \
    && cd /naiveboom \
    && npm install \
    && apk del git python3 make g++  # 清理构建依赖

# 安装Redis
RUN apk add --no-cache redis

# 配置Redis
RUN sed -i "s/daemonize no/daemonize yes/" /etc/redis.conf \
    && echo "bind 0.0.0.0" >> /etc/redis.conf

# 设置工作目录
WORKDIR /naiveboom

# 暴露端口
EXPOSE 3000

# 使用进程守护方案（同时保持前台有进程运行）
CMD ["sh", "-c", "redis-server /etc/redis.conf & node run.js"]
