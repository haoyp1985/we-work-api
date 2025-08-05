# 多阶段构建，优化镜像大小
FROM openjdk:17-jdk-slim as builder

# 设置工作目录
WORKDIR /app

# 复制Maven配置文件
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# 下载依赖（利用Docker缓存）
RUN ./mvnw dependency:go-offline -B

# 复制源代码
COPY src ./src

# 构建应用
RUN ./mvnw clean package -DskipTests -B

# 运行时镜像
FROM openjdk:17-jre-slim

# 创建应用用户
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# 设置工作目录
WORKDIR /app

# 安装必要的工具
RUN apt-get update && apt-get install -y \
    curl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# 从构建阶段复制JAR文件
COPY --from=builder /app/target/*.jar app.jar

# 创建日志目录
RUN mkdir -p logs && chown -R appuser:appgroup logs

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 暴露端口
EXPOSE 18086

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:18086/actuator/health || exit 1

# 切换到应用用户
USER appuser

# JVM参数优化
ENV JAVA_OPTS="-Xms512m -Xmx2048m -XX:+UseG1GC -XX:+UseContainerSupport \
               -XX:MaxGCPauseMillis=200 -XX:+PrintGC -XX:+PrintGCDetails \
               -XX:+PrintGCTimeStamps -XX:+HeapDumpOnOutOfMemoryError \
               -XX:HeapDumpPath=logs/ -Djava.security.egd=file:/dev/./urandom"

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

# 元数据标签
LABEL maintainer="WeWork Platform Team <platform@wework.com>"
LABEL version="1.0.0"
LABEL description="WeWork Platform AI Agent Service"
LABEL org.opencontainers.image.title="ai-agent-service"
LABEL org.opencontainers.image.description="AI智能体管理服务"
LABEL org.opencontainers.image.vendor="WeWork Platform"
LABEL org.opencontainers.image.source="https://github.com/wework/platform"