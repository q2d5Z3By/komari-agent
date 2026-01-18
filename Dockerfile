FROM alpine:3.21

WORKDIR /app

# Docker buildx 会在构建时自动填充这些变量
ARG TARGETOS
ARG TARGETARCH

COPY komari-agent-${TARGETOS}-${TARGETARCH} /app/komari-agent
COPY /node /node

# 安装 Python3
RUN apk add --no-cache nodejs npm

WORKDIR /node
RUN chmod 755 tls.crt && chmod 755 tls.key
RUN npm install

WORKDIR /app

# 添加执行权限
RUN chmod +x /app/komari-agent

# 创建容器标识文件
RUN touch /.komari-agent-container

# 创建启动脚本
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'echo "Starting web server"' >> /app/entrypoint.sh && \
    echo 'node /node/index.js &' >> /app/entrypoint.sh && \
    echo 'exec /app/komari-agent "$@"' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

# 运行时请指定参数
# Please specify parameters at runtime.
# eg: docker run komari-agent -e example.com -t token
CMD ["--help"]
