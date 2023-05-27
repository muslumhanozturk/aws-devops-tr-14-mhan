## AWS CLI Session 1 : 

- This hands on explains how to install and configure AWS CLI. We'll also see how to create and manipulate the resources in AWS via AWS CLI 

### References
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
- https://docs.aws.amazon.com/linux/al2023/ug/get-started.html
- https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html
- https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- installing CLI on Windows, Linux or MAC O/S

- configuring CLI

- creating a resources with CLI

- working with Amazon Linux 2023 AMI

## Outline

- Part 1 - Installation

- Part 2 - Configuration

- Part 3 - Examples of the CLI commands

- Part 4 - Working with the latest Amazon Linux 2023 AMI


## Part 1 - Installation

### Step-1  Installation CLI on your "Local" 

- You can use the link below to install AWS CLI V2 according to your O/S.

- General page:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


- Windows:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


- Mac:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
https://graspingtech.com/install-and-configure-aws-cli/


- Linux:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip  #install "unzip" if not installed
unzip awscliv2.zip
sudo ./aws/install
```

### Step-2 Installation CLI on EC2

#### Section-1 Creating an EC2 Amazon Linux 2

- Since  "Amazon Linux 2023" image is installed with "CLI Version 2" by default we create an EC2 instance with  "Amazon Linux 2" image so that we can practice how to uninstall CLI V1 and install CLI V2. 

```text
-AMI             : Amazon Linux 2
-Instance Type   : t2.micro
-Security Group  : SSH-22
```

#### Section-2 Update AWS CLI Version 1 on Amazon Linux-2 (comes default) to Version 2

- Connect EC2 with SSH and remove the CLI version 1 
```
sudo yum remove awscli -y 
```

- If the command above doesn't works you may try the other options
```
pip uninstall awscli
pip3 uninstall awscli 
```

- Install AWS CLI Version 2
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

- install "unzip" if not installed than unzip 
```
unzip awscliv2.zip 
sudo ./aws/install
```

- Update the path accordingly if needed (AWS CLI Version 1 uses>>>> /usr/bin/aws)
```
export PATH=$PATH:/usr/local/bin/aws
```
or you may type >>> "bash"



## Part-2  Configuration

### Step-1 Creating Access Key ID and Secret Access Key

- Go to the IAM service

- From the left hand menu 
```
  Click Users ---->> Select user---->>Security Credential--->> Access keys --->>>Create Access key 
```
### Step-2 Configuring (!!!!!!We keep going with Local)

- Configure your terminal with AWS Access Key ID and Secret Access Key for CLI
```
aws configure
```

- than fill the information and hit the ENTER 
```
AWS Access Key ID [None]: ****************
AWS Secret Access Key [None]: ****************
Default region name [None]: us-east-1
Default output format [None]: yaml
```

- Show the file inside the ./aws folder
```
cat .aws/config
cat .aws/credentials
```
- Check the existing profiles:
```
aws configure list-profiles (list of the profiles )
aws sts get-caller-identity (Who am I)
```

- Show how to use CLI on single terminal with multiple user:
```
aws configure --profile user1 (Configure the terminal for additional user )
aws s3 ls --profile user1
```
- Check the existing profiles again:
```
aws configure list-profiles 
```

- Switch the current profile to "custom user" profiles
```
export AWS_PROFILE=user1 
```

- Switch the current profile to "default" user profile again.
```
export AWS_PROFILE=default 
```

- try to use CLI after deactivate KEYs from IAM. 


## Part 3 Examples of the CLI commands: 

- talk about the anatomy of CLI commands 
```
aws 
aws help
aws s3 help
aws s3 cp help
```

### Step 1- IAM

- List and Create IAM user 
```
aws iam list-users

aws iam list-users --output table 

aws iam list-users | grep osvaldo

aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user
```

### Step 2 - S3

- check the existing S3 buckets and create a new bucket named "osvaldo-cli-bucket"
```
aws s3 ls
aws s3 mb s3://osvaldo-cli-bucket
```

- create a file in the existing directory and copy this file to newly created bucket 
```
touch in-class.yaml
aws s3 cp in-class.yaml s3://osvaldo-cli-bucket
```

- copy this file to new folder inside bucket 
```
aws s3 cp in-class.yaml s3://osvaldo-cli-bucket/new/in-class.yaml
aws s3 ls s3://osvaldo-cli-bucket/new/
```

- show the example of the user data that we used in IAM session while covering ROLES. Since we don't have any AWS CLI configuration while launching an EC2, the CLI command inside the EC2 fetch the data via ROLES rather than CLI credentials. 
```
#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 
```

- Check inside of the newly created bucket.
```
aws s3 ls s3://osvaldo-cli-bucket
```

- delete the object inside the bucket 
```
aws s3 rm s3://osvaldo-cli-bucket/new/in-class.yaml
```

- remove the bucket
```
aws s3 rb s3://osvaldo-cli-bucket --force
```


### Step 3 - EC2
- check the available commands for ec2 
```
aws ec2 help
```

- list the EC2 instances
```
aws ec2 describe-instances
```

- list the EC2 instances in specific region
```
aws ec2 describe-instances --region us-east-2 --output table 
```

-  Launch an EC2 instance (Note that this command may not work in PowerShell because of the different meaning of "\" )
```
aws ec2 run-instances \
   --image-id ami-0b5eea76982371e91 \
   --count 1 \
   --instance-type t2.micro \
   --key-name KEY_NAME_HERE #put your key name without ".pem"
```

- List the instances filtering with key name
```
aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" # put your key name
```

- List the instances only with specific attribute. This command list the Public IP addresses of all EC2
```
aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]"
```


- You can combine "filtering and query" 
```
aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" --query "Reservations[].Instances[].PublicIpAddress[]" #put your key name without .pem
```
and 


```
aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"
```

- You may want to call multiple values under the single attribute. For example under the "Instances" attribute I need both "InstanceId and PublicIpAddress":
```
aws ec2 describe-instances  \
  --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = KEY_NAME_HERE" \
  --query "Reservations[].Instances[].{Instance:InstanceId,PublicIp:PublicIpAddress}" #put your key name without pem
```


- Let's stop and terminate the instance
```
aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE #put your instance id

aws ec2 terminate-instances --instance-ids INSTANCE_ID_HERE #put your instance id
```

## Part-4  Working with the latest Amazon Linux 2023 AMI

- Call the latest version of AL2023
```
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --region us-east-1
```

- Filter the image ID of latest AL2023
```
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query 'Parameters[0].[Value]' --output text
```

- Launching EC2 instance with latest AL2023 AMI. 
```
aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query \
               'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro
```