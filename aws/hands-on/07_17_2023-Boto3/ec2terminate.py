import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-07c570183582a1a5d').terminate()