FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy jar from build stage - ONLY THIS COPY IS NEEDED
COPY --from=build /app/target/*.jar app.jar

# Render uses PORT env variable
EXPOSE 8888

ENTRYPOINT ["java","-jar","/app/app.jar"]