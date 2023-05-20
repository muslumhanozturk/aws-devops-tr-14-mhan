# Hands-on 02 

Purpose of the this hands-on training is to create a Billing Alarm

## Learning Outcomes

- create a Billing Alarm

## Outline

- Part 1 - Creating a Billing Alarm

## Part 1 - Creating a Billing Alarm

### Section 1- Billing service settings.
1. Alert Setting:

- Navigate to "Billing" services from Search bar of console
-  Select "Billing preferences"  >>>>  "Alert preferences" then click on  "Edit"
- Enable "AWS Free Tier alerts" and "CloudWatch billing alerts"
- Then Save

2. IAM User/Role Settings:
- Right top of the page click your name ----> Select My account -->> IAM User and Role Access to Billing Information--->> Edit--->> Check to make "Activated"

### Section 2- Creating a Billing Alarm

!!!!!!!!!!!!Warning!!!!!!!!

If you have an existing billing alarm you may not encounter the same menu with the student. You need to select all billing alarm metrics manually. Like "Step 1"

But, If you don't have an existing billing alarm like students when you click on create on billing pane all the settings will fetched automatically. Like "Step 2"

So choose one of these way seen below. 

#### Step 1: If you have billing alarm and create another billing alarm. 

```
- Select   "Alarms" >>>> "Billing"
- then Click on Create Alarm
- Select   "Metric >>> Billing >>> Total Estimated Charge >>> Currancy USD"
``` 

- Then click Select metric.
- Specify metric and conditions:

``` 
  Metric: keep it as is
  Conditions: 
     Threshold type                 : "Static "
     Whenever EstimatedCharges is...: "Greater or Greater/Equal"
     than..                         : 5/10 USD 
     Additional configuration       : Keep it as is

``` 

- Configure actions: 
``` 
  1.Notification:
    a.Alarm state trigger: In alarm (keep it as is)
    b.Send a notification to the following SNS topic:
        1) Select "Create new topic"
           - Enter Topic name 
           - Enter email
        2) Click on create Topic
        3) Go to the email and "Confirm subscription"(Sometimes it may be late)
        4) Since topic is created continue with "Select an existing SNS topic"
             
  2. Auto Scaling action    : keep it as is
  3. EC2 action             : keep it as is
  4. Systems Manager action : keep it as is
``` 
- Click on next 

- Add name and description:
``` 
  Alarm name  : Billing Alarm
  Descriptions: optional
``` 
- Preview and create

#### Step 2:

- Go to the AWS "Cloudwatch" service
- Navigate to to the Left hand menu 

```
- Select   "Alarms" >>>> "Billing"
- !!!!!!!Delete the billing alarms if exist.
- then Click on Create Alarm
```   

- you will see that 

``` 
Namespace: AWS/Billing
Metric name: Estimated Charge
Currency: USD
Statistic: Max
Period: 6 hours
``` 

- Configure actions: 
``` 
  1.Notification:
    a.Alarm state trigger: In alarm (keep it as is)
    b.Send a notification to the following SNS topic:
        1) Select "Create new topic"
           - Enter Topic name 
           - Enter email
        2) Click on create Topic
        3) Go to the email and "Confirm subscription"(Sometimes it may be late)
        4) Since topic is created continue with "Select an existing SNS topic"
             
  2. Auto Scaling action    : keep it as is
  3. EC2 action             : keep it as is
  4. Systems Manager action : keep it as is
``` 
- Click on next 

- Add name and description:
``` 
  Alarm name  : Billing Alarm
  Descriptions: optional
``` 
- Preview and create


