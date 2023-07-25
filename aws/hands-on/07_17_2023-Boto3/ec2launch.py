import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance
instances = ec2.create_instances(
     ImageId='ami-06ca3ca175f37dd66',
     MinCount=1,
     MaxCount=1,
     InstanceType='t2.micro',
     KeyName='second-key-pair'
 )