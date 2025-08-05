# 多阶段构建
FROM openjdk:17-jdk-slim as builder

WORKDIR /app

# 复制项目文件
COPY pom.xml .
COPY src ./src

# 安装Maven
RUN apt-get update && apt-get install -y maven

# 构建应用
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:17-jre-slim

LABEL maintainer="WeWork Platform Team"
LABEL service="task-service"
LABEL version="1.0.0"

# 创建应用用户
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# 创建应用目录
RUN mkdir -p /app/logs && chown -R appuser:appgroup /app

WORKDIR /app

# 复制构建好的jar文件
COPY --from=builder /app/target/task-service.jar app.jar

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8084/task-service/actuator/health || exit 1

# 切换到应用用户
USER appuser

# 暴露端口
EXPOSE 8084

# JVM参数配置
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport \
               -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=80.0 \
               -XX:+PrintGCDetails -XX:+PrintGCTimeStamps \
               -Djava.security.egd=file:/dev/./urandom"

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]