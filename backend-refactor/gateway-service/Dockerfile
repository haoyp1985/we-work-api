# 多阶段构建 - Gateway Service
FROM openjdk:17-jdk-slim as builder

# 设置工作目录
WORKDIR /app

# 复制 Maven 文件
COPY ../pom.xml ./parent-pom.xml
COPY pom.xml ./
COPY ../common ./common/

# 复制源代码
COPY src ./src

# 构建应用
RUN apt-get update && apt-get install -y maven && \
    mvn dependency:go-offline -f parent-pom.xml && \
    mvn clean package -DskipTests -f parent-pom.xml

# 运行阶段
FROM openjdk:17-jre-slim

# 创建应用用户
RUN groupadd -r wework && useradd -r -g wework wework

# 设置工作目录
WORKDIR /app

# 安装必要工具
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 复制 JAR 文件
COPY --from=builder /app/target/*.jar app.jar

# 设置文件权限
RUN chown -R wework:wework /app

# 切换到应用用户
USER wework

# 暴露端口
EXPOSE 18080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:18080/actuator/health || exit 1

# 启动命令
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]