# Hands-on Jenkins-05 : Deploying Application to Staging/Production Environment with Jenkins

Purpose of the this hands-on training is to learn how to deploy applications to Staging/Production Environment with Jenkins.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- deploy an application to Staging/Production Environment with Jenkins

- automate a Maven project as Pipeline.

## Outline

- Part 1 - Building Web Application

- Part 2 - Deploy Application to Staging Environment

- Part 3 - Update the application and deploy to the staging environment

- Part 4 - Deploy application to production environment

- Part 5 - Automate Existing Maven Project as Pipeline with Jenkins

## Part 1 - Building Web Application

- Select `New Item`

- Enter name as `build-web-application`

- Select `Free Style Project`

```yml
- General:
- Description : This job packages the java-tomcat-sample-main app and creates a war file.

- Discard old builds: 
   Strategy:
     Log Rotation:
       Days to keep builds: 5 
       Max#of builds to keep: 3

- Source Code Management:
    Git:
      Repository URL: https://github.com/clarusway-aws-devops/java-tomcat-sample-main

- It is public repo, no need for `Credentials`.

- Build Environments: 
   - Delete workspace before build starts
   - Add timestamps to the Console Output

- Build Steps:
    Invoke top-level Maven targets:
      - Maven Version: maven-3.9.2
      - Goals: clean package
  - POM: pom.xml

- Post-build Actions:
    Archive the artifacts:
      Files to archive: **/*.war 
```

- Finally `Save` the job.

- Click `Build Now` option.

- Observe the Console Output

## Part 2 - Deploy Application to Staging Environment

- Select `New Item`

- Enter name as `Deploy-Application-Staging-Environment`

- Select `Free Style Project`
```yml
- Description : This job deploys the java-tomcat-sample-main app to the staging environment.

- Discard old builds: 
   Strategy:
     Log Rotation:
       Days to keep builds: 5 
       Max#of builds to keep: 3

- Build Environments: 
   - Delete workspace before build starts
   - Add timestamps to the Console Output

- Build Steps:
    Copy artifact from another project:
      - Project name: build-web-application
      - Which build: Latest successful build
  - Check `Stable build only`
  - Artifact to copy: **/*.war

- Post-build Actions:
    Deploy war/ear to a container:
      WAR/EAR files: **/*.war
      Context path: /
      Containers: Tomcat 9.x Remote
      Credentials:
        Add: Jenkins
          - username: tomcat
          - password: tomcat
      Tomcat URL: http://<tomcat staging server private ip>:8080
```
- Click on `Save`.

- Go to the `Deploy-Application-Staging-Environment` 

- Click `Build Now`.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

## Part 3 - Update the application and deploy to the staging environment

-  Go to the `build-web-application`
   -  Select `Configure`
```yml
- Post-build Actions:
    Add post-build action:
      Build other projects:
        Projects to build: Deploy-Application-Staging-Environment
        - Trigger only if build is stable

- Build Triggers:
    Poll SCM: 
      Schedule: * * * * *
  (You will see the warning `Do you really mean "every minute" when you say "* * * * *"? Perhaps you meant "H * * * *" to poll once per hour`)
```
   - `Save` the modified job.

   - At `Project build-web-application`  page, you will see `Downstream Projects` : `Deploy-Application-Staging-Environment`

- Update the web site content, and commit to the GitHub.

- Go to the  `Project build-web-application` and `Deploy-Application-Staging-Environment` pages and observe the auto build & deploy process.

- Explain the built results.

- Open the staging server url with port # `8080` and check the results.

## Part 4 - Deploy application to production environment

- Go to the dashboard

- Select `New Item`

- Enter name as `Deploy-Application-Production-Environment`

- Select `Free Style Project`
```yml
- Description : This job deploys the java-tomcat-sample-main app to the production environment.

- Discard old builds: 
   Strategy:
     Log Rotation:
       Days to keep builds: 5 
       Max#of builds to keep: 3

- Build Environments: 
   - Delete workspace before build starts
   - Add timestamps to the Console Output
   - Color ANSI Console Outputoptions

- Build Steps:
    Copy artifact from another project:
      - Project name: build-web-application
      - Which build: Latest successful build
  - Check `Stable build only`
  - Artifact to copy: **/*.war

- Post-build Actions:
    Deploy war/ear to a container:
      WAR/EAR files: **/*.war
      Context path: /
      Containers: Tomcat 9.x Remote
      Credentials: tomcat/*****
      Tomcat URL: http://<tomcat production server private ip>:8080
```
- Click on `Save`.

- Click `Build Now`.

## Part 5 - Automate Existing Maven Project as Pipeline with Jenkins

-  Go to the `build-web-application`
   -  Select `Configure`

```yml
- Post-build Actions:
  *** Remove ---> Build other projects
```

- Go to the Jenkins dashboard and click on `New Item` to create a pipeline.

- Enter `build-web-application-code-pipeline` then select `Pipeline` and click `OK`.
```yml
- General:
    Description: This pipeline job packages the java-tomcat-sample-main app and deploys to both staging and production environment` in the description field.

    - Discard old builds: 
       Strategy:
         Log Rotation:
           Days to keep builds: 5 
           Max#of builds to keep: 3

- Pipeline:
    Definition: Pipeline script from SCM
    SCM: Git
      Repositories:
        - Repository URL: https://github.com/clarusway-aws-devops/java-tomcat-sample-main
        - Branches to build: 
            Branch Specifier: */main

    Script Path: Jenkinsfile
```

- `Save` and `Build Now` and observe the behavior.