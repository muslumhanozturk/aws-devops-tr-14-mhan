# Hands-on Docker-14 : Multi-stage builds

Purpose of the this hands-on training is to teach students how to create multi-stage Dockerfile.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create multi-stage Dockerfile.

## Outline

- Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Part 2 - multi-stage Dockerfile

## Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Launch a Docker machine on Amazon Linux 2 AMI with security group allowing SSH connections using the [Cloudformation Template for Docker Machine Installation](../S1A-docker-01-installing-on-ec2-linux2/docker-installation-template.yml).

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - multi-stage Dockerfile

- Multi-stage builds are useful to anyone who has struggled to optimize Dockerfiles while keeping them easy to read and maintain.

- With multi-stage builds, you use multiple FROM statements in your Dockerfile. Each FROM instruction can use a different base, and each of them begins a new stage of the build. You can selectively copy artifacts from one stage to another, leaving behind everything you don't want in the final image.

- By default, the stages aren't named, and you refer to them by their integer number, starting with 0 for the first FROM instruction. However, you can name your stages, by adding an `AS <NAME>` to the FROM instruction. This example improves the previous one by naming the stages and using the name in the COPY instruction. This means that even if the instructions in your Dockerfile are re-ordered later, the COPY doesn't break.

- Create a folder named `docker-lesson`.

```bash
mkdir docker-lesson && cd docker-lesson
```

- Create `App.java` file as below.

```java
public class App {
    public static void main(String[] args) {
        System.out.println("Welcome");
    }
}
```

- Create a Dockerfile as below. The following Dockerfile has two separate stages: one for creating a java class, and another where we copy the class into.

```Dockerfile
FROM openjdk:11-jdk-slim AS builder   
COPY . /app
WORKDIR /app
RUN javac App.java

FROM openjdk:11-jre-slim
WORKDIR /myapp
COPY --from=builder /app .
CMD ["java", "App"]
```

- Build and run the image.

```bash
docker build -t myimage .
docker run myimage
```

- How does it work? The second FROM instruction starts a new build stage with the |`openjdk:11-jre-slim` image as its base. The COPY `--from=builder` line copies just the built artifact from the previous stage into this new stage. The JDK and any intermediate artifacts are left behind, and not saved in the final image. Check the size of image and notice that the size of `myimage` is less than `openjdk:11-jdk-slim`
image.

- Check the size of images

```
docker image ls
```

- You get an output like this.

```bash
REPOSITORY                                   TAG                            IMAGE ID       CREATED         SIZE
myimage                                      latest                         554fd58105d1   15 hours ago    223MB
openjdk                                      11-jre-slim                    764a04af3eff   14 months ago   223MB
openjdk                                      11-jdk-slim                    8e687a82603f   14 months ago   424MB
```