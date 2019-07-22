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

In order to verify with the docker-compose, to luanch both Spring Boot java application and mysql database

Execute the following command as listed below
```
vivek@vivek:~/Desktop/Docker/so1$ 
vivek@vivek:~/Desktop/Docker/so1$ sudo docker-compose up -d
[sudo] password for vivek: 
Creating network "so1_internal" with the default driver
Creating mysql-standalone ... 
Creating mysql-standalone ... done
Creating so1_users-mysql_1 ... 
Creating so1_users-mysql_1 ... done
vivek@vivek:~/Desktop/Docker/so1$ 
vivek@vivek:~/Desktop/Docker/so1$ 
```

In order to verify whether, the services are currently running or not, check for both the processes
```
vivek@vivek:~/Desktop/Docker/so1$ 
vivek@vivek:~/Desktop/Docker/so1$ sudo docker-compose ps
      Name                    Command             State            Ports         
---------------------------------------------------------------------------------
mysql-standalone    docker-entrypoint.sh mysqld   Up      0.0.0.0:3306->3306/tcp
so1_users-mysql_1   java -jar users-mysql.jar     Up      0.0.0.0:8086->8086/tcp 
vivek@vivek:~/Desktop/Docker/so1$ 
vivek@vivek:~/Desktop/Docker/so1$ 
```
In order to deploy and test in the Kubernetes, please look for the steps below.

1) Start the minikube
```
$
$ minikube start
* minikube v1.2.0 on linux (amd64)
* Creating none VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
* Configuring environment for Kubernetes v1.15.0 on Docker 18.09.5
  - kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
* Pulling images ...
* Launching Kubernetes ...
* Configuring local host environment ...
* Verifying: apiserver proxy etcd scheduler controller dns
* Done! kubectl is now configured to use "minikube"
$
$
```

2) Create a folder like so1 under the /opt file system.
```
$ mkdir -p /opt/so1
$
$
```
3) Create a deployment plan, beneath this folder. The deployment plan created within this
is under the namespace of users-credential.

```
$
$ cd /opt/so1
$
$ vi complete-demo.yml
$
```
4) First create a namespace, so that all your resources are within that namespace, as all
the resources, which I have created is under the users-credential

```
$
$ kubectl create namespace users-credential
namespace/users-credential created
$
```

5) Apply the namespace within so that necessary resources are create within the namespace
viz. users-credential.

```
$
$ kubectl apply -f complete-demo.yml
deployment.extensions/users created
configmap/javaapp-configmap created
service/users created
deployment.extensions/mysql-db created
service/mysql-db created
$
$ kubectl get pods
No resources found.
$
$ kubectl get pods -n users-credential
NAME                       READY   STATUS              RESTARTS   AGE
mysql-db-fbdc74944-krk7f   0/1     ContainerCreating   0          17s
users-b8dc5449f-vdn2j      1/1     Running             0          17s
$
$
```

In order to scale up the java application resource, it can be increased or decreased by
making neccessary change at Line number 9. And then applying the consolidated configuration
file.

```
$
$ grep -rn -C4 "replicas" complete-demo.yml
5-  labels:
6-    name: users
7-  namespace: users-credential
8-spec:
9:  replicas: 1
10-  template:
11-    metadata:
12-      labels:
13-        name: users
--
73-  labels:
74-    name: mysql-db
75-  namespace: users-credential
76-spec:
77:  replicas: 1
78-  template:
79-    metadata:
80-      labels:
81-        name: mysql-db
$
```
