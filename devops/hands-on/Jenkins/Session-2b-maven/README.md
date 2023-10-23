# Hands-on Jenkins-03 : Java and Maven Jobs in Jenkins

Purpose of the this hands-on training is to learn how to install Java and Maven to Jenkins Server and configure Maven/Java Jobs.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install and configure Maven,

- create Java and Maven jobs

## Outline

- Part 1 - Install Java, Maven and Git packages

- Part 2 - Maven Settings

- Part 3 - Creating Package Application - Free Style Maven Job

- Part 4 - Configuring Jenkins Pipeline with GitHub Webhook to Build the Java Code

- Part 5 - Configuring Jenkins Pipeline with GitHub Webhook to Build the a Java Maven Project

## Part 1 - Install Java, Maven and Git packages

- Connect to the Jenkins Server 
  
- Install the JDK for Amazon Corretto 17
  
```bash
sudo dnf update -y
sudo dnf install java-17-amazon-corretto-devel
```

- Install Maven
  
```bash
sudo su
cd /opt
rm -rf maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
tar -zxvf $(ls | grep apache-maven-*-bin.tar.gz)
rm -rf $(ls | grep apache-maven-*-bin.tar.gz)
ln -s $(ls | grep apache-maven*) maven
echo 'export M2_HOME=/opt/maven' > /etc/profile.d/maven.sh
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /etc/profile.d/maven.sh
exit
source /etc/profile.d/maven.sh
```
- Install Git
  
```bash
sudo dnf install git -y
```

## Part 2 - Maven Settings

- Open Jenkins GUI on web browser

- Setting System Maven Path for default usage
  
- Go to `Manage Jenkins`
  - Select `System`
  - Find `Environment variables` part,
  - Click `Add`
    - for `Name`, enter `PATH+EXTRA` 
    - for `Value`, enter `/opt/maven/bin`
- Save

- Setting a specific Maven Release in Jenkins for usage
  
- Go to the `Tools` at `System Configuration`
- To the bottom, `Maven` section
  - Give a name such as `maven-3.9.5`
  - Select `install automatically`
  - `Install from Apache` version `3.9.5`
- Save

## Part 3 - Creating Package Application - Free Style Maven Job

- Select `New Item`

- Enter name as `Package-Application`

- Select `Free Style Project`

```yaml
- General:
- Description : This Job is packaging Java-Tomcat-Sample Project and creates a war file.

- Discard old builds: 
   Strategy:
     Log Rotation:
       Days to keep builds: 5 
       Max#of builds to keep: 3

- Source Code Management:
    Git:
      Repository URL: https://github.com/clarusway-aws-devops/java-tomcat-sample-main.git

    Branches to build: Go to the web browser and check the branch name of the git project `https://github.com/clarusway-aws-devops/java-tomcat-sample-main.git`.

- It is public repo, no need for `Credentials`.

- Build Environments: 
   - Delete workspace before build starts
   - Add timestamps to the Console Output

- Build Steps:
    Invoke top-level Maven targets:
      - Maven Version: maven-3.9.5
      - Goals: clean package
  - POM: pom.xml

- Post-build Actions:
    Archive the artifacts:
      Files to archive: **/*.war 
```

- Finally `Save` the job.

- Select `Package-Application`

- Click `Build Now` option.

- Observe the Console Output

## Part 4 - Configuring Jenkins Pipeline with GitHub Webhook to Build the Java Code

- To build the `java` code with Jenkins pipeline using the `Jenkinsfile` and `GitHub Webhook`, we will leverage from the same job created in *** Hands-on-02 Part 2*** (named as `pipeline-with-jenkinsfile-and-webhook`). To accomplish this task, we need;

  - a java code to build

  - a java environment to run the build stages on the java code

  - a Jenkinsfile configured for an automated build on our repo

- Create a java file on the `jenkins-pipeline-project` local repository(we have created in *** Hands-on-02 Part 2*** ), name it as `Hello.java`, add coding to print `Hello from Java` and save.

```java
public class Hello {

    public static void main(String[] args) {
        System.out.println("Hello from Java");
    }
}
```

- Since the Jenkins Server is running on Java platform, we can leverage from the already available java environment.

- Update the `Jenkinsfile` with the following pipeline script, and explain the changes.


```groovy
pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                echo 'Compiling the java source code'
                sh 'javac Hello.java'
            }
        }
        stage('run') {
            steps {
                echo 'Running the compiled java code.'
                sh 'java Hello'
            }
        }
    }
}
```

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'updated jenkinsfile and added Hello.java'
git push
```

- Observe the new built triggered with `git push` command on the Jenkins project page.

- Explain the role of java environment, `Jenkinsfile` and GitHub Webhook in this automation.

## Part 5 - Configuring Jenkins Pipeline with GitHub Webhook to Build the a Java Maven Project

- To build the `java maven project` with Jenkins pipeline using the `Jenkinsfile` and `GitHub Webhook`. To accomplish this task, we need;

  - a java code to build

  - a java environment to run the build stages on the java code

  - a maven environment to run the build stages on the java code

  - a Jenkinsfile configured for an automated build on our repo

- Create a public project repository `jenkins-maven-project` on your GitHub account.

- Clone the `jenkins-maven-project` repository on local computer.

- Copy the files given within the hands-on folder [hello-app](./hello-app)  and paste under the `jenkins-maven-project` GitHub repo folder.

- Go to your Github `jenkins-maven-project` repository page and click on `Settings`.

- Click on the `Webhooks` on the left hand menu, and then click on `Add webhook`.

- Copy the Jenkins URL from the AWS Management Console, paste it into `Payload URL` field, add `/github-webhook/` at the end of URL, and click on `Add webhook`.

```text
http://ec2-54-144-151-76.compute-1.amazonaws.com:8080/github-webhook/
```

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `pipeline-with-jenkinsfile-and-webhook-for-maven-project` then select `Pipeline` and click `OK`.

```yaml
- General:
- Description : Simple pipeline configured with Jenkinsfile and GitHub Webhook for Maven project

- Build Triggers:
    - GitHub hook trigger for GITScm polling

- Pipeline:
    Definition:
        Pipeline script from SCM:
            Git:
                Repository URL:
                    - https://github.com/<your_github_account_name>/jenkins-maven-project/
                
                Branches to build: It must be same branch name with your `jenkins-first-webhook-project` Github repository. If your repository's default branch name is "main", then change "master" to "main".
```

- Click `apply` and `save`. Note that the script `Jenkinsfile` should be placed under root folder of repo.

- Create a `Jenkinsfile` with the following pipeline script, and explain the script.

- For native structured Jenkins Server

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn -f hello-app/pom.xml -B -DskipTests clean package'
            }
            post {
                success {
                    echo "Now Archiving the Artifacts....."
                    archiveArtifacts artifacts: '**/*.jar'
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn -f hello-app/pom.xml test'
            }
            post {
                always {
                    junit 'hello-app/target/surefire-reports/*.xml'
                }
            }
        }
    }
}
```

- Commit and push the changes to the remote repo on GitHub.

```bash
git add .
git commit -m 'added jenkinsfile and maven project'
git push
```

- Observe the new built triggered with `git push` command on the Jenkins project page.