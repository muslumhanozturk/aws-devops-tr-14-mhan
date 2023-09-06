import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('your InstanceID').stop()