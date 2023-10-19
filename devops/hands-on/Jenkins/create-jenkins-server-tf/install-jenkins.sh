#! /bin/bash
dnf update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf upgrade -y
dnf install fontconfig java-17-amazon-corretto-devel -y
dnf install jenkins -y
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
dnf install git -y