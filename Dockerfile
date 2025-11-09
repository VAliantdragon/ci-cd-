# ------------------------------------
# Stage 1: Build Stage (Builder)
# Using Maven with Eclipse Temurin JDK 21 for building the application.
# Note: Using known good tag maven:3.9.6-eclipse-temurin-21
# ------------------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies first to leverage Docker layer caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code and build the application, skipping tests
COPY src ./src
# The 'package' goal creates the JAR in target/
RUN mvn clean package -DskipTests

# ------------------------------------
# Stage 2: Run Stage (Runtime Environment)
# Using a minimal JRE 21 image for security and size optimization.
# FIX: Switched from '21-jre-focal' to the known good tag '21-jre-jammy'
# ------------------------------------
FROM eclipse-temurin:21-jre-jammy

# Set the exposed port (Spring Boot default is 8080)
EXPOSE 8080

# Define a volume for Spring Boot's temporary directory mapping
VOLUME /tmp

# FIX: Use a wildcard (*) in the COPY command to safely target the final JAR.
# This ensures we get the repackaged JAR file regardless of the full version string.
# We copy the file from the /app/target directory of the build stage.
COPY --from=build /app/target/*.jar app.jar

# Run the application using the JRE
ENTRYPOINT ["java", "-jar", "/app.jar"]
