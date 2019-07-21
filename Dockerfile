FROM alpine/git as clone 
WORKDIR /app
RUN git clone https://github.com/TechPrimers/docker-mysql-spring-boot-example

FROM maven:3.5-jdk-8-alpine as build
WORKDIR /app
COPY --from=clone /app/docker-mysql-spring-boot-example /app
RUN mvn install -DskipTests

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/target/users-mysql.jar /app
EXPOSE 8086
ENTRYPOINT ["java", "-jar", "users-mysql.jar"]
