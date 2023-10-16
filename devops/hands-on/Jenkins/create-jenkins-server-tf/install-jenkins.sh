#! /bin/bash
dnf update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf upgrade
dnf install java-11-amazon-corretto -y
dnf install jenkins -y
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
dnf install git -y