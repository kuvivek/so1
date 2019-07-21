# so1
Multi-container App on Kubernetes

Building an image
```
vivek@vivek:~/Desktop/Docker/so1$ sudo docker build -t kuvivek/users-mysql:latest .`
[sudo] password for vivek: 
Sending build context to Docker daemon  1.418GB
Step 1/12 : FROM alpine/git as clone
 ---> a1d22e4b51ad
Step 2/12 : WORKDIR /app
 ---> Using cache
 ---> 4a09ad1c052a
Step 3/12 : RUN git clone https://github.com/TechPrimers/docker-mysql-spring-boot-example
 ---> Using cache
 ---> 5087b49120c1
Step 4/12 : FROM maven:3.5-jdk-8-alpine as build
 ---> fb4bb0d89941
Step 5/12 : WORKDIR /app
 ---> Using cache
 ---> 938a0ce7ce37
Step 6/12 : COPY --from=clone /app/docker-mysql-spring-boot-example /app
 ---> Using cache
 ---> 7c506e2035ca
Step 7/12 : RUN mvn install -DskipTests
 ---> Using cache
 ---> ec953e776673
Step 8/12 : FROM openjdk:8-jre-alpine
 ---> f7a292bbb70c
Step 9/12 : WORKDIR /app
 ---> Using cache
 ---> 9e07bec0adeb
Step 10/12 : COPY --from=build /app/target/users-mysql.jar /app
 ---> Using cache
 ---> 01508d17d12b
Step 11/12 : EXPOSE 8086
 ---> Using cache
 ---> 2177cee63a73
Step 12/12 : ENTRYPOINT ["java", "-jar", "users-mysql.jar"]
 ---> Using cache
 ---> 1832eeb7ef70
Successfully built 1832eeb7ef70
Successfully tagged kuvivek/users-mysql:latest
```

Tagging the image and pushing it to the docker hub.

```
vivek@vivek:~/Desktop/Docker/so1$ sudo docker tag kuvivek/users-mysql kuvivek/users-mysql:0.1.0
vivek@vivek:~/Desktop/Docker/so1$ sudo docker push kuvivek/users-mysql:0.1.0
The push refers to repository [docker.io/kuvivek/users-mysql]
9518b344d270: Pushed 
652a71d164fb: Pushed 
edd61588d126: Mounted from library/openjdk 
9b9b7f3d56a0: Mounted from library/openjdk 
f1b5933fe4b5: Mounted from library/openjdk 
0.1.0: digest: sha256:8be15223ed4e1c86b7b6679a251397338a6349d8a31b3033971fdbfb11db3623 size: 1365
vivek@vivek:~/Desktop/Docker/so1$ 
```
