FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY target/HW3-0.0.1-SNAPSHOT.jar /app/

EXPOSE 8080

CMD ["java", "-jar", "HW3-0.0.1-SNAPSHOT.jar"]