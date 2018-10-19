FROM openjdk:8-jre
VOLUME /tmp
MAINTAINER Indra Basak <indra.basak1@gmail.comr>
ADD target/spring-k8s-example-1.0.0.jar app.jar
RUN sh -c 'touch /app.jar'

EXPOSE 8080
ENV JAVA_OPTS=""

ENTRYPOINT ["java", "-Dapp.port=${app.port}", "-jar","/app.jar"]
