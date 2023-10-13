# Hands-on Maven-01 : Using Maven As a Build Tool

Purpose of the this hands-on training is to teach the students how to use Maven with Java as a build tool.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Maven and Java-11 on Amazon Linux EC2 instance

- explain various build phases of a Java Application

- use Maven's clean, compile, package, install and site commands


## Outline

- Part 1 - Launch Amazon Linux EC2 Instance with Cloudformation Template

- Part 2 - Generate a Java application using Maven's Archetype Plugin

- Part 3 - Run Maven Commands


## Part 1 - Launch Amazon Linux EC2 Instance and Connect with SSH

- Launch an EC2 instance using ```maven-java-template.yml``` file located in this folder.
    - This template will create an EC2 instance with Java-11 and Maven.

- Connect to your instance with SSH.

- Check if you can see the Maven's binary directory under ```/home/ec2-user/```.

- Run the command below to check if Java is available.

```bash
java -version
```

- Cat ```~/.bash_profile``` file to check if Maven's path is correctly transferred. If not paste the necessary lines manually.

```
# Append the lines below into ~/.bash_profile file by making necessary changes.
M2_HOME=/home/ec2-user/<apache-maven-directory-with-its-version>
export PATH=$PATH:$M2_HOME/bin
```

- Run the command below to check if mvn commands are available.

```bash
mvn --version
```

- If not, run the command below and wait for the EC2 machine to get ready.

```bash
sudo reboot
```

## Part 2 - Generate a Java application using Maven's Archetype Plugin

- Run the command below to produce an outline of a Java project with Maven.

```bash
mvn archetype:generate -DgroupId=com.clarus.maven -DartifactId=maven-experiment -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- Cd into the project folder.

- Run the command below to be able to use tree command.

```bash
sudo dnf install -y tree
```

- Run the command below to show the directory structure of the project.

```bash
tree
```

- Go into the folder where App.java resides and ```cat``` the auto generated ```hello world``` application in Java.

- Replace the content of the App.java file with the content of the App.java file in this repo.

- Go into the project's root folder.

- Replace the content of the ```pom.xml``` file with the content of the pom.xml file in this repo.

- Explain that ```dependencyManagement``` section in the pom file will import multiple dependencies with compatible versions.  


## Part 3 - Run Maven Commands


>### mvn compile
 
- Run the command below.

```bash
mvn compile
```

- Go into the folder ```<project-root>/target/classes/``` and show the class file.

- Run the command below to show how to test a Maven project.


>### mvn clean test

```bash
mvn clean test
```

- Show that there is a new folder named ```target``` in the project root. 

- inspect the target folder with tree command.

- Show the content of the file ```<project-root>/target/surefire-report/com.clarus.maven.AppTest.txt``` as the output of the test.


>### mvn package

- Run the command below.

```bash
mvn clean package
```

- Go into the folder ```<project-root>/target/``` and show the ```maven-experiment-1.0-SNAPSHOT.jar``` file as the output of the ```mvn package``` command.

- Run the command below to start the application.

```bash
java -jar maven-experiment-1.0-SNAPSHOT.jar
```

- Explain the error in the standard output. 
    - Maven's jar file is not an executable jar file. The jar file does not have both the ```Main Class``` and the necessary packages to run the application. 

- Add the plugin below to the pom file and run ```mvn clean package``` command again.

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-assembly-plugin</artifactId>
      <executions>
          <execution>
              <phase>package</phase>
              <goals>
                  <goal>single</goal>
              </goals>
              <configuration>
                  <archive>
                  <manifest>
                      <mainClass>
                          com.clarus.maven.App
                      </mainClass>
                  </manifest>
                  </archive>
                  <descriptorRefs>
                      <descriptorRef>jar-with-dependencies</descriptorRef>
                  </descriptorRefs>
              </configuration>
          </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

```bash
mvn clean package
```


>### Run The Application

- Now, open up a fresh terminal on your local computer and run the command below.

```bash
scp -i <path-to-your-pem-file> -r <path-to-your-home-directory>/.aws ec2-user@<IP-of-your-instance>:/home/ec2-user/
```

- Check if the the credentials are transferred to EC2 instance.

- Go into your target folder.

- Run the command below to start the application. This time we are running the executable jar file with suffix ```jar-with-dependencies```.

```bash
java -jar maven-experiment-1.0-SNAPSHOT-jar-with-dependencies.jar
```

- Explain what the application does in the background.
    - Note that to be able see the object and the S3 bucket, we should comment the lines 142 and 150.


>### mvn install

- Run the command below to install our own package into .m2 folder.

```bash
mvn install
```

- Go into ```~/.m2/repository``` folder and show where our package is installed.


>### mvn site

- Run the command below.

```bash
mvn clean site
```

- Show the output ```site``` directory under target directory.

- Run the command below to install Apache Server.

```bash
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

- Run the command below to copy the contents of the site folder under ```/var/www/html``` folder.

```bash
sudo cp -a site/. /var/www/html
```

- Go to http://<public-node-ip> on browser to check project site.


## Multi-stage builds with maven (Optional)

- Install docker

```bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo usermod -a -G docker ec2-user
newgrp docker
```

- Create a folder named `docker`.

```
mkdir docker && cd docker
```

- Create a maven project.

```bash
mvn archetype:generate -DgroupId=com.clarus.maven -DartifactId=myproject -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- Add the maven-assembly-plugin to the pom file to run application.

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-assembly-plugin</artifactId>
      <executions>
          <execution>
              <phase>package</phase>
              <goals>
                  <goal>single</goal>
              </goals>
              <configuration>
                  <archive>
                  <manifest>
                      <mainClass>
                          com.clarus.maven.App
                      </mainClass>
                  </manifest>
                  </archive>
                  <descriptorRefs>
                      <descriptorRef>jar-with-dependencies</descriptorRef>
                  </descriptorRefs>
              </configuration>
          </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

- Create a multi-stage Dockerfile.

```Dockerfile
FROM maven:3.9.4-eclipse-temurin-8-alpine AS builder
COPY /myproject /app
WORKDIR /app
RUN mvn clean package

FROM openjdk:11-jre-slim
COPY --from=builder /app/target/myproject-1.0-SNAPSHOT-jar-with-dependencies.jar /app/app.jar
WORKDIR /app
CMD ["java","-jar","app.jar"]
```

- Build the image.

```bash
docker build -t maven-project .
```

- Run the container.

```
docker run maven-project
```