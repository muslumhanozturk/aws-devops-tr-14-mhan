#!/bin/bash
apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/
TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
git clone https://$TOKEN@github.com/awsdevopsteam/aws-capstone-project-14.git
cd /home/ubuntu/aws-capstone-project-14
apt install python3-pip -y
apt-get install python3.7-dev libmysqlclient-dev -y
pip3 install -r requirements.txt
cd /home/ubuntu/aws-capstone-project-14/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80