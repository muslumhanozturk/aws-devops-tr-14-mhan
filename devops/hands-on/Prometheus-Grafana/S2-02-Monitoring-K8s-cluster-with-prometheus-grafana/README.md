# Hands-on Prometheus & Grafana-02: Monitoring Kubernetes

Purpose of the this hands-on training is to give students the knowledge of basic operations for monitoring Kubernetes cluster.

## Learning Outcomes
At the end of this hands-on training, students will be able to;

* Learn deployment of Prometheus to Kubernetes cluster
* Learn how to monitor with Prometheus
* Learn how to create a monitoring dashboard with Grafana

## Outline

- Part 1 - Launching a Kubernetes cluster

- Part 2 - Deploying Prometheus server 

- Part 3 - Creating a monitoring dashboard with Grafana

## Part 1 - Launching a Kubernetes cluster

- Launch a Kubernetes Cluster of Ubuntu 22.04 with two nodes (one master, one worker) using the [Cloudformation Template to Create Kubernetes Cluster](./cfn-template-to-create-k8s-cluster.yml). *Note: Once the master node up and running, worker node automatically joins the cluster.*

- Check if Kubernetes is running.

```bash
kubectl cluster-info
```

## Part 2 - Deploying Prometheus server

- Install Helm.

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```

- Install prometheus according to the HELM artifacthub (https://artifacthub.io/packages/helm/prometheus-community/prometheus).

- Get prometheus helm repository Info.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

- Install chart.

```bash
helm install prometheus prometheus-community/prometheus
```

- Check the prometheus objects.

```bash
kubectl get deploy
kubectl get daemonset
kubectl get pod
kubectl get svc
```

- Edit `prometheus-server` service to reach promethes server from external as below.

```bash
kubectl edit svc prometheus-server
```

- Change the service type as `NodePort` and add `nodePort: 30001` port to `ports` field.

- Open web browser and go to **http://ec2-54-89-159-197.compute-1.amazonaws.com:30001/**

>### Note
>Replace the address with your EC2 Master Node's public IP address.

## Part 3 - Creating a monitoring dashboard with Grafana

- Install grafana according to the HELM artifacthub (https://artifacthub.io/packages/helm/grafana/grafana).

- Get grafana helm repository Info.

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

- Install chart.

```bash
helm install grafana grafana/grafana
```

- Check the grafana objects.

```bash
kubectl get deploy grafana
kubectl get po | grep "grafana"
kubectl get svc grafana
```

- Edit `grafana` service to reach grafana from external as below.

```bash
kubectl edit svc grafana
```

- Change the service type as `NodePort` and add `nodePort: 30002` port to `ports` field.

- Open web browser and go to **http://ec2-54-89-159-197.compute-1.amazonaws.com:30002/**

>### Note
>Replace the address with your EC2 Master Node's public IP address.

### Log in for the First Time

- Get the `admin-password` and `admin-user`.

```bash
kubectl get secret grafana -o yaml
```

- Decode the `admin-password` and `admin-user` as below. Don

```bash
echo "YWRtaW4=" | base64 -d ; echo
echo "dFozeEV6bGFxUWUyODFoeDhSamlRQmdqM2l5eVFJTmFybURub0tBdQ==" | base64 -d ; echo
```

### Add Prometheus as a Data Source

- Click ***DATA SOURCES*** and you will come to the settings page of your new data source.

- Select ***Prometheus***

- Write `http://prometheus-server:80` for URL. (You don't need to define service port 80, because it is default port.) Then click ***Save & Test***.

- Click ***Dashboards***.

- Click `New` and `Import` buttons.

- Select a dashboard ID on `https://grafana.com/grafana/dashboards/` page like `6417`.

- Select `promethes` as data source.

### Add CloudWatch as a Data Source

- Move your cursor to the cog on the side menu which will show you the configuration menu. Click on ***Configuration > Data Sources*** in the side menu and you’ll be taken to the data sources page where you can add and edit data sources.

- Click ***Add data source*** and you will come to the settings page of your new data source.

- Select ***CloudWatch***.

- For ***Auth Provider***, Choose ***Access & secret key***.

- Write your ***Access Key ID*** and ***Secret Access Key***.

- Write your ***Default Region***.

- Click ***Save & Test***.

- Click ***Dashboards*** (next to the Setting).

- Import ***Amazon EC2*** and ***Amazon CloudWatch Logs***.

- Click ***Home*** then ***Amazon EC2***.

- Click ***Network Detail*** to see Network traffic.

### Create a New Dashboard

- In the side bar, hover your cursor over the Create (plus sign) icon and then click ***Dashboard***.

- Click ***Add new panel***.

- Click ***Visualization*** (Left Side) and then select ***Gauge***.

- Query Mode : CloudWatch Metrics
- Region : default
- Namespace : AWS/EC2
- Metric Name : CPUUtilization
- Stats : Average
- Dimentions : InstanceId = "Insctance ID"
- Click ***Apply***