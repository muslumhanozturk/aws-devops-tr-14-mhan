#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
echo "${MyDBURI}" > /home/ec2-user/dbserver.endpoint
TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
FOLDER="https://$TOKEN@raw.githubusercontent.com/clarusway/cw-workshop/aws/pr-004/aws/projects/004-phonebook-web-application/"
curl -s --create-dirs -o "/home/ec2-user/templates/index.html" -L "$FOLDER"templates/index.html
curl -s --create-dirs -o "/home/ec2-user/templates/add-update.html" -L "$FOLDER"templates/add-update.html
curl -s --create-dirs -o "/home/ec2-user/templates/delete.html" -L "$FOLDER"templates/delete.html
curl -s --create-dirs -o "/home/ec2-user/app.py" -L "$FOLDER"phonebook-app.py
python3 /home/ec2-user/app.py