# Hands-on IAM-01 

Purpose of the this hands-on training is to give basic understanding of how to use IAM and IAM components.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- understand root user and IAM user

- create IAM user 

- explain the credentials 

- create a settings for IAM user

- create a group

- anatomy of the policy and attaching policy to identities. 

- make troubleshooting about credentials

- create role and attach to EC2

## Outline

- Part 1 - Creating IAM user and arrange user settings

- Part 2 - Creating Groups

- Part 3 - Troubleshooting about credentials

- Part 4 - Creating role and attaching to EC2


## Part 1 - Creating IAM user and arrange user settings

- Log in  as a Root user. !!!! Please use "your individual root account."

- Show the Dashboard of IAM 

- Show IAM users "sign-in link" and customize it as alias . Tell the student to write down the account alias.

- Create IAM user with Administrator access for your daily work :

    - Explain that  unless it is needed,  students won't use root account anymore.
    - Explain policy Administrator access*  policy and policy format


- Specify user details: 

```
- Select "Users" from left hand menu  
- Click on "Add user"
- User details:
  1. User name: xxxxx
  2. Check "Provide user access to the AWS Management Console"
  3. Select "I want to create an IAM user"
  4. Console password >>>Custom password
  5. Uncheck "Users must create a new password at next sign-in"
  6. Click on Next
```

- Set permissions
```
Permissions options  : Select "Attach policies directly"
Permissions policies : AdministratorAccess 
Next 
Review and create
```
- Download .csv file

- Examine the newly created User

``` 
- Click on newly created User---->>> Security Credentials show the credentials. 

- Create bill settings: Since we'll not use root account for daily work, we also need to check our billing from IAM user console .So we need to make some setting for this issue if it not handled before.  

     - Right top of the page click your name ----> Select My account -->> IAM User and Role Access to Billing Information--->> Edit--->> 

- Sign Out and Sign in  with newly created IAM user with "Clarusway IAM user". 

- Check the users and Billing services to be accessible or not.

## Part 2 - Creating Groups

### Step 1  - Creating users of Database and Database Group

- Explain why we use group
- Create User with policy (users name: bill and tom )
- Create group of  database without policy (Group name : Database Group)
- Assign users to the Database Group 

### Step 2 Create users of AWS_DEVOPS Group

- Create group  with "power user" policy (Group name : AWS_DEVOPS Group)
- Explain Power User
- Create user "Kath" and assign user to the AWS_DEVOPS Group while creating users.
- Show the permissions of group and users.
- Add "Tom" user to  AWS_DEVOPS Group . 
- Show the Tom's permission  which come from "user defined" and "group defined". 
- Also explain what happens incase of multiple permissions. 

##  Part 3 - Troubleshooting about credentials

### Step 1 - What if you forget the password 

- Click User>>>>> Select user---->>Security Credential--->> Console sign-in---> Click "Manage console access"--->>Set  password >>>> Custom password

### Step 2-  Create secret access keys key 

  Click User>>>>> Select user---->>Security Credential--->> Access keys --->>>Create Access key 


### Step 3-  What if you forgot your secret access keys key 

  Click User>>>>> Select user---->>Security Credential--->> Go Access keys ---> Deactivate---->> Delete --->>>Create new 


##  Part 4 - Creating role and attaching to EC2

- Create a role :

```text
Trusted Entity : AWS services
Use case       : EC2
Permission     : S3FullAccess
Name           : MyFirstRole
```
- Launch an Instance ******without role :

```text
-AMI             : Amazon Linux 2
-Instance Type   : t2.micro
-Step 3: Configure Instance Details:

  - ****IAM role     : "None"

  - User data       :

#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 

- Security Group: HTTP & SSH Allowed

```
- Launch an Instance with  ****MyFirstRole:
```text
-AMI             : Amazon Linux 2
-Instance Type   : t2.micro
-Step 3: Configure Instance Details:

  - ****IAM role     : MyFirstRole

  - User data       :

#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 

- Security Group: HTTP & SSH Allowed

```
- Show that the instance without role wasn't able to access S3 bucket. So the web page couldn't fetch the index.html and cat.jpg file.