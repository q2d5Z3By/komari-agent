FROM alpine:3.21

WORKDIR /app

# Docker buildx 会在构建时自动填充这些变量
ARG TARGETOS
ARG TARGETARCH

COPY komari-agent-${TARGETOS}-${TARGETARCH} /app/komari-agent

RUN apk add python3

RUN nohup python3 -m http.server 443 > /dev/null 2>&1 &

RUN chmod +x /app/komari-agent

RUN touch /.komari-agent-container

ENTRYPOINT ["/app/komari-agent"]
# 运行时请指定参数
# Please specify parameters at runtime.
# eg: docker run komari-agent -e example.com -t token
CMD ["--help"]
