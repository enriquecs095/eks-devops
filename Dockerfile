FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY ./target/demo-0.0.1.jar /app/demo-0.0.1.jar
CMD ["java", "-jar", "demo-0.0.1.jar"]