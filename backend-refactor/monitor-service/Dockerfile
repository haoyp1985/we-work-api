# 第一阶段：构建应用
FROM openjdk:17-jdk-slim as builder

WORKDIR /app

# 复制 Maven 配置文件
COPY pom.xml .
COPY ../pom.xml ../

# 复制源代码
COPY src src

# 构建应用
RUN apt-get update && apt-get install -y maven && \
    mvn clean package -DskipTests

# 第二阶段：运行时环境
FROM openjdk:17-jre-slim

# 创建应用用户
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

# 从构建阶段复制 JAR 文件
COPY --from=builder /app/target/monitor-service.jar app.jar

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8083/monitor/actuator/health || exit 1

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 8083

# JVM 参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0"

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]