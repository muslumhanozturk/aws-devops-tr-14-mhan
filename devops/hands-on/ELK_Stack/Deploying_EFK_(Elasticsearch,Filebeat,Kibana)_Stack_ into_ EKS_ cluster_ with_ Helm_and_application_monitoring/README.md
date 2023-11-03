# Deploying EFK Stack (Elasticsearch, Kibana and Filebeat) with Helm and Microservice Application Logging on the EKS cluster:

Purpose of the this hands-on training is to give students the knowledge of how to install, configure and use EFK Stack on EKS Cluster with Helm and monitoring logs of kubernetes microservice application.

# Steps to Create EKS Cluster

## Part 1 - Installing kubectl and eksctl on Amazon Linux 2:

### Install kubectl:

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH.

- Connect to the instance with SSH.

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Download the Amazon EKS vended kubectl binary.

```bash
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
```

- Apply execute permissions to the binary.

```bash
chmod +x ./kubectl
```

- Copy the binary to a folder in your PATH. If you have already installed a version of kubectl, then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.

```bash
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
```

- (Optional) Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.

```bash
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
```

- After you install kubectl , you can verify its version with the following command:

```bash
kubectl version --short --client
```

### Install eksctl

- Download and extract the latest release of eksctl with the following command.

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/v0.111.0/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
```

- Move the extracted binary to /usr/local/bin.

```bash
sudo mv /tmp/eksctl /usr/local/bin
```

- Test that your installation was successful with the following command.

```bash
eksctl version
```

## Part 2 - Creating the Kubernetes Cluster on EKS

- If needed create ssh-key with commnad `ssh-keygen -f ~/.ssh/id_rsa`

- Configure AWS credentials. Or you can attach `AWS IAM Role` to your EC2 instance.

```bash
aws configure
```

- Create an EKS cluster via `eksctl`. It will take a while.

```bash
eksctl create cluster \
 --name aduncan \
 --region us-east-1 \
 --zones us-east-1a,us-east-1b,us-east-1c \
 --nodegroup-name my-nodes \
 --node-type t2.medium \
 --nodes 2 \
 --nodes-min 2 \
 --nodes-max 3 \
 --ssh-access \
 --ssh-public-key  ~/.ssh/id_rsa.pub \
 --managed
```

or 

```bash
eksctl create cluster --region us-east-1 --zones us-east-1a,us-east-1b,us-east-1c --node-type t2.medium --nodes 2 --nodes-min 2 --nodes-max 3 --name my-cluster
```

- Explain the deault values. 

```bash
eksctl create cluster --help
```

- Show the aws `eks service` on aws management console and explain `eksctl-my-cluster-cluster` stack on `cloudformation service`.


## Steps to Install Helm:
--------------------------------

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```


## Part-3 Install EFK stack in EKS cluster using Helm:

- Create  namespace with the name of efk.

```bash
kubectl create ns efk
kubectl get ns
```
- Install ELK Stack helm repo into your local repo with helm command.

```bash
helm repo add elastic https://helm.elastic.co
```
- Update your repo after installation.

```bash
helm repo update
```
- Liste your repo packages.

```bash
helm repo ls
```

- List your helm chart and manifest files.

```bash
helm search repo
```

## Part-4 EFK Stack (Elasticsearch, Filebeat, Kibana) installation and configuration in EKS cluster with Helm:

### Installation and configuration of Elasticsearch via Helm into EKS Cluster:

- Show your elastic/elasticsearch values and save it as elasticsearch.values file in order to make some configuration.

```bash
helm show values elastic/elasticsearch >> elasticsearch.values
```
**********************
**********************
# Not: Update master instance and replica number "1" in elasticsearch.values  config file.

* vi elasticsearch.values   #check and update replica and master node number with "1" and resources 2 GB. !!!

# if you get error with helm --->>> solution: curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
***********************
***********************


```bash
helm install elasticsearch elastic/elasticsearch -f elasticsearch.values -n efk
```

```bash
helm ls -n efk
```

```bash
kubectl get all -n efk
```

### Installation and configuration of Kibana via Helm into EKS Cluster:

```bash
helm show values elastic/kibana >> kibana.values
```
- Change the values configuration with LoadBalancer.

```bash
vi kibana.values
```
*****************
# update service type: LoadBalancer
*****************

```bash
helm install kibana elastic/kibana -f kibana.values -n efk
```

```bash
kubectl get all -n efk
```

******************
# KibanaLoadBalancer url: aad89579c647046619ae4d6efb9e631d-1736015238.us-east-1.elb.amazonaws.com:5601
******************

### Installation and configuration of Filebeat via Helm into EKS Cluster:

- Installation of Filebeat via Helm.

```bash
helm install filebeat elastic/filebeat -n efk
```

```bash
kubectl get all -n efk
```

```bash
kubectl get pvc -n efk
```


## Part-5 Kibana Dashboard configuration and sample app log monitoring:

### Dashboard configuration and index pattern creation:

* logs: system logs default

* Discover: create an index pattern
  
  - filebeat-*

  - select @timestamp

  - create an index pattern.

### Deployment of sample applications into EKS kubernetes environment:

```bash
kubectl apply -f php_apache.yaml
```

```bash
kubectl apply -f to_do.yaml
```

```bash
kubectl get all
```

* * * Reaching both of the applications from browser. 

- Open TCP port for 30001-30002 of EKS node and copy public URL in order to reach applications  from browser. 


## Kubernetes Logging commands from terminal:

*********************                               *************                               
kubectl logs my-pod                                 # dump pod logs (stdout)
kubectl logs -l name=myLabel                        # dump pod logs, with label name=myLabel (stdout)
kubectl logs my-pod --previous                      # dump pod logs (stdout) for a previous instantiation of a container
kubectl logs my-pod -c my-container                 # dump pod container logs (stdout, multi-container case)
kubectl logs -l name=myLabel -c my-container        # dump pod logs, with label name=myLabel (stdout)
kubectl logs my-pod -c my-container --previous      # dump pod container logs (stdout, multi-container case) for a previous instantiation of a container
kubectl logs -f my-pod                              # stream pod logs (stdout)
kubectl logs -f my-pod -c my-container              # stream pod container logs (stdout, multi-container case)
kubectl logs -f -l name=myLabel --all-containers    # stream all pods logs with label name=myLabel (stdout)
***********************   