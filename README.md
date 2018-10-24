[![Build Status][travis-badge]][travis-badge-url]
[![Quality Gate][sonarqube-badge]][sonarqube-badge-url] 
[![Technical debt ratio][technical-debt-ratio-badge]][technical-debt-ratio-badge-url] 
[![Coverage][coverage-badge]][coverage-badge-url]

![](./img/kubernetes-docker.svg)

Spring Boot Example with Kubernetes and Docker
================================================
This is an example of using a Spring Boot application with Kubernetes and Docker. 


## Docker

### Maven Plugin
In this example, Spotify's [Dockerfile Maven Plugin](https://github.com/spotify/dockerfile-maven) 
is used for creating the Docker image. Spotify reccomends you to use this plugin 
instead of [Docker Maven plugin](https://github.com/spotify/docker-maven-plugin).

Here is the change to this project's `pom.xml`.

```xml
<plugin>
    <groupId>com.spotify</groupId>
    <artifactId>dockerfile-maven-plugin</artifactId>
    <version>1.4.4</version>
    <executions>
        <execution>
            <id>default</id>
            <goals>
                <goal>build</goal>
                <goal>push</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        <repository>basaki/spring-k8s-example</repository>
        <tag>${project.version}</tag>
        <buildArgs>
            <JAR_FILE>${project.build.finalName}.jar</JAR_FILE>
        </buildArgs>
    </configuration>
</plugin>
```

### Build
To build the docker image, execute `mvn clean install` command from the parent directory:

``` bash
$ mvn clean install
...

[INFO]  ---> Using cache
[INFO]  ---> f5d60c9391eb
[INFO] Step 8/8 : ENTRYPOINT ["java", "-Dapp.port=${app.port}", "-jar","/app.jar"]
[INFO] 
[INFO]  ---> Using cache
[INFO]  ---> 3e84ee5ba1cd
[INFO] [Warning] One or more build-args [JAR_FILE] were not consumed
[INFO] Successfully built 3e84ee5ba1cd
[INFO] Successfully tagged basaki/spring-k8s-example:1.0.0
[INFO] 
[INFO] Detected build of image with id 3e84ee5ba1cd
[INFO] Successfully built basaki/spring-k8s-example:1.0.0
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 52.519 s
[INFO] Finished at: 2018-10-21T19:55:36-07:00
[INFO] Final Memory: 67M/525M
[INFO] ------------------------------------------------------------------------
```

If the build is successful, it should create a new Docker image namedm 
`basaki/spring-k8s-example:1.0.0`.

### Verify
You can list all the docker images by typing `docker images` in any terminal,

```bash
$ docker images 
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
basaki/spring-k8s-example                  1.0.0               3e84ee5ba1cd        10 minutes ago      532MB
<none>                                     <none>              963c418de905        14 minutes ago      532MB
<none>                                     <none>              5eeb5eb716b4        29 minutes ago      532MB
...
```

### Run
If you just want to run the newly created Docker image without kubernetes,  execute 
the `docker run` command from the terminal:

```bash
docker run --rm -p 9080:8080  --name=doritos basaki/spring-k8s-example:1.0.0
```

#### Options
The following flags are used in our `docker run` command:

- `--rm` flag automatically cleans up the container and removes the file systems 
when the container exit.

- `-p` flag maps a `container port` to a `host port`. A container by default, 
doesn't publish any of its port to outside world. To make the Spring Boot 
application availbale to the outside world, `-p` flag is used. In this case, a
container port of `8080` is mapped to a  host port of `9080`.

- `--name` flag names the Docker container as `doritos`. In absence of this flag, 
Docker generates a random name for the container.

```bash
 $ docker run --rm -p 9080:8080  --name=doritos basaki/spring-k8s-example:1.0.0
 
   .   ____          _            __ _ _
  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
 ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
   '  |____| .__|_| |_|_| |_\__, | / / / /
  =========|_|==============|___/=/_/_/_/
  :: Spring Boot ::        (v2.0.6.RELEASE)
 
 2018-10-22 04:50:21.656  INFO 1 --- [           main] com.basaki.k8s.Application               : Starting Application on 98b7510ea7bb with PID 1 (/app.jar started by root in /)
 ...
 2018-10-22 04:50:40.666  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
 2018-10-22 04:50:40.676  INFO 1 --- [           main] com.basaki.k8s.Application               : Started Application in 20.994 seconds (JVM running for 22.839)
```

This should start up the example application at port `9080`. The application 
Swagger UI page can be accessed at `http://localhost:9080/swagger-ui.html`.

![](./img/server.png)


### Usage
- Access the client Swagger UI at `https://localhost:9080/swagger-ui.html`. 

- Make a POST request to create a book. The client in turn makes a request to the
server to create a book.

![](./img/client-post-req.png)

- If the request is successful, you should get a similar response as shown below:

![](./img/client-post-rsp.png)

- Make a GET request to retrieve the newly created book. The client in turn
 makes a request to the server to retrieve the book. An example response 
 is shown below:
 
 ![](./img/client-get-req-rsp.png)
 
 
## Kubernetes

A `Pod` is the most basic building block of Kubernetes and represents a single
instance of an application. A Pod may contain one or more containers which
are tightly coupled. `Docker` is an example of a container runtime and is most
commonly used in Kubernetes.

A Pod is transient in nature and cannot self-heal itself. A Pod's replication,
self-healing, and fault tolerance capabilities are handled by a `Controller`. 
A `ReplicaSet` is an example of a controller.

A `Deployment` controller is used for creating and updating Pods and ReplicaSets.

A Kubernetes `Service` groups Pods to provide common endpoint to the outside world.

### Deploying an Application

A YAML file, `deployment.yml`, contains all the deployment details.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-example-deployment
spec:
  selector:
    matchLabels:
      app: spring-example-app
  replicas: 3
  template:
    metadata:
      labels:
        app: spring-example-app
    spec:
      containers:
      - name: spring-example-app
        image: basaki/spring-k8s-example:1.0.0
        ports:
        - containerPort: 8080
          name: server
        - containerPort: 8081
          name: management
``` 
A Deployment is created using the `kubectl create` command. The
object specification described in the `C file is passed as a 
command line parameter using the `-f` option.

```
$ kubectl create -f deployment.yml 
deployment.apps "spring-example-deployment" created
```

As defined in the YAML file, it also creates a ReplicaSet and Pods.

ReplicaSets can be listed using `kubectl get replicasets` coomand,

```
$ kubectl get replicasets
NAME                                   DESIRED   CURRENT   READY     AGE
spring-example-deployment-7b54459d5c   3         3         3         1h

```
Pods can be listed used the `kubectl get pods` command,

```
$ kubectl get pods
NAME                                         READY     STATUS    RESTARTS   AGE
spring-example-deployment-7b54459d5c-6t47x   1/1       Running   0          1h
spring-example-deployment-7b54459d5c-lz2xl   1/1       Running   0          1h
spring-example-deployment-7b54459d5c-v6v74   1/1       Running   0          1h
```

### Creating a Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-example-service
spec:
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30080
    name: http
  - port: 8081
    targetPort: 8081
    nodePort: 30081
    name: management
  selector:
    app: spring-example-app
  type: NodePort
```

```
$ kubectl create -f service.yml 
service "spring-example-service" created
```
`kubectl get service` or `kubectl get svc`

```yaml
$ kubectl get service
NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
kubernetes               ClusterIP   10.96.0.1       <none>        443/TCP                         6d
spring-example-service   NodePort    10.108.152.37   <none>        8080:30080/TCP,8081:30081/TCP   1m
```

```
kubectl describe svc spring-example-service
```

```
$ kubectl describe services spring-example-service
Name:                     spring-example-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=spring-example-app
Type:                     NodePort
IP:                       10.108.152.37
LoadBalancer Ingress:     localhost
Port:                     http  8080/TCP
TargetPort:               8080/TCP
NodePort:                 http  30080/TCP
Endpoints:                10.1.0.14:8080,10.1.0.15:8080,10.1.0.16:8080
Port:                     management  8081/TCP
TargetPort:               8081/TCP
NodePort:                 management  30081/TCP
Endpoints:                10.1.0.14:8081,10.1.0.15:8081,10.1.0.16:8081
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

[travis-badge]: https://travis-ci.org/indrabasak/spring-k8s-example.svg?branch=master
[travis-badge-url]: https://travis-ci.org/indrabasak/spring-k8s-example/

[sonarqube-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=alert_status
[sonarqube-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example 

[technical-debt-ratio-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=sqale_index
[technical-debt-ratio-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example 

[coverage-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=coverage
[coverage-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example
