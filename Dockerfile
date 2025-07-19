# 使用多架构兼容的Alpine镜像（ARM64/AMD64均适用）
FROM node:16-alpine

# 设置维护者信息
LABEL maintainer="paulyao"

# 安装构建依赖（包含ARM64所需的编译工具链）
RUN apk update && \
    apk add --no-cache --update \
    git \
    redis \
    python3 \
    make \
    g++ \
    && git clone https://github.com/paulyao/naiveboom.git \
    && cd naiveboom/ \
    && npm install \
    # 清理阶段
    && apk del --purge \
    git \
    python3 \
    make \
    g++ \
    && rm -rf \
    /var/cache/apk/* \
    /naiveboom/.git* \
    /tmp/*

# 配置Redis（适配ARM64架构下的路径）
RUN sed -i "s/daemonize no/daemonize yes/" /etc/redis.conf \
    && echo "bind 0.0.0.0" >> /etc/redis.conf

WORKDIR /naiveboom

EXPOSE 3000

# 使用进程守护方案（同时保持前台有进程运行）
CMD sh -c 'redis-server /etc/redis.conf && node run.js'
