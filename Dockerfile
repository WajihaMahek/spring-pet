# Dockerfile (place at the repository root)
FROM eclipse-temurin:17-jdk-jammy   # Java 17 base; change if you use another JDK
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /app.jar
# Expose the app port (optional; used for documentation)
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
