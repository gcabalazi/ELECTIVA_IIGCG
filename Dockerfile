FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
WORKDIR /workspace
COPY pom.xml ./
RUN mvn --batch-mode --no-transfer-progress dependency:go-offline
COPY src ./src
RUN mvn --batch-mode --no-transfer-progress -DskipTests clean package

FROM eclipse-temurin:17-jre-alpine
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring
WORKDIR /application
COPY --from=build /workspace/target/users-management-2.1.0.jar application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/application/application.jar"]