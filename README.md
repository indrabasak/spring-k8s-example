[![Build Status][travis-badge]][travis-badge-url]
[![Quality Gate][sonarqube-badge]][sonarqube-badge-url] 
[![Technical debt ratio][technical-debt-ratio-badge]][technical-debt-ratio-badge-url] 
[![Coverage][coverage-badge]][coverage-badge-url]

![](./img/kubernetes-docker.svg)

Spring Boot Example with Kubernetes and Docker
================================================
This is an example of using a Spring Boot application with Kubernetes and Docker. 


### Build
To build the JAR, execute the following command from the parent directory:

```
mvn clean package dockerfile:build
```

### Docker Run
Run the newly created Docker image, `basaki/spring-k8s-example:1.0.0`, by 
executing the `docker run` command from the terminal:

```bash
docker run --rm -p 8080:8080  --name=doritos basaki/spring-k8s-example:1.0.0
```

This should start up the example application at port `8080`. 

```bash
 .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.0.1.RELEASE)

2018-10-15 21:38:51.794  INFO 1 --- [           main] com.basaki.server.ServerApplication      : Starting ServerApplication on d01038b4d76d with PID 1 (/app.jar started by root in /)
2018-10-15 21:38:51.973  INFO 1 --- [           main] com.basaki.server.ServerApplication      : No active profile set, falling back to default profiles: default

2018-10-15 21:39:00.227  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2018-10-15 21:39:00.301  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]

```

From the browser, you can access the application swagger UI page 
at `http://localhost:8080/swagger-ui.html`

![](./img/server.png)


### Usage
- Access the client Swagger UI at `https://localhost:7081/swagger-ui.html`. 

- Make a POST request to create a book. The client in turn makes a request to the
server to create a book.

![](./img/client-post-req.png)

- If the request is successful, you should get a similar response as shown below:

![](./img/client-post-rsp.png)

- Make a GET request to retrieve the newly created book. The client in turn
 makes a request to the server to retrieve the book. An example response 
 is shown below:
 
 ![](./img/client-get-req-rsp.png)
 
 
### Kubernete

ibasa-mb-56452:Downloads indra.basak$ kubectl version
Client Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.4", GitCommit:"7243c69eb523aa4377bce883e7c0dd76b84709a1", GitTreeState:"clean", BuildDate:"2017-03-07T23:53:09Z", GoVersion:"go1.7.4", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.3", GitCommit:"2bba0127d85d5a46ab4b778548be28623b32d0b0", GitTreeState:"clean", BuildDate:"2018-05-21T09:05:37Z", GoVersion:"go1.9.3", Compiler:"gc", Platform:"linux/amd64"}
ibasa-mb-56452:Downloads indra.basak$ kubectl config current-context
docker-for-desktop
ibasa-mb-56452:Downloads indra.basak$ kubectl cluster-info
Kubernetes master is running at https://localhost:6443
KubeDNS is running at https://localhost:6443/api/v1/proxy/namespaces/kube-system/services/kube-dns

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
ibasa-mb-56452:Downloads indra.basak$ kubectl get nodes
NAME                 STATUS    AGE
docker-for-desktop   Ready     14d
ibasa-mb-56452:Downloads indra.basak$ kubectl get pods — namespace=kube-system
Error from server (NotFound): pods "—" not found
ibasa-mb-56452:Downloads indra.basak$ kubectl get pods 
No resources found.

[travis-badge]: https://travis-ci.org/indrabasak/spring-k8s-example.svg?branch=master
[travis-badge-url]: https://travis-ci.org/indrabasak/spring-k8s-example/

[sonarqube-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=alert_status
[sonarqube-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example 

[technical-debt-ratio-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=sqale_index
[technical-debt-ratio-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example 

[coverage-badge]: https://sonarcloud.io/api/project_badges/measure?project=com.basaki%3Aspring-k8s-example&metric=coverage
[coverage-badge-url]: https://sonarcloud.io/dashboard/index/com.basaki:spring-k8s-example
